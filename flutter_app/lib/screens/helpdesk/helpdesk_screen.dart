import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/app_branding.dart';

class HelpDeskScreen extends StatefulWidget {
  const HelpDeskScreen({super.key});

  @override
  State<HelpDeskScreen> createState() => _HelpDeskScreenState();
}

class _HelpDeskScreenState extends State<HelpDeskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  
  String _selectedCategory = 'General Inquiry';
  String _selectedPriority = 'Medium';
  
  final List<String> _categories = [
    'General Inquiry',
    'Technical Support',
    'Fee Related',
    'Academic Support',
    'Administrative',
    'Other',
  ];
  
  final List<String> _priorities = [
    'Low',
    'Medium',
    'High',
    'Urgent',
  ];

  final List<Map<String, dynamic>> _tickets = [
    {
      'id': 'T001',
      'subject': 'Fee Payment Issue',
      'category': 'Fee Related',
      'priority': 'High',
      'status': 'Open',
      'createdDate': '2024-01-15',
      'description': 'Unable to process online fee payment',
    },
    {
      'id': 'T002',
      'subject': 'Login Problem',
      'category': 'Technical Support',
      'priority': 'Medium',
      'status': 'In Progress',
      'createdDate': '2024-01-14',
      'description': 'Cannot login to student portal',
    },
    {
      'id': 'T003',
      'subject': 'Grade Update Request',
      'category': 'Academic Support',
      'priority': 'Low',
      'status': 'Closed',
      'createdDate': '2024-01-10',
      'description': 'Request to review and update grades',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Help Desk'),
          backgroundColor: Colors.lightBlue[600],
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/dashboard'),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Submit Ticket', icon: Icon(Icons.add)),
              Tab(text: 'My Tickets', icon: Icon(Icons.list)),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: Column(
          children: [
            const AppBranding(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildSubmitTicketTab(),
                  _buildMyTicketsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitTicketTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submit a new support ticket',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.lightBlue[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person,
              validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value?.isEmpty == true ? 'Email is required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) => value?.isEmpty == true ? 'Phone is required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _subjectController,
              label: 'Subject',
              icon: Icons.subject,
              validator: (value) => value?.isEmpty == true ? 'Subject is required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _messageController,
              label: 'Message',
              icon: Icons.message,
              maxLines: 4,
              validator: (value) => value?.isEmpty == true ? 'Message is required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    value: _selectedCategory,
                    items: _categories,
                    label: 'Category',
                    onChanged: (value) => setState(() => _selectedCategory = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    value: _selectedPriority,
                    items: _priorities,
                    label: 'Priority',
                    onChanged: (value) => setState(() => _selectedPriority = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Submit Ticket',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyTicketsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tickets.length,
      itemBuilder: (context, index) {
        final ticket = _tickets[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getPriorityColor(ticket['priority']),
              child: Icon(
                _getCategoryIcon(ticket['category']),
                color: Colors.white,
              ),
            ),
            title: Text(
              ticket['subject'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${ticket['category']} • ${ticket['priority']} Priority'),
                Text('Created: ${ticket['createdDate']}'),
                Text('Status: ${ticket['status']}'),
              ],
            ),
            trailing: _getStatusChip(ticket['status']),
            onTap: () => _showTicketDetails(ticket),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.lightBlue[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.lightBlue[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.lightBlue[600]!, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required String label,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.lightBlue[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.lightBlue[600]!, width: 2),
        ),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      case 'Urgent':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Technical Support':
        return Icons.computer;
      case 'Fee Related':
        return Icons.payment;
      case 'Academic Support':
        return Icons.school;
      case 'Administrative':
        return Icons.admin_panel_settings;
      default:
        return Icons.help;
    }
  }

  Widget _getStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Open':
        color = Colors.orange;
        break;
      case 'In Progress':
        color = Colors.blue;
        break;
      case 'Closed':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }

  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement ticket submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ticket submitted successfully!'),
          backgroundColor: Colors.green[600],
        ),
      );
      
      // Clear form
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _subjectController.clear();
      _messageController.clear();
      setState(() {
        _selectedCategory = 'General Inquiry';
        _selectedPriority = 'Medium';
      });
    }
  }

  void _showTicketDetails(Map<String, dynamic> ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ticket['subject']),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Category', ticket['category']),
            _buildDetailRow('Priority', ticket['priority']),
            _buildDetailRow('Status', ticket['status']),
            _buildDetailRow('Created', ticket['createdDate']),
            _buildDetailRow('Description', ticket['description']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
