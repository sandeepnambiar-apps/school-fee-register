import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/user_management_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';

class EditUserDialog extends StatefulWidget {
  final User user;

  const EditUserDialog({
    super.key,
    required this.user,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _classController = TextEditingController();
  final _subjectController = TextEditingController();

  String _selectedStatus = 'ACTIVE';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.fullName;
    _emailController.text = widget.user.email;
    _classController.text = widget.user.classAssigned ?? '';
    _subjectController.text = widget.user.subjectTaught ?? '';
    _selectedStatus = widget.user.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _classController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit User - ${widget.user.fullName}'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name
              CustomTextField(
                label: 'Full Name *',
                controller: _nameController,
                prefixIcon: const Icon(Icons.person_outline),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              CustomTextField(
                label: 'Email *',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Status
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.block),
                ),
                items: [
                  const DropdownMenuItem(
                    value: 'ACTIVE',
                    child: Text('Active'),
                  ),
                  const DropdownMenuItem(
                    value: 'INACTIVE',
                    child: Text('Inactive'),
                  ),
                  const DropdownMenuItem(
                    value: 'SUSPENDED',
                    child: Text('Suspended'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),

              // Teacher-specific fields
              if (widget.user.role == 'TEACHER') ...[
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Class Assigned',
                  controller: _classController,
                  prefixIcon: const Icon(Icons.class_),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Subject Taught',
                  controller: _subjectController,
                  prefixIcon: const Icon(Icons.book),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        CustomButton(
          text: _isLoading ? 'Updating...' : 'Update',
          onPressed: _isLoading ? null : _updateUser,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = context.read<UserManagementProvider>();
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update user in provider
      final updatedUser = widget.user.copyWith(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        status: _selectedStatus,
        classAssigned: widget.user.role == 'TEACHER' ? _classController.text.trim() : widget.user.classAssigned,
        subjectTaught: widget.user.role == 'TEACHER' ? _subjectController.text.trim() : widget.user.subjectTaught,
        updatedAt: DateTime.now(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.user.fullName} updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}