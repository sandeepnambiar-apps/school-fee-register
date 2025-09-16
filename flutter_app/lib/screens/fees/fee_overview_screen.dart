import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/fee_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/fee_payment.dart';
import '../../widgets/common/custom_button.dart';
import 'package:go_router/go_router.dart';

class FeeOverviewScreen extends StatefulWidget {
  const FeeOverviewScreen({super.key});

  @override
  State<FeeOverviewScreen> createState() => _FeeOverviewScreenState();
}

class _FeeOverviewScreenState extends State<FeeOverviewScreen> {
  String selectedAcademicYear = '2025-26';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeeProvider>().loadStudentFees();
      context.read<FeeProvider>().loadPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fees'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              final role = auth.user?['role'] ?? 'Super Admin';
              if (role == 'PARENT') {
                return IconButton(
                  icon: const Icon(Icons.payment),
                  onPressed: () => _showPaymentOptions(context),
                  tooltip: 'Make Payment',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<FeeProvider>(
        builder: (context, feeProvider, child) {
          if (feeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Note
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: const Text(
                    'Note: Previous year fee details are available in History.',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 20),

                // Fee Categories
                _buildFeeCategories(feeProvider),
                const SizedBox(height: 20),

                // History and Summary
                _buildHistoryAndSummary(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeeCategories(FeeProvider feeProvider) {
    // Group fees by category
    final Map<String, List<FeePayment>> groupedFees = {};
    for (final fee in feeProvider.studentFees) {
      final category = fee.feeType;
      groupedFees.putIfAbsent(category, () => []).add(fee);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fee Categories',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...groupedFees.entries.map((entry) => _buildFeeCategoryCard(entry.key, entry.value)),
      ],
    );
  }

  Widget _buildFeeCategoryCard(String categoryName, List<FeePayment> fees) {
    final totalAmount = fees.fold<double>(0, (sum, fee) => sum + fee.amount);
    final paidAmount = fees.fold<double>(0, (sum, fee) => sum + fee.paidAmount);
    final balance = totalAmount - paidAmount;
    
    final isFullyPaid = balance <= 0;
    final isPartiallyPaid = paidAmount > 0 && balance > 0;
    
    String status = 'Pending';
    Color statusColor = Colors.orange;
    IconData statusIcon = Icons.pending;
    
    if (isFullyPaid) {
      status = 'Fully Paid';
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (isPartiallyPaid) {
      status = 'Partially Paid';
      statusColor = Colors.orange;
      statusIcon = Icons.payment;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToFeeDetails(categoryName, fees),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          categoryName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total: ₹${totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Paid: ₹${paidAmount.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.green[600]),
                      ),
                    ],
                  ),
                  if (balance > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Balance: ₹${balance.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.red[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ElevatedButton(
                          onPressed: () => _showPaymentDialog(categoryName, balance),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('Pay Now'),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryAndSummary() {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: InkWell(
              onTap: () => _navigateToHistory(),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'History',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Transaction details',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: InkWell(
              onTap: () => _navigateToSummary(),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'View',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Fee Summary Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToFeeDetails(String categoryName, List<FeePayment> fees) {
    // Navigate to detailed fee screen
    context.push('/fees/details', extra: {
      'categoryName': categoryName,
      'fees': fees,
    });
  }

  void _navigateToHistory() {
    context.push('/fees/history');
  }

  void _navigateToSummary() {
    context.push('/fees/summary');
  }

  void _showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Payment Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.blue),
              title: const Text('Pay Outstanding Fees'),
              subtitle: const Text('Pay all pending fees'),
              onTap: () {
                Navigator.pop(context);
                _showPaymentDialog('All Fees', 0.0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt, color: Colors.green),
              title: const Text('View Payment History'),
              onTap: () {
                Navigator.pop(context);
                _navigateToHistory();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(String categoryName, double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pay $categoryName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (amount > 0) ...[
              Text('Amount: ₹${amount.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
            ],
            const Text('Choose payment method:'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToPaymentScreen(categoryName, amount);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Pay with Razorpay'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _navigateToPaymentScreen(String categoryName, double amount) {
    context.push('/payment', extra: {
      'categoryName': categoryName,
      'amount': amount,
    });
  }
}
