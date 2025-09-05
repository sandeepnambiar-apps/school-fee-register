import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _classController = TextEditingController();
  final _subjectController = TextEditingController();
  
  String _selectedRole = 'TEACHER';
  String? _selectedSchool;
  bool _isLoading = false;

  final List<String> _roles = ['SUPER_ADMIN', 'SCHOOL_ADMIN', 'TEACHER', 'PARENT'];
  final List<String> _schools = ['School 1', 'School 2', 'School 3'];

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _classController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current User Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current User: ${currentUser?['name'] ?? 'Unknown'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Role: ${currentUser?['role'] ?? 'Unknown'}'),
                    Text('School ID: ${currentUser?['schoolId'] ?? 'All Schools'}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Create New User Form
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Create New User',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Role Selection
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            decoration: const InputDecoration(
                              labelText: 'User Role *',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: _roles.map((role) {
                              return DropdownMenuItem(
                                value: role,
                                child: Text(role.replaceAll('_', ' ')),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value!;
                                // Reset school selection for Super Admin
                                if (_selectedRole == 'SUPER_ADMIN') {
                                  _selectedSchool = null;
                                } else if (_selectedSchool == null) {
                                  _selectedSchool = _schools.first;
                                }
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a role';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // School Selection (not for Super Admin)
                          if (_selectedRole != 'SUPER_ADMIN') ...[
                            DropdownButtonFormField<String>(
                              value: _selectedSchool,
                              decoration: const InputDecoration(
                                labelText: 'School *',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              items: _schools.map((school) {
                                return DropdownMenuItem(
                                  value: school,
                                  child: Text(school),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSchool = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a school';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                          ],
                          
                          // Mobile Number
                          CustomTextField(
                            label: 'Mobile Number *',
                            hint: 'Enter mobile number',
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(Icons.phone),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter mobile number';
                              }
                              if (value.length < 10) {
                                return 'Please enter a valid mobile number';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Password
                          CustomTextField(
                            label: 'Password *',
                            hint: 'Enter password',
                            controller: _passwordController,
                            isPassword: true,
                            prefixIcon: const Icon(Icons.lock),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Name
                          CustomTextField(
                            label: 'Full Name *',
                            hint: 'Enter full name',
                            controller: _nameController,
                            prefixIcon: const Icon(Icons.person),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter full name';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Email
                          CustomTextField(
                            label: 'Email *',
                            hint: 'Enter email address',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          
                          // Additional fields for Teachers
                          if (_selectedRole == 'TEACHER') ...[
                            const SizedBox(height: 16),
                            
                            CustomTextField(
                              label: 'Class Assigned',
                              hint: 'e.g., 10A, 9B',
                              controller: _classController,
                              prefixIcon: const Icon(Icons.class_),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            CustomTextField(
                              label: 'Subject Taught',
                              hint: 'e.g., Mathematics, Science',
                              controller: _subjectController,
                              prefixIcon: const Icon(Icons.book),
                            ),
                          ],
                          
                          const SizedBox(height: 24),
                          
                          // Create User Button
                          CustomButton(
                            text: _isLoading ? 'Creating User...' : 'Create User',
                            onPressed: _isLoading ? null : _createUser,
                            backgroundColor: Colors.blue[600]!,
                            textColor: Colors.white,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Role-specific instructions
                          _buildRoleInstructions(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleInstructions() {
    String instructions = '';
    
    switch (_selectedRole) {
      case 'SUPER_ADMIN':
        instructions = '• Can access ALL schools\n• Can create School Admins\n• Has full system permissions';
        break;
      case 'SCHOOL_ADMIN':
        instructions = '• Can access only their assigned school\n• Can create Teachers and Parents\n• Manages school operations';
        break;
      case 'TEACHER':
        instructions = '• Can access only their assigned school\n• Can create Parents for their students\n• Manages class activities';
        break;
      case 'PARENT':
        instructions = '• Can access only their children\'s school\n• Limited to viewing their children\'s data\n• Can pay fees and view marks';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Role Permissions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            instructions,
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate permissions
    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.user;
    
    if (currentUser == null) {
      _showError('User not authenticated');
      return;
    }

    // Check if current user can create the selected role
    if (!_canCreateRole(currentUser['role'], _selectedRole)) {
      _showError('You do not have permission to create ${_selectedRole.replaceAll('_', ' ')}');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // In real implementation, call the API
      // For now, show success message
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_selectedRole.replaceAll('_', ' ')} created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form
        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to create user: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _canCreateRole(String currentUserRole, String targetRole) {
    switch (currentUserRole) {
      case 'SUPER_ADMIN':
        return true; // Can create all roles
      case 'SCHOOL_ADMIN':
        return targetRole == 'TEACHER' || targetRole == 'PARENT';
      case 'TEACHER':
        return targetRole == 'PARENT';
      default:
        return false;
    }
  }

  void _clearForm() {
    _mobileController.clear();
    _passwordController.clear();
    _nameController.clear();
    _emailController.clear();
    _classController.clear();
    _subjectController.clear();
    setState(() {
      _selectedRole = 'TEACHER';
      _selectedSchool = _schools.first;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
