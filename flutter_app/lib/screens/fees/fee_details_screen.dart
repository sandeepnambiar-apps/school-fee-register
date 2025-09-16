import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/fee_provider.dart';
import '../../models/fee_payment.dart';
import '../../widgets/common/custom_button.dart';
import 'package:go_router/go_router.dart';

class FeeDetailsScreen extends StatefulWidget {
  final String categoryName;
  final List<FeePayment> fees;

  const FeeDetailsScreen({
    super.key,
    required this.categoryName,
    required this.fees,
  });

  @override
  State<FeeDetailsScreen> createState() => _FeeDetailsScreenState();
}

class _FeeDetailsScreenState extends State<FeeDetailsScreen> {
  Set<String> selectedInstallments = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          if (widget.fees.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  selectedInstallments.clear();
                  for (int i = 0; i < widget.fees.length; i++) {
                    selectedInstallments.add(i.toString());
                  }
                });
              },
              child: const Text(
                'Select All',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Installment List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.fees.length,
              itemBuilder: (context, index) {
                final fee = widget.fees[index];
                final installmentNumber = index + 1;
                final isSelected = selectedInstallments.contains(index.toString());
                final isPaid = fee.status == 'Completed' || fee.status == 'Paid';
                final balance = fee.amount - fee.paidAmount;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Installment Header
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${_getOrdinalNumber(installmentNumber)} INSTALLMENT',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isPaid)
                              const Icon(Icons.check_circle, color: Colors.green, size: 24)
                            else
                              Checkbox(
                                value: isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedInstallments.add(index.toString());
                                    } else {
                                      selectedInstallments.remove(index.toString());
                                    }
                                  });
                                },
                                activeColor: Colors.blue[600],
                              ),
                          ],
                        ),
                        
                        // Due Date
                        if (!isPaid && fee.dueDate != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Due Date: ${_formatDate(fee.dueDate!)}',
                            style: TextStyle(
                              color: Colors.red[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        
                        // Amount Details
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isPaid) ...[
                                  Text(
                                    'Paid: ₹${fee.paidAmount.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Paid on: ${fee.paidDate != null ? _formatDate(fee.paidDate!) : 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ] else ...[
                                  Text(
                                    'Total to be paid: ₹${balance.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (isPaid)
                              TextButton.icon(
                                onPressed: () => _showReceipt(fee),
                                icon: const Icon(Icons.receipt, size: 16),
                                label: const Text('View Receipt'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue[600],
                                ),
                              )
                            else
                              TextButton.icon(
                                onPressed: () => _showInstallmentDetails(fee, installmentNumber),
                                icon: const Icon(Icons.info_outline, size: 16),
                                label: const Text('View Details'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue[600],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Payment Button
          if (selectedInstallments.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected: ${selectedInstallments.length} installment(s)',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '₹${_calculateSelectedAmount().toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Pay ₹${_calculateSelectedAmount().toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getOrdinalNumber(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}TH';
    }
    switch (number % 10) {
      case 1:
        return '${number}ST';
      case 2:
        return '${number}ND';
      case 3:
        return '${number}RD';
      default:
        return '${number}TH';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  double _calculateSelectedAmount() {
    double total = 0;
    for (final index in selectedInstallments) {
      final feeIndex = int.parse(index);
      if (feeIndex < widget.fees.length) {
        final fee = widget.fees[feeIndex];
        final balance = fee.amount - fee.paidAmount;
        total += balance;
      }
    }
    return total;
  }

  void _processPayment() {
    final selectedAmount = _calculateSelectedAmount();
    if (selectedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No amount to pay')),
      );
      return;
    }

    context.push('/payment', extra: {
      'categoryName': widget.categoryName,
      'amount': selectedAmount,
      'selectedInstallments': selectedInstallments.toList(),
    });
  }

  void _showReceipt(FeePayment fee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Receipt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReceiptItem('Receipt Number', fee.receiptNumber ?? 'N/A'),
            _buildReceiptItem('Transaction ID', fee.transactionId ?? 'N/A'),
            _buildReceiptItem('Amount Paid', '₹${fee.paidAmount.toStringAsFixed(0)}'),
            _buildReceiptItem('Payment Date', fee.paidDate != null ? _formatDate(fee.paidDate!) : 'N/A'),
            _buildReceiptItem('Payment Method', fee.paymentMethod),
            _buildReceiptItem('Status', fee.status),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement PDF generation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF receipt generation coming soon!')),
              );
            },
            child: const Text('Download PDF'),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _showInstallmentDetails(FeePayment fee, int installmentNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_getOrdinalNumber(installmentNumber)} Installment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Fee Type', fee.feeType),
            _buildDetailItem('Total Amount', '₹${fee.amount.toStringAsFixed(0)}'),
            _buildDetailItem('Paid Amount', '₹${fee.paidAmount.toStringAsFixed(0)}'),
            _buildDetailItem('Balance', '₹${(fee.amount - fee.paidAmount).toStringAsFixed(0)}'),
            _buildDetailItem('Due Date', fee.dueDate != null ? _formatDate(fee.dueDate!) : 'N/A'),
            _buildDetailItem('Status', fee.status),
            if (fee.notes != null) _buildDetailItem('Notes', fee.notes!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                selectedInstallments.add((installmentNumber - 1).toString());
              });
            },
            child: const Text('Select for Payment'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
