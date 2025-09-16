import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/fee_provider.dart';
import '../../models/fee_payment.dart';

class TransactionSummaryScreen extends StatefulWidget {
  const TransactionSummaryScreen({super.key});

  @override
  State<TransactionSummaryScreen> createState() => _TransactionSummaryScreenState();
}

class _TransactionSummaryScreenState extends State<TransactionSummaryScreen> {
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
        title: const Text('Transaction Summary'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Consumer<FeeProvider>(
        builder: (context, feeProvider, child) {
          if (feeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Year Selection
                _buildYearSelector(),
                const SizedBox(height: 20),

                // Balance Overview
                _buildBalanceOverview(feeProvider),
                const SizedBox(height: 20),

                // Fee Categories Breakdown
                _buildFeeCategoriesBreakdown(feeProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Text(
            selectedAcademicYear,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
        ],
      ),
    );
  }

  Widget _buildBalanceOverview(FeeProvider feeProvider) {
    final totalFees = feeProvider.studentFees.fold<double>(0, (sum, fee) => sum + fee.amount);
    final totalPaid = feeProvider.studentFees.fold<double>(0, (sum, fee) => sum + fee.paidAmount);
    final balance = totalFees - totalPaid;
    final paidPercentage = totalFees > 0 ? (totalPaid / totalFees) * 100 : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Circular Progress Chart
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                children: [
                  // Background circle
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[100],
                    ),
                  ),
                  // Progress circle
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: paidPercentage / 100,
                      strokeWidth: 20,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        balance <= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  // Center content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Balance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${balance.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Summary stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Fees', '₹${totalFees.toStringAsFixed(0)}', Colors.blue),
                _buildStatItem('Paid', '₹${totalPaid.toStringAsFixed(0)}', Colors.green),
                _buildStatItem('Balance', '₹${balance.toStringAsFixed(0)}', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFeeCategoriesBreakdown(FeeProvider feeProvider) {
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
          'Fee Categories Breakdown',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...groupedFees.entries.map((entry) => _buildFeeCategoryBreakdown(entry.key, entry.value)),
      ],
    );
  }

  Widget _buildFeeCategoryBreakdown(String categoryName, List<FeePayment> fees) {
    final totalFee = fees.fold<double>(0, (sum, fee) => sum + fee.amount);
    final paidAmount = fees.fold<double>(0, (sum, fee) => sum + fee.paidAmount);
    final balance = totalFee - paidAmount;
    
    final isFullyPaid = balance <= 0;
    final isPartiallyPaid = paidAmount > 0 && balance > 0;
    
    String status = 'Pending';
    Color statusColor = Colors.orange;
    
    if (isFullyPaid) {
      status = 'Fully Paid';
      statusColor = Colors.green;
    } else if (isPartiallyPaid) {
      status = 'Partially Paid';
      statusColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Financial details
            Row(
              children: [
                Expanded(
                  child: _buildFinancialDetail('Total Fee', '₹${totalFee.toStringAsFixed(0)}', Colors.blue),
                ),
                Expanded(
                  child: _buildFinancialDetail('Paid Amount', '₹${paidAmount.toStringAsFixed(0)}', Colors.green),
                ),
                Expanded(
                  child: _buildFinancialDetail('Balance', '₹${balance.toStringAsFixed(0)}', Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialDetail(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
