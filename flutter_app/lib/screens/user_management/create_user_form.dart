import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/multi_school_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final multiSchoolProvider = context.read<MultiSchoolProvider>();
      if (multiSchoolProvider.schools.isNotEmpty) {
        _selectedSchool = multiSchoolProvider.schools.first.id;
      }
    });
  }

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
    final multiSchoolProvider = context.watch<MultiSchoolProvider>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create New User',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 24),

          // Role Selection
          DropdownButtonFormField<String>(
            value: _selectedRole,
            decoration: const InputDecoration(
              labelText: 'User Role *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
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
              });
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
                prefixIcon: Icon(Icons.school),
              ),
              items: multiSchoolProvider.schools.map((school) {
                return DropdownMenuItem(
                  value: school.id,
                  child: Text(school.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSchool = value;
                });
              },
            ),
            const SizedBox(height: 16),
          ],

          // Mobile Number
          CustomTextField(
            label: 'Mobile Number *',
            hint: 'Enter 10-digit mobile number',
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mobile number is required';
              }
              if (value.length != 10) {
                return 'Mobile number must be 10 digits';
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
            obscureText: true,
            prefixIcon: const Icon(Icons.lock),
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
          const SizedBox(height: 16),

          // Name
          CustomTextField(
            label: 'Full Name *',
            hint: 'Enter full name',
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
            hint: 'Enter email address',
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

          // Teacher-specific fields
          if (_selectedRole == 'TEACHER') ...[
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Class Assigned',
              hint: 'e.g., 10A, 8B',
              controller: _classController,
              prefixIcon: const Icon(Icons.class_),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Subject Taught',
              hint: 'e.g., Mathematics, English',
              controller: _subjectController,
              prefixIcon: const Icon(Icons.book),
            ),
          ],

          const SizedBox(height: 24),

          // Create User Button
          CustomButton(
            text: _isLoading ? 'Creating User...' : 'Create User',
            onPressed: _isLoading ? null : _createUser,
            isLoading: _isLoading,
          ),

          const SizedBox(height: 16),

          // Role Instructions
          _buildRoleInstructions(),
        ],
      ),
    );
  }

  Widget _buildRoleInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Role Permissions:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getRoleInstructions(_selectedRole),
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleInstructions(String role) {
    switch (role) {
      case 'SUPER_ADMIN':
        return '• Can access all schools\n• Can create all user types\n• Full system access';
      case 'SCHOOL_ADMIN':
        return '• Can access only assigned school\n• Can create teachers and parents\n• School management access';
      case 'TEACHER':
        return '• Can access assigned school and classes\n• Can create parents\n• Teaching and student management';
      case 'PARENT':
        return '• Can access children\'s school only\n• View children\'s information\n• Limited access';
      default:
        return 'Select a role to see permissions';
    }
  }

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.user;

    if (currentUser == null) {
      _showError('User not authenticated');
      return;
    }

    // Check permissions
    if (!_canCreateRole(currentUser['role'], _selectedRole)) {
      _showError('You do not have permission to create ${_selectedRole.replaceAll('_', ' ')}');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare user data
      final userData = {
        'mobileNumber': _mobileController.text.trim(),
        'password': _passwordController.text,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _selectedRole,
        'schoolId': _selectedRole == 'SUPER_ADMIN' ? null : _selectedSchool,
        'classAssigned': _selectedRole == 'TEACHER' ? _classController.text.trim() : null,
        'subjectTaught': _selectedRole == 'TEACHER' ? _subjectController.text.trim() : null,
      };

      // Call API to create user
      final response = await _createUserAPI(userData);

      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_selectedRole.replaceAll('_', ' ')} created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          _clearForm();
          widget.onUserCreated();
        }
      } else {
        _showError(response['message'] ?? 'Failed to create user');
      }
    } catch (e) {
      _showError('Failed to create user: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>> _createUserAPI(Map<String, dynamic> userData) async {
    // Mock API call - replace with actual API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate API response
    return {
      'success': true,
      'message': 'User created successfully',
      'user': {
        'id': DateTime.now().millisecondsSinceEpoch,
        'mobileNumber': userData['mobileNumber'],
        'name': userData['name'],
        'email': userData['email'],
        'role': userData['role'],
        'schoolId': userData['schoolId'],
        'classAssigned': userData['classAssigned'],
        'subjectTaught': userData['subjectTaught'],
        'isActive': true,
        'isFirstTime': true,
        'createdAt': DateTime.now().toIso8601String(),
      },
    };
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
      _selectedSchool = null;
    });
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}