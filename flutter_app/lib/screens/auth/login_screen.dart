import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/school_logo.dart';
import '../../services/api_service.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _currentSchoolCode;

  @override
  void initState() {
    super.initState();
    _loadSchoolCode();
  }

  Future<void> _loadSchoolCode() async {
    final apiService = ApiService();
    final schoolCode = await apiService.getStoredSchoolCode();
    setState(() {
      _currentSchoolCode = schoolCode;
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: _currentSchoolCode == 'BOON' 
          ? BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/school-pic.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            )
          : null,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                const SizedBox(height: 40),
                
                // School Logo
                const Center(
                  child: SchoolLogo(size: 120),
                ),
                
                const SizedBox(height: 24),
                
                // Welcome Text
                Text(
                  _currentSchoolCode == 'BOON' ? 'Boon E.M School' : 'Welcome to Kidsy',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _currentSchoolCode == 'BOON' ? Colors.white : Colors.blue[700],
                    shadows: _currentSchoolCode == 'BOON' ? [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ] : null,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'School Management System',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _currentSchoolCode == 'BOON' ? Colors.white : Colors.grey[600],
                    shadows: _currentSchoolCode == 'BOON' ? [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ] : null,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Login Form
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Mobile Number Field
                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number *',
                          hintText: 'Enter your mobile number',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          if (value.length < 10) {
                            return 'Please enter a valid mobile number';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password *',
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Login Button
                      CustomButton(
                        text: _isLoading ? 'Logging in...' : 'Login',
                        onPressed: _isLoading ? null : _handleLogin,
                        backgroundColor: Colors.blue[600]!,
                        textColor: Colors.white,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Forgot Password Link
                      Center(
                        child: TextButton(
                          onPressed: () {
                            context.go('/forgot-password');
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.grey[600],
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Demo Credentials Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Demo Credentials',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Use these mobile numbers to test different user roles:',
                        style: TextStyle(color: Colors.orange[700]),
                      ),
                      const SizedBox(height: 8),
                      _buildDemoCredential('9999999999', 'Super Admin (All Schools)'),
                      _buildDemoCredential('1111111111', 'School 1 Admin'),
                      _buildDemoCredential('3333333333', 'School 1 Teacher'),
                      _buildDemoCredential('6666666666', 'School 1 Parent'),
                      _buildDemoCredential('2222222222', 'School 2 Admin'),
                      _buildDemoCredential('5555555555', 'School 2 Teacher'),
                      _buildDemoCredential('8888888888', 'School 2 Parent'),
                      const SizedBox(height: 8),
                      Text(
                        'Password: Welcome@123 (Default password for all users)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Footer
                Text(
                  '© 2024 Kidsy School Management System',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildDemoCredential(String mobile, String role) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$mobile: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange[700],
            ),
          ),
          Text(
            role,
            style: TextStyle(color: Colors.orange[700]),
          ),
        ],
      ),
    );
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
      
      // Use real API login
      final result = await authProvider.login(
        _mobileController.text.trim(),
        _passwordController.text,
      );

      if (result['success'] == true && mounted) {
        // Check if password change is required
        if (result['requiresPasswordChange'] == true) {
          // Navigate to password creation screen
          context.go('/create-password', extra: {
            'mobileNumber': _mobileController.text.trim(),
            'isPasswordReset': false,
          });
        } else {
          // Store user data and navigate to dashboard
          await authProvider.storeUserData(result['user']);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/dashboard');
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $e'),
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


