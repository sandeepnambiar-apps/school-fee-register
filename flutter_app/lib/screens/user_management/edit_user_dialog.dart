import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_management_provider.dart';
import '../../providers/multi_school_provider.dart';
import '../../models/user.dart';
import '../../models/permissions.dart';
import '../../widgets/common/custom_text_field.dart';

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
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  final _subjectController = TextEditingController();
  final _kidIdController = TextEditingController();

  String _selectedRole = '';
  String? _selectedSchoolId;
  String _selectedStatus = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _fullNameController.text = widget.user.fullName;
    _emailController.text = widget.user.email;
    _phoneController.text = widget.user.phone;
    _departmentController.text = widget.user.department ?? '';
    _subjectController.text = widget.user.subject ?? '';
    _kidIdController.text = widget.user.kidId ?? '';
    _selectedRole = widget.user.role;
    _selectedSchoolId = widget.user.schoolId;
    _selectedStatus = widget.user.status;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _subjectController.dispose();
    _kidIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Edit User: ${widget.user.fullName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information
                      _buildSectionHeader('Basic Information'),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'Full Name *',
                              hint: 'Enter full name',
                              controller: _fullNameController,
                              prefixIcon: const Icon(Icons.badge),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Full name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              label: 'Email *',
                              hint: 'Enter email address',
                              controller: _emailController,
                              prefixIcon: const Icon(Icons.email),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'Phone *',
                              hint: 'Enter phone number',
                              controller: _phoneController,
                              prefixIcon: const Icon(Icons.phone),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: 'Status *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.info),
                              ),
                              items: ['ACTIVE', 'INACTIVE', 'SUSPENDED'].map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatus = value!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Status is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Role and School
                      _buildSectionHeader('Role & School'),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedRole,
                              decoration: const InputDecoration(
                                labelText: 'Role *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.work),
                              ),
                              items: RolePermissions.getAvailableRoles().map((role) {
                                return DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value!;
                                  // Clear role-specific fields when role changes
                                  if (value != 'Teacher') {
                                    _departmentController.clear();
                                    _subjectController.clear();
                                  }
                                  if (value != 'Parent') {
                                    _kidIdController.clear();
                                  }
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Role is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Consumer<MultiSchoolProvider>(
                              builder: (context, multiSchool, child) {
                                return DropdownButtonFormField<String>(
                                  value: _selectedSchoolId,
                                  decoration: const InputDecoration(
                                    labelText: 'School',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.school),
                                  ),
                                  items: [
                                    const DropdownMenuItem(
                                      value: null,
                                      child: Text('Select School'),
                                    ),
                                    ...multiSchool.schools.map((school) {
                                      return DropdownMenuItem(
                                        value: school.id,
                                        child: Text(school.name),
                                      );
                                    }),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSchoolId = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (_selectedRole != 'Super Admin' && (value == null || value.isEmpty)) {
                                      return 'School is required for this role';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Role-specific fields
                      if (_selectedRole == 'Teacher') ...[
                        _buildSectionHeader('Teacher Information'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Department',
                                hint: 'Enter department',
                                controller: _departmentController,
                                prefixIcon: const Icon(Icons.business),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextField(
                                label: 'Subject',
                                hint: 'Enter subject',
                                controller: _subjectController,
                                prefixIcon: const Icon(Icons.book),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                      
                      if (_selectedRole == 'Parent') ...[
                        _buildSectionHeader('Parent Information'),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Kid ID',
                          hint: 'Enter associated kid ID',
                          controller: _kidIdController,
                          prefixIcon: const Icon(Icons.child_care),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kid ID is required for parents';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _updateUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Update User',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[600],
                                side: BorderSide(color: Colors.grey[400]!),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue[700],
        ),
      ),
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
      
      final success = await userProvider.updateUser(
        widget.user.id,
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        role: _selectedRole,
        schoolId: _selectedSchoolId,
        status: _selectedStatus,
        department: _selectedRole == 'Teacher' ? _departmentController.text.trim() : null,
        subject: _selectedRole == 'Teacher' ? _subjectController.text.trim() : null,
        kidId: _selectedRole == 'Parent' ? _kidIdController.text.trim() : null,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User ${_fullNameController.text.trim()} updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update user: ${userProvider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


