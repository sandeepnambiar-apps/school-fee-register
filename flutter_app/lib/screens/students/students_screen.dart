import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/app_branding.dart';
import 'package:go_router/go_router.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentProvider>().loadStudents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final userRole = auth.user?['role'] ?? 'Super Admin';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(userRole)),
        backgroundColor: Colors.lightBlue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: _buildActions(userRole),
      ),
      body: Consumer<StudentProvider>(
        builder: (context, studentProvider, child) {
          if (studentProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (studentProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${studentProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'Retry',
                    onPressed: () => studentProvider.loadStudents(),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              const AppBranding(),
              if (userRole == 'Parent') _buildKidProfile(studentProvider, auth),
              if (userRole == 'Teacher') _buildClassInfo(studentProvider, auth),
              if (userRole == 'Super Admin' || userRole == 'School Admin') _buildSearchBar(studentProvider),
              _buildStudentsList(studentProvider, userRole),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(userRole),
    );
  }

  String _getTitle(String userRole) {
    switch (userRole) {
      case 'Parent':
        return 'Kid Profile';
      case 'Teacher':
        return 'My Class';
      default:
        return 'Students';
    }
  }

  List<Widget> _buildActions(String userRole) {
    if (userRole == 'Teacher') {
      return [
        IconButton(
          icon: const Icon(Icons.assignment),
          onPressed: () => context.go('/homework'),
          tooltip: 'Add Homework',
        ),
      ];
    }
    return [];
  }

  Widget _buildKidProfile(StudentProvider studentProvider, AuthProvider auth) {
    final kidId = auth.user?['kidId'] as int?;
    final kid = kidId != null ? studentProvider.getStudentById(kidId) : null;
    
    if (kid == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No kid profile found', style: TextStyle(fontSize: 16)),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.lightBlue[100],
                    child: Text(
                      (kid['name'] as String)[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.lightBlue[700],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kid['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text('Class ${kid['class']} - Section ${kid['section']}'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Parent', kid['parentName']),
              _buildDetailRow('Parent Phone', kid['parentPhone']),
              _buildDetailRow('Email', kid['email']),
              _buildDetailRow('Phone', kid['phone']),
              _buildDetailRow('Address', kid['address']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassInfo(StudentProvider studentProvider, AuthProvider auth) {
    final className = auth.user?['class'] as String? ?? '10A';
    final students = studentProvider.getStudentsByClass(className);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Class $className',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${students.length} Students',
                    style: TextStyle(
                      color: Colors.lightBlue[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(StudentProvider studentProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomTextField(
        label: 'Search Students',
        hint: 'Search by name, email, class, or parent name',
        controller: _searchController,
        prefixIcon: const Icon(Icons.search),
        onChanged: (value) => studentProvider.searchStudents(value),
      ),
    );
  }

  Widget _buildStudentsList(StudentProvider studentProvider, String userRole) {
    List<Map<String, dynamic>> studentsToShow;
    
    if (userRole == 'Parent') {
      final kidId = context.read<AuthProvider>().user?['kidId'] as int?;
      studentsToShow = kidId != null ? [studentProvider.getStudentById(kidId)!] : [];
    } else if (userRole == 'Teacher') {
      final className = context.read<AuthProvider>().user?['class'] as String? ?? '10A';
      studentsToShow = studentProvider.getStudentsByClass(className);
    } else {
      studentsToShow = studentProvider.students;
    }

    if (studentsToShow.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'No students found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: studentsToShow.length,
        itemBuilder: (context, index) {
          final student = studentsToShow[index];
          return _buildStudentCard(context, student, studentProvider, userRole);
        },
      ),
    );
  }

  Widget? _buildFloatingActionButton(String userRole) {
    if (userRole == 'Super Admin' || userRole == 'School Admin') {
      return FloatingActionButton(
        onPressed: () => _showAddEditStudentDialog(context, null),
        backgroundColor: Colors.lightBlue[700],
        child: const Icon(Icons.add, color: Colors.white),
      );
    }
    return null;
  }

  Widget _buildStudentCard(BuildContext context, Map<String, dynamic> student, StudentProvider provider, String userRole) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.lightBlue[100],
          child: Text(
            student['name'][0].toUpperCase(),
            style: TextStyle(
              color: Colors.lightBlue[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          student['name'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Class: ${student['class']} - Section: ${student['section']}'),
            if (userRole != 'Parent') Text('Parent: ${student['parentName']}'),
            Text('Status: ${student['status']}'),
          ],
        ),
        trailing: userRole == 'Super Admin' || userRole == 'School Admin' 
            ? PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility),
                        SizedBox(width: 8),
                        Text('View Details'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 'view':
                      _showStudentDetailsDialog(context, student);
                      break;
                    case 'edit':
                      _showAddEditStudentDialog(context, student);
                      break;
                    case 'delete':
                      _showDeleteConfirmationDialog(context, student, provider);
                      break;
                  }
                },
              )
            : null,
        onTap: () => _showStudentDetailsDialog(context, student),
      ),
    );
  }

  void _showAddEditStudentDialog(BuildContext context, Map<String, dynamic>? student) {
    final isEditing = student != null;
    final title = isEditing ? 'Edit Student' : 'Add New Student';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: _AddEditStudentForm(
            student: student,
            onSave: (studentData) {
              if (isEditing) {
                // Update existing student
                context.read<StudentProvider>().updateStudent(studentData);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${studentData['name']} updated successfully!')),
                );
              } else {
                // Add new student
                context.read<StudentProvider>().addStudent(studentData);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${studentData['name']} added successfully!')),
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showStudentDetailsDialog(BuildContext context, Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Student Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Name', student['name']),
              _buildDetailRow('Email', student['email']),
              _buildDetailRow('Phone', student['phone']),
              _buildDetailRow('Class', student['class']),
              _buildDetailRow('Section', student['section']),
              _buildDetailRow('Admission Date', student['admissionDate']),
              _buildDetailRow('Parent Name', student['parentName']),
              _buildDetailRow('Parent Phone', student['parentPhone']),
              _buildDetailRow('Address', student['address']),
              _buildDetailRow('Status', student['status']),
            ],
          ),
        ),
        actions: [
          PrimaryButton(
            text: 'Close',
            onPressed: () => Navigator.of(context).pop(),
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
            width: 100,
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

  void _showDeleteConfirmationDialog(BuildContext context, Map<String, dynamic> student, StudentProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student['name']}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            text: 'Delete',
            backgroundColor: Colors.red,
            onPressed: () async {
              Navigator.of(context).pop();
              await provider.deleteStudent(student['id']);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${student['name']} deleted successfully')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _AddEditStudentForm extends StatefulWidget {
  final Map<String, dynamic>? student;
  final Function(Map<String, dynamic>) onSave;

  const _AddEditStudentForm({this.student, required this.onSave});

  @override
  State<_AddEditStudentForm> createState() => _AddEditStudentFormState();
}

class _AddEditStudentFormState extends State<_AddEditStudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _classController = TextEditingController();
  final _sectionController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _nameController.text = widget.student!['name'];
      _emailController.text = widget.student!['email'];
      _phoneController.text = widget.student!['phone'];
      _classController.text = widget.student!['class'];
      _sectionController.text = widget.student!['section'];
      _parentNameController.text = widget.student!['parentName'];
      _parentPhoneController.text = widget.student!['parentPhone'];
      _addressController.text = widget.student!['address'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _classController.dispose();
    _sectionController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            label: 'Student Name',
            controller: _nameController,
            validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
          ),
          const SizedBox(height: 16),
          EmailTextField(
            controller: _emailController,
            validator: (value) => value?.isEmpty == true ? 'Email is required' : null,
          ),
          const SizedBox(height: 16),
          PhoneTextField(
            controller: _phoneController,
            validator: (value) => value?.isEmpty == true ? 'Phone is required' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Class',
                  controller: _classController,
                  validator: (value) => value?.isEmpty == true ? 'Class is required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: 'Section',
                  controller: _sectionController,
                  validator: (value) => value?.isEmpty == true ? 'Section is required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Parent Name',
            controller: _parentNameController,
            validator: (value) => value?.isEmpty == true ? 'Parent name is required' : null,
          ),
          const SizedBox(height: 16),
          PhoneTextField(
            label: 'Parent Phone',
            controller: _parentPhoneController,
            validator: (value) => value?.isEmpty == true ? 'Parent phone is required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Address',
            controller: _addressController,
            maxLines: 3,
            validator: (value) => value?.isEmpty == true ? 'Address is required' : null,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: widget.student != null ? 'Update Student' : 'Add Student',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final studentData = {
                    'id': widget.student?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'phone': _phoneController.text,
                    'class': _classController.text,
                    'section': _sectionController.text,
                    'admissionDate': widget.student?['admissionDate'] ?? DateTime.now().toString(),
                    'parentName': _parentNameController.text,
                    'parentPhone': _parentPhoneController.text,
                    'address': _addressController.text,
                    'status': widget.student?['status'] ?? 'Active',
                  };
                  widget.onSave(studentData);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
