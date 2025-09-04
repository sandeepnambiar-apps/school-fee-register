import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/school_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _loginCodeController = TextEditingController();
  bool _isLoading = false;
  bool _isParentMode = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _loginCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      bool success;

      if (_isParentMode) {
        // Parent login with mobile and login code
        success = await authProvider.loginWithMobileAndCode(
          _mobileController.text.trim(),
          _loginCodeController.text.trim(),
        );
      } else {
        // Regular login with username and password
        success = await authProvider.login(
          _usernameController.text.trim(),
          _passwordController.text,
        );
      }

      if (success) {
        if (mounted) {
          context.go('/dashboard');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error ?? 'Login failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo and Title
                        Column(
                          children: [
                            const SchoolLogo(size: 80),
                            const SizedBox(height: 24),
                            Column(
                              children: [
                                Text(
                                  'BOON',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'E.M School',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign in to your account',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.orange[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Enhanced Login Mode Toggle with Icons
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange[300]!),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isParentMode = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: !_isParentMode ? Colors.orange[600] : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person_outline,
                                          color: !_isParentMode ? Colors.white : Colors.orange[600],
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Staff Login',
                                          style: TextStyle(
                                            color: !_isParentMode ? Colors.white : Colors.orange[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isParentMode = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _isParentMode ? Colors.orange[600] : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.family_restroom,
                                          color: _isParentMode ? Colors.white : Colors.orange[600],
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Parent Login',
                                          style: TextStyle(
                                            color: _isParentMode ? Colors.white : Colors.orange[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login Fields based on mode
                        if (!_isParentMode) ...[
                          // Username Field for Staff
                          CustomTextField(
                            label: 'Username/ID',
                            hint: 'Enter your username or ID',
                            controller: _usernameController,
                            prefixIcon: const Icon(Icons.person_outline),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username/ID is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Password Field for Staff
                          PasswordTextField(
                            controller: _passwordController,
                          ),
                        ] else ...[
                          // Enhanced Mobile Number Field for Parents
                          CustomTextField(
                            label: 'Mobile Number',
                            hint: 'Enter the mobile number registered with school',
                            controller: _mobileController,
                            prefixIcon: const Icon(Icons.phone),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Mobile number is required';
                              }
                              if (value.length < 10) {
                                return 'Please enter a valid 10-digit mobile number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Enhanced Login Code Field for Parents
                          CustomTextField(
                            label: 'Login Code',
                            hint: 'Enter the 6-digit code provided by your school',
                            controller: _loginCodeController,
                            prefixIcon: const Icon(Icons.key),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Login code is required';
                              }
                              if (value.length != 6) {
                                return 'Login code must be 6 characters';
                              }
                              return null;
                            },
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Enhanced Login Button
                        PrimaryButton(
                          text: _isParentMode ? 'Verify & Setup Account' : 'Sign In',
                          onPressed: _handleLogin,
                          isLoading: _isLoading,
                          width: double.infinity,
                          backgroundColor: Colors.orange[600],
                        ),
                        const SizedBox(height: 16),

                        // Helpful Information Section for Parents
                        if (_isParentMode) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange[300]!),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.orange[600], size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'How to get your login code?',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange[700],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '• Contact your school administrator\n'
                                  '• Check your SMS/email from school\n'
                                  '• Ask your child\'s class teacher',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        
                        // Enhanced Demo Credentials
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange[300]!),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Demo Credentials',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                !_isParentMode 
                                  ? 'Staff Demo:\n'
                                    '• Super Admin: superadmin1 / super123\n'
                                    '• School Admin: schooladmin / school123\n'
                                    '• Teacher: teacher / teacher123'
                                  : 'Parent Demo:\n'
                                    '• Mobile: 9876543210 | Code: ABC123\n'
                                    '• Mobile: 9876543211 | Code: DEF456\n'
                                    '• Contact school for your code',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


