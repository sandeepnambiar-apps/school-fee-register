import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/school_config_provider.dart';
import '../../providers/auth_provider.dart';

class SchoolConfigScreen extends StatefulWidget {
  const SchoolConfigScreen({super.key});

  @override
  State<SchoolConfigScreen> createState() => _SchoolConfigScreenState();
}

class _SchoolConfigScreenState extends State<SchoolConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _schoolNameController = TextEditingController();
  final _schoolAddressController = TextEditingController();
  final _schoolPhoneController = TextEditingController();
  final _schoolEmailController = TextEditingController();
  final _schoolLogoController = TextEditingController();
  
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentConfig();
    });
  }

  @override
  void dispose() {
    _schoolNameController.dispose();
    _schoolAddressController.dispose();
    _schoolPhoneController.dispose();
    _schoolEmailController.dispose();
    _schoolLogoController.dispose();
    super.dispose();
  }

  void _loadCurrentConfig() {
    final schoolConfig = context.read<SchoolConfigProvider>();
    _schoolNameController.text = schoolConfig.schoolName;
    _schoolAddressController.text = schoolConfig.schoolAddress;
    _schoolPhoneController.text = schoolConfig.schoolPhone;
    _schoolEmailController.text = schoolConfig.schoolEmail;
    _schoolLogoController.text = schoolConfig.schoolLogo;
    setState(() {
      _hasChanges = false;
    });
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<void> _saveConfig() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final schoolConfig = context.read<SchoolConfigProvider>();
      await schoolConfig.updateConfig(
        schoolName: _schoolNameController.text.trim(),
        schoolAddress: _schoolAddressController.text.trim(),
        schoolPhone: _schoolPhoneController.text.trim(),
        schoolEmail: _schoolEmailController.text.trim(),
        schoolLogo: _schoolLogoController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('School configuration updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _hasChanges = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating configuration: ${e.toString()}'),
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

  Future<void> _resetToDefaults() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text(
          'Are you sure you want to reset all school configuration to default values? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final schoolConfig = context.read<SchoolConfigProvider>();
        await schoolConfig.resetToDefaults();
        _loadCurrentConfig();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Configuration reset to defaults successfully!'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error resetting configuration: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('School Configuration'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          // Kidsy Branding in App Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Kid',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[600],
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        'sy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_hasChanges)
            TextButton(
              onPressed: _isLoading ? null : _saveConfig,
              child: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
        ],
      ),
      body: Consumer<SchoolConfigProvider>(
        builder: (context, schoolConfig, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.school,
                                size: 32,
                                color: Colors.orange[700],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'School Configuration',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange[700],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Configure your school settings and branding',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // School Name
                  _buildSectionTitle('School Information'),
                  _buildTextField(
                    controller: _schoolNameController,
                    label: 'School Name',
                    hint: 'Enter your school name',
                    icon: Icons.school,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'School name is required';
                      }
                      return null;
                    },
                    onChanged: _onFieldChanged,
                  ),
                  const SizedBox(height: 16),

                  // School Address
                  _buildTextField(
                    controller: _schoolAddressController,
                    label: 'School Address',
                    hint: 'Enter your school address',
                    icon: Icons.location_on,
                    maxLines: 3,
                    onChanged: _onFieldChanged,
                  ),
                  const SizedBox(height: 16),

                  // School Phone
                  _buildTextField(
                    controller: _schoolPhoneController,
                    label: 'School Phone',
                    hint: 'Enter your school phone number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    onChanged: _onFieldChanged,
                  ),
                  const SizedBox(height: 16),

                  // School Email
                  _buildTextField(
                    controller: _schoolEmailController,
                    label: 'School Email',
                    hint: 'Enter your school email address',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                      }
                      return null;
                    },
                    onChanged: _onFieldChanged,
                  ),
                  const SizedBox(height: 24),

                  // School Logo URL
                  _buildSectionTitle('Branding'),
                  _buildTextField(
                    controller: _schoolLogoController,
                    label: 'School Logo URL',
                    hint: 'Enter URL for your school logo (optional)',
                    icon: Icons.image,
                    onChanged: _onFieldChanged,
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _resetToDefaults,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset to Defaults'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.grey[700],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading || !_hasChanges ? null : _saveConfig,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Current Configuration Display
                  _buildSectionTitle('Current Configuration'),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildConfigRow('School Name', schoolConfig.schoolName),
                          _buildConfigRow('School Address', schoolConfig.schoolAddress.isEmpty ? 'Not set' : schoolConfig.schoolAddress),
                          _buildConfigRow('School Phone', schoolConfig.schoolPhone.isEmpty ? 'Not set' : schoolConfig.schoolPhone),
                          _buildConfigRow('School Email', schoolConfig.schoolEmail.isEmpty ? 'Not set' : schoolConfig.schoolEmail),
                          _buildConfigRow('School Logo', schoolConfig.schoolLogo.isEmpty ? 'Not set' : schoolConfig.schoolLogo),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.orange[700],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    VoidCallback? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: true,
                      fillColor: Colors.white,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: (value) => onChanged?.call(),
    );
  }

  Widget _buildConfigRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
