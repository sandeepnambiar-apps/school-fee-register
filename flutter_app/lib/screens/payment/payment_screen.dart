import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/fee_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  final String categoryName;
  final double amount;

  const PaymentScreen({
    super.key,
    required this.categoryName,
    required this.amount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  String selectedPaymentMethod = 'UPI';
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Choose your payment method',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // Payment Methods
            _buildPaymentMethods(),
            const SizedBox(height: 30),

            // Important Note
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Note:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "After clicking on the 'Pay Now' button you might be taken to your bank's website for 3D secure authentication.",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Security Logos
            _buildSecurityLogos(),
            const SizedBox(height: 30),

            // Pay Now Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Processing...'),
                        ],
                      )
                    : const Text(
                        'Pay Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Terms and Conditions
            const Center(
              child: Text.rich(
                TextSpan(
                  text: 'By clicking the button you agree to the ',
                  style: TextStyle(fontSize: 12),
                  children: [
                    TextSpan(
                      text: 'Terms and conditions',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final paymentMethods = [
      {'name': 'Net Banking', 'icon': Icons.account_balance, 'value': 'netbanking'},
      {'name': 'Cards', 'icon': Icons.credit_card, 'value': 'cards'},
      {'name': 'UPI', 'icon': Icons.payment, 'value': 'upi'},
      {'name': 'Wallets', 'icon': Icons.wallet, 'value': 'wallets'},
      {'name': 'Bharat QR', 'icon': Icons.qr_code, 'value': 'bharatqr'},
    ];

    return Column(
      children: paymentMethods.map((method) {
        final isSelected = selectedPaymentMethod == method['value'];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: RadioListTile<String>(
            value: method['value'] as String,
            groupValue: selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                selectedPaymentMethod = value!;
              });
            },
            title: Row(
              children: [
                Icon(
                  method['icon'] as IconData,
                  color: isSelected ? Colors.red[600] : Colors.grey[600],
                ),
                const SizedBox(width: 12),
                Text(
                  method['name'] as String,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.red[600] : Colors.black,
                  ),
                ),
              ],
            ),
            activeColor: Colors.red[600],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSecurityLogos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Secure Payment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildSecurityLogo('Verified by VISA', Colors.blue),
            _buildSecurityLogo('MasterCard SecureCode', Colors.red),
            _buildSecurityLogo('AMERICAN EXPRESS SafeKey', Colors.green),
            _buildSecurityLogo('RuPay', Colors.orange),
            _buildSecurityLogo('PCI DSS', Colors.purple),
            _buildSecurityLogo('3D SECURE', Colors.indigo),
          ],
        ),
      ],
    );
  }

  Widget _buildSecurityLogo(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _processPayment() async {
    if (widget.amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select fees to pay')),
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      // Get user info
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.user;
      final userName = user?['firstName'] ?? 'User';
      final userEmail = user?['email'] ?? 'user@example.com';
      final userPhone = user?['phone'] ?? '9999999999';

      // Create Razorpay order
      final options = {
        'key': 'rzp_test_1DP5mmOlF5G5ag', // Replace with your Razorpay key
        'amount': (widget.amount * 100).toInt(), // Amount in paise
        'name': 'School Fee Register',
        'description': 'Payment for ${widget.categoryName}',
        'prefill': {
          'contact': userPhone,
          'email': userEmail,
          'name': userName,
        },
        'theme': {
          'color': '#FF6B6B',
        },
        'method': {
          'netbanking': selectedPaymentMethod == 'netbanking',
          'card': selectedPaymentMethod == 'cards',
          'upi': selectedPaymentMethod == 'upi',
          'wallet': selectedPaymentMethod == 'wallets',
        },
      };

      _razorpay.open(options);
    } catch (e) {
      setState(() {
        isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      isProcessing = false;
    });

    // Record payment in the system
    _recordPayment(response);

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 12),
            Text('Payment Successful'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment ID: ${response.paymentId}'),
            Text('Order ID: ${response.orderId}'),
            Text('Signature: ${response.signature}'),
            const SizedBox(height: 16),
            const Text(
              'Your payment has been processed successfully. You will receive a receipt shortly.',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to fees screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      isProcessing = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 30),
            SizedBox(width: 12),
            Text('Payment Failed'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Error Code: ${response.code}'),
            Text('Error Description: ${response.message}'),
            const SizedBox(height: 16),
            const Text(
              'Your payment could not be processed. Please try again or contact support.',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet selected: ${response.walletName}')),
    );
  }

  void _recordPayment(PaymentSuccessResponse response) async {
    try {
      final feeProvider = context.read<FeeProvider>();
      
      final paymentData = {
        'studentId': 'current_student', // You might want to get this from context
        'studentName': 'Current Student',
        'feeStructureId': widget.categoryName,
        'feeType': widget.categoryName,
        'amount': widget.amount,
        'paidAmount': widget.amount,
        'dueDate': DateTime.now().toIso8601String(),
        'paidDate': DateTime.now().toIso8601String(),
        'status': 'Completed',
        'paymentMethod': 'Razorpay',
        'transactionId': response.paymentId,
        'receiptNumber': response.orderId,
        'notes': 'Payment processed via Razorpay',
      };

      await feeProvider.recordPayment(paymentData, context);
    } catch (e) {
      print('Error recording payment: $e');
    }
  }
}
