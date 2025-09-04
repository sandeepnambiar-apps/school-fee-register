import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_management_provider.dart';
import '../../providers/multi_school_provider.dart';
import '../../models/permissions.dart';
import '../../widgets/common/custom_text_field.dart';

class CreateUserForm extends StatefulWidget {
  final VoidCallback onUserCreated;

  const CreateUserForm({
    super.key,
    required this.onUserCreated,
  });

  @override
  State<CreateUserForm> createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  final _subjectController = TextEditingController();
  final _kidIdController = TextEditingController();

  String _selectedRole = 'Teacher';
  String? _selectedSchoolId;
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_add, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                'Create New User',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Basic Information Section
          _buildSectionHeader('Basic Information'),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Username *',
                  hint: 'Enter unique username',
                  controller: _usernameController,
                  prefixIcon: const Icon(Icons.person),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
                    }
                    if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
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
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
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
              const SizedBox(width: 16),
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
            ],
          ),
          const SizedBox(height: 16),
          
          // Password Section
          _buildSectionHeader('Security'),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Password *',
                  hint: 'Enter password',
                  controller: _passwordController,
                  prefixIcon: const Icon(Icons.lock),
                  obscureText: !_showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: 'Confirm Password *',
                  hint: 'Confirm password',
                  controller: _confirmPasswordController,
                  prefixIcon: const Icon(Icons.lock_outline),
                  obscureText: !_showConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Role and School Section
          _buildSectionHeader('Role & School'),
          const SizedBox(height: 12),
          
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
          const SizedBox(height: 16),
          
          // Role-specific fields
          if (_selectedRole == 'Teacher') ...[
            _buildSectionHeader('Teacher Information'),
            const SizedBox(height: 12),
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
            const SizedBox(height: 16),
          ],
          
          if (_selectedRole == 'Parent') ...[
            _buildSectionHeader('Parent Information'),
            const SizedBox(height: 12),
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
            const SizedBox(height: 16),
          ],
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createUser,
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
                          'Create User',
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
                  onPressed: _isLoading ? null : _resetForm,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    side: BorderSide(color: Colors.grey[400]!),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
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

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = context.read<UserManagementProvider>();
      
      final success = await userProvider.createUser(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        role: _selectedRole,
        schoolId: _selectedSchoolId,
        department: _selectedRole == 'Teacher' ? _departmentController.text.trim() : null,
        subject: _selectedRole == 'Teacher' ? _subjectController.text.trim() : null,
        kidId: _selectedRole == 'Parent' ? _kidIdController.text.trim() : null,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User ${_fullNameController.text.trim()} created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onUserCreated();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create user: ${userProvider.error}'),
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

  void _resetForm() {
    _formKey.currentState!.reset();
    _usernameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _fullNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _departmentController.clear();
    _subjectController.clear();
    _kidIdController.clear();
    setState(() {
      _selectedRole = 'Teacher';
      _selectedSchoolId = null;
    });
  }
}
