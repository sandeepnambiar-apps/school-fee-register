import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/fee_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/app_branding.dart';
import '../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeeProvider>().loadFeeStructures();
      context.read<FeeProvider>().loadStudentFees();
      context.read<FeeProvider>().loadPayments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fees Management'),
        backgroundColor: Colors.lightBlue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              final role = auth.user?['role'] ?? 'Super Admin';
              if (role == 'Parent') {
                return IconButton(
                  icon: const Icon(Icons.payment),
                  onPressed: () => _showPaymentDialog(context),
                  tooltip: 'Make Payment',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Fee Structure'),
            Tab(text: 'Student Fees'),
            Tab(text: 'Payments'),
          ],
        ),
      ),
      body: Column(
        children: [
          // App Branding for Mobile
          const AppBranding(),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _FeeStructureTab(),
                _StudentFeesTab(),
                _PaymentsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    final amountController = TextEditingController();
    final studentController = TextEditingController();
    String selectedPaymentMethod = 'Online';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Make Fee Payment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: studentController,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedPaymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                items: ['Online', 'Cash', 'Cheque'].map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) {
                  selectedPaymentMethod = value ?? 'Online';
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isNotEmpty && studentController.text.isNotEmpty) {
                if (selectedPaymentMethod == 'Online') {
                  _processOnlinePayment(
                    double.parse(amountController.text),
                    studentController.text,
                  );
                } else {
                  _processOfflinePayment(
                    double.parse(amountController.text),
                    studentController.text,
                    selectedPaymentMethod,
                  );
                }
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  void _processOnlinePayment(double amount, String studentName) {
    // Simple payment simulation without Razorpay
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Processing'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Processing payment of ₹${amount.toStringAsFixed(2)} for $studentName'),
            const SizedBox(height: 8),
            const Text('Please wait...', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );

    // Simulate payment processing
    final currentContext = context;
    Future.delayed(const Duration(seconds: 2), () {
      if (currentContext.mounted) {
        Navigator.of(currentContext).pop(); // Close loading dialog
        _showPaymentSuccessDialog(amount, studentName, currentContext);
      }
    });
  }

  void _showPaymentSuccessDialog(double amount, String studentName, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: 28),
            const SizedBox(width: 8),
            const Text('Payment Successful'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Payment of ₹${amount.toStringAsFixed(2)} has been processed successfully for $studentName.'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                children: [
                  Text(
                    'Transaction ID: ${DateTime.now().millisecondsSinceEpoch}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${DateTime.now().toString().split(' ')[0]}',
                    style: TextStyle(
                      color: Colors.green[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _processOfflinePayment(double amount, String studentName, String method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$method payment of ₹${amount.toStringAsFixed(2)} recorded for $studentName'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class _FeeStructureTab extends StatelessWidget {
  const _FeeStructureTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<FeeProvider>(
      builder: (context, feeProvider, child) {
        if (feeProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fee Structures',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      final role = auth.user?['role'] ?? 'Super Admin';
                      if (role == 'Parent') return const SizedBox.shrink();
                      return PrimaryButton(
                        text: 'Add Fee Structure',
                        onPressed: () => _showAddFeeStructureDialog(context),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: feeProvider.feeStructures.length,
                itemBuilder: (context, index) {
                  final fee = feeProvider.feeStructures[index];
                  return _buildFeeStructureCard(context, fee);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeeStructureCard(BuildContext context, Map<String, dynamic> fee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Icon(Icons.attach_money, color: Colors.green[700]),
        ),
        title: Text(fee['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fee['description']),
            Text('Amount: \$${fee['amount']?.toString() ?? '0'} - ${fee['frequency']}'),
            Text('Class: ${fee['class']} - ${fee['academicYear']}'),
          ],
        ),
        trailing: Chip(
          label: Text(fee['status']),
          backgroundColor: fee['status'] == 'Active' ? Colors.green[100] : Colors.grey[100],
        ),
      ),
    );
  }

  void _showAddFeeStructureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _AddFeeStructureDialog(),
    );
  }
}

class _StudentFeesTab extends StatelessWidget {
  const _StudentFeesTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<FeeProvider>(
      builder: (context, feeProvider, child) {
        if (feeProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Student Fees',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      final role = auth.user?['role'] ?? 'Super Admin';
                      if (role == 'Parent') return const SizedBox.shrink();
                      return PrimaryButton(
                        text: 'Add Student Fee',
                        onPressed: () => _showAddStudentFeeDialog(context),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: feeProvider.studentFees.length,
                itemBuilder: (context, index) {
                  final fee = feeProvider.studentFees[index];
                  return _buildStudentFeeCard(context, fee);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStudentFeeCard(BuildContext context, Map<String, dynamic> fee) {
    final isPaid = fee['status'] == 'Paid';
    final statusColor = isPaid ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor[100],
          child: Icon(
            isPaid ? Icons.check_circle : Icons.pending,
            color: statusColor[700],
          ),
        ),
        title: Text(fee['studentName']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fee: ${fee['feeName']}'),
            Text('Amount: \$${fee['amount']?.toString() ?? '0'}'),
            Text('Due Date: ${fee['dueDate']}'),
            if (isPaid) Text('Paid: \$${fee['paidAmount']} on ${fee['paidDate']}'),
          ],
        ),
        trailing: Chip(
          label: Text(fee['status']),
          backgroundColor: statusColor[100],
          labelStyle: TextStyle(color: statusColor[700]),
        ),
      ),
    );
  }

  void _showAddStudentFeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _AddStudentFeeDialog(),
    );
  }
}

class _PaymentsTab extends StatelessWidget {
  const _PaymentsTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<FeeProvider>(
      builder: (context, feeProvider, child) {
        if (feeProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Records',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      final role = auth.user?['role'] ?? 'Super Admin';
                      if (role == 'Parent') return const SizedBox.shrink();
                      return PrimaryButton(
                        text: 'Record Payment',
                        onPressed: () => _showRecordPaymentDialog(context),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: feeProvider.payments.length,
                itemBuilder: (context, index) {
                  final payment = feeProvider.payments[index];
                  return _buildPaymentCard(context, payment);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentCard(BuildContext context, Map<String, dynamic> payment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.payment, color: Colors.blue[700]),
        ),
        title: Text(payment['studentName']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fee: ${payment['feeName']}'),
            Text('Amount: \$${payment['amount']?.toString() ?? '0'}'),
            Text('Method: ${payment['paymentMethod']}'),
            Text('Date: ${payment['paymentDate']}'),
            Text('Transaction ID: ${payment['transactionId']}'),
          ],
        ),
        trailing: Chip(
          label: Text(payment['status']),
          backgroundColor: Colors.blue[100],
          labelStyle: TextStyle(color: Colors.blue[700]),
        ),
      ),
    );
  }

  void _showRecordPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _RecordPaymentDialog(),
    );
  }
}

class _RecordPaymentDialog extends StatefulWidget {
  const _RecordPaymentDialog();

  @override
  State<_RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<_RecordPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedStudent = '';
  String _selectedFee = '';
  final _amountController = TextEditingController();
  String _selectedPaymentMethod = 'Cash';
  final _transactionIdController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final List<String> _paymentMethods = [
    'Cash', 'Credit Card', 'Debit Card', 'Bank Transfer', 'Check', 'Online Payment'
  ];

  // Mock data for students and fees
  final List<Map<String, String>> _students = [
    {'id': '1', 'name': 'John Doe', 'class': 'Class 10'},
    {'id': '2', 'name': 'Sarah Smith', 'class': 'Class 9'},
    {'id': '3', 'name': 'Mike Johnson', 'class': 'Class 8'},
  ];

  final List<Map<String, String>> _fees = [
    {'id': '1', 'name': 'Tuition Fee', 'amount': '500.0'},
    {'id': '2', 'name': 'Library Fee', 'amount': '500'},
    {'id': '3', 'name': 'Sports Fee', 'amount': '300'},
    {'id': '4', 'name': 'Laboratory Fee', 'amount': '800'},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Record Payment'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedStudent.isEmpty ? null : _selectedStudent,
                decoration: const InputDecoration(
                  labelText: 'Student',
                  border: OutlineInputBorder(),
                ),
                items: _students.map((student) {
                  return DropdownMenuItem(
                    value: student['id'],
                    child: Text('${student['name']} (${student['class']})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStudent = value ?? '';
                  });
                },
                validator: (value) => value?.isEmpty == true ? 'Student is required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFee.isEmpty ? null : _selectedFee,
                decoration: const InputDecoration(
                  labelText: 'Fee Type',
                  border: OutlineInputBorder(),
                ),
                items: _fees.map((fee) {
                  return DropdownMenuItem(
                    value: fee['id'],
                    child: Text('${fee['name']} - \$${fee['amount']?.toString() ?? '0'}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFee = value ?? '';
                    if (value != null) {
                      final fee = _fees.firstWhere((f) => f['id'] == value);
                      _amountController.text = fee['amount']?.toString() ?? '';
                    }
                  });
                },
                validator: (value) => value?.isEmpty == true ? 'Fee type is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Amount is required';
                  if (double.tryParse(value!) == null) return 'Please enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                items: _paymentMethods.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value ?? 'Cash';
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _transactionIdController,
                decoration: const InputDecoration(
                  labelText: 'Transaction ID (Optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Leave empty for cash payments',
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Payment Date'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 1)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        PrimaryButton(
          text: 'Record Payment',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final student = _students.firstWhere((s) => s['id'] == _selectedStudent);
              final fee = _fees.firstWhere((f) => f['id'] == _selectedFee);
              
              final payment = {
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'studentName': student['name'],
                'feeName': fee['name'],
                'amount': _amountController.text,
                'paymentMethod': _selectedPaymentMethod,
                'paymentDate': '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                'transactionId': _transactionIdController.text.isEmpty 
                    ? 'CASH-${DateTime.now().millisecondsSinceEpoch}' 
                    : _transactionIdController.text,
                'status': 'Completed',
              };
              
              context.read<FeeProvider>().recordPayment(payment);
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment recorded successfully!')),
              );
            }
          },
        ),
      ],
    );
  }
}

class _AddFeeStructureDialog extends StatefulWidget {
  const _AddFeeStructureDialog();

  @override
  State<_AddFeeStructureDialog> createState() => _AddFeeStructureDialogState();
}

class _AddFeeStructureDialogState extends State<_AddFeeStructureDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedFrequency = 'Monthly';
  String _selectedClass = 'All';
  String _selectedAcademicYear = '2023-2024';

  final List<String> _frequencies = [
    'Monthly', 'Quarterly', 'Semi-annually', 'Annually', 'One-time'
  ];

  final List<String> _classes = [
    'All', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5',
    'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'
  ];

  final List<String> _academicYears = [
    '2023-2024', '2024-2025', '2025-2026'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Fee Structure'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Fee Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Fee name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value?.isEmpty == true ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Amount is required';
                  if (double.tryParse(value!) == null) return 'Please enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFrequency,
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                ),
                items: _frequencies.map((frequency) {
                  return DropdownMenuItem(
                    value: frequency,
                    child: Text(frequency),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFrequency = value ?? 'Monthly';
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedClass,
                decoration: const InputDecoration(
                  labelText: 'Applicable Class',
                  border: OutlineInputBorder(),
                ),
                items: _classes.map((className) {
                  return DropdownMenuItem(
                    value: className,
                    child: Text(className),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClass = value ?? 'All';
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedAcademicYear,
                decoration: const InputDecoration(
                  labelText: 'Academic Year',
                  border: OutlineInputBorder(),
                ),
                items: _academicYears.map((year) {
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAcademicYear = value ?? '2023-2024';
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        PrimaryButton(
          text: 'Add Fee Structure',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final feeStructure = {
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'name': _nameController.text,
                'description': _descriptionController.text,
                'amount': double.parse(_amountController.text),
                'frequency': _selectedFrequency,
                'class': _selectedClass,
                'academicYear': _selectedAcademicYear,
                'status': 'Active',
              };
              
              context.read<FeeProvider>().addFeeStructure(feeStructure);
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fee structure added successfully!')),
              );
            }
          },
        ),
      ],
    );
  }
}

class _AddStudentFeeDialog extends StatefulWidget {
  const _AddStudentFeeDialog();

  @override
  State<_AddStudentFeeDialog> createState() => _AddStudentFeeDialogState();
}

class _AddStudentFeeDialogState extends State<_AddStudentFeeDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedStudent = '';
  String _selectedFeeStructure = '';
  final _amountController = TextEditingController();
  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 30));

  // Mock data for students and fee structures
  final List<Map<String, String>> _students = [
    {'id': '1', 'name': 'John Doe', 'class': 'Class 10'},
    {'id': '2', 'name': 'Sarah Smith', 'class': 'Class 9'},
    {'id': '3', 'name': 'Mike Johnson', 'class': 'Class 8'},
    {'id': '4', 'name': 'Emily Davis', 'class': 'Class 8'},
    {'id': '5', 'name': 'David Wilson', 'class': 'Class 12'},
  ];

  final List<Map<String, String>> _feeStructures = [
    {'id': '1', 'name': 'Tuition Fee', 'amount': '500.0'},
    {'id': '2', 'name': 'Transportation Fee', 'amount': '200.0'},
    {'id': '3', 'name': 'Library Fee', 'amount': '100.0'},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Student Fee'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedStudent.isEmpty ? null : _selectedStudent,
                decoration: const InputDecoration(
                  labelText: 'Student',
                  border: OutlineInputBorder(),
                ),
                items: _students.map((student) {
                  return DropdownMenuItem(
                    value: student['id'],
                    child: Text('${student['name']} (${student['class']})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStudent = value ?? '';
                  });
                },
                validator: (value) => value?.isEmpty == true ? 'Student is required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFeeStructure.isEmpty ? null : _selectedFeeStructure,
                decoration: const InputDecoration(
                  labelText: 'Fee Structure',
                  border: OutlineInputBorder(),
                ),
                items: _feeStructures.map((fee) {
                  return DropdownMenuItem(
                    value: fee['id'],
                    child: Text('${fee['name']} - \$${fee['amount']?.toString() ?? '0'}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFeeStructure = value ?? '';
                    if (value != null) {
                      final fee = _feeStructures.firstWhere((f) => f['id'] == value);
                      _amountController.text = fee['amount']?.toString() ?? '';
                    }
                  });
                },
                validator: (value) => value?.isEmpty == true ? 'Fee structure is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Amount is required';
                  if (double.tryParse(value!) == null) return 'Please enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Due Date'),
                subtitle: Text(
                  '${_selectedDueDate.day}/${_selectedDueDate.month}/${_selectedDueDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDueDate = date;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        PrimaryButton(
          text: 'Add Student Fee',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final student = _students.firstWhere((s) => s['id'] == _selectedStudent);
              final feeStructure = _feeStructures.firstWhere((f) => f['id'] == _selectedFeeStructure);
              
              final studentFee = {
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'studentId': int.parse(_selectedStudent),
                'studentName': student['name'],
                'feeStructureId': int.parse(_selectedFeeStructure),
                'feeName': feeStructure['name'],
                'amount': double.parse(_amountController.text),
                'dueDate': '${_selectedDueDate.day}/${_selectedDueDate.month}/${_selectedDueDate.year}',
                'status': 'Pending',
                'paidAmount': 0.0,
                'paidDate': null,
              };
              
              context.read<FeeProvider>().addStudentFee(studentFee);
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Student fee added successfully!')),
              );
            }
          },
        ),
      ],
    );
  }
}
