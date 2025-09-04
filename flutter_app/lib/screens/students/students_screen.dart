import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../../models/student.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/cartoon_children_icon.dart';
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
              backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_getTitle(userRole)),
        backgroundColor: Colors.blue,
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
              if (userRole == 'PARENT') _buildKidProfile(studentProvider, auth),
              if (userRole == 'Teacher') _buildClassInfo(studentProvider, auth),
              if (userRole == 'Super Admin' || userRole == 'School Admin') _buildSearchBar(studentProvider),
              _buildStudentsList(studentProvider, userRole),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  String _getTitle(String userRole) {
    switch (userRole) {
      case 'Parent':
        return 'Kid Profile';
      case 'Teacher':
        return 'My Class';
      default:
        return 'Kid Profile';
    }
  }

  List<Widget> _buildActions(String userRole) {
    List<Widget> actions = [
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
    ];
    
    if (userRole == 'Teacher') {
      actions.add(
        IconButton(
          icon: const Icon(Icons.assignment),
          onPressed: () => context.go('/homework'),
          tooltip: 'Add Homework',
        ),
      );
    }
    return actions;
  }

  Widget _buildKidProfile(StudentProvider studentProvider, AuthProvider auth) {
    final kidId = auth.user?['kidId']?.toString();
    final kid = kidId != null ? studentProvider.getStudentById(kidId) : null;
    
    if (kid == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          color: Colors.white,
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
                    child: CartoonChildrenIcon(size: 44, color: Colors.lightBlue[600]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kid.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text('Class ${kid.className} - Section ${kid.section}'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Father', kid.fatherName),
                              _buildDetailRow('Father Phone', kid.fatherPhone),
              _buildDetailRow('Parent Email', kid.parentEmail),
              _buildDetailRow('Address', kid.address),
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
                    '${students.length} Kids',
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
        label: 'Search Kids',
        hint: 'Search by name, email, class, or parent name',
        controller: _searchController,
        prefixIcon: const Icon(Icons.search),
        onChanged: (value) => studentProvider.searchStudents(value),
      ),
    );
  }

  Widget _buildStudentsList(StudentProvider studentProvider, String userRole) {
    List<Student> studentsToShow;
    
    if (userRole == 'PARENT') {
      final kidId = context.read<AuthProvider>().user?['kidId']?.toString();
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
            'No kids found',
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

  Widget? _buildFloatingActionButton() {
    final userRole = this.userRole;
    if (userRole == 'SUPER_ADMIN' || userRole == 'SCHOOL_ADMIN') {
      return FloatingActionButton(
        onPressed: () => _showAddEditStudentDialog(context, null),
        backgroundColor: Colors.lightBlue[700],
        child: const Icon(Icons.add, color: Colors.white),
      );
    }
    return null;
  }

  String get userRole {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.user?['role'] ?? 'USER';
  }

  Widget _buildStudentCard(BuildContext context, Student student, StudentProvider provider, String userRole) {
          return Card(
        color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.lightBlue[100],
          radius: 20,
          child: CartoonChildrenIcon(size: 32, color: Colors.lightBlue[600]),
        ),
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Class: ${student.className} - Section: ${student.section}'),
            if (userRole != 'PARENT') Text('Father: ${student.fatherName}'),
            Text('Status: ${student.isActive ? 'Active' : 'Inactive'}'),
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

  void _showAddEditStudentDialog(BuildContext context, Student? student) {
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

  void _showStudentDetailsDialog(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Student Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Name', student.name),
              _buildDetailRow('Class', student.className),
              _buildDetailRow('Section', student.section),
              _buildDetailRow('Gender', student.gender),
              _buildDetailRow('Email', student.email),
              _buildDetailRow('Father Name', student.fatherName),
              _buildDetailRow('Father Phone', student.fatherPhone),
              _buildDetailRow('Mother Name', student.motherName),
              _buildDetailRow('Mother Phone', student.motherPhone),
              _buildDetailRow('Address', student.address),
              // NEW: Additional fields
              _buildDetailRow('Kid Aadhaar', student.kidAadhaar),
              _buildDetailRow('PEN', student.pen),
              _buildDetailRow('Father Aadhaar', student.fatherAadhaar),
              _buildDetailRow('Mother Aadhaar', student.motherAadhaar),
              _buildDetailRow('Caste', student.caste),
              _buildDetailRow('Category', student.category),
              _buildDetailRow('Parent Login Code', student.parentLoginCode),
              _buildDetailRow('Login Code Used', student.parentLoginCodeUsed ? 'Yes' : 'No'),
              _buildDetailRow('Status', student.isActive ? 'Active' : 'Inactive'),
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

  void _showDeleteConfirmationDialog(BuildContext context, Student student, StudentProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}? This action cannot be undone.'),
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
              await provider.deleteStudent(student.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${student.name} deleted successfully')),
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
  final Student? student;
  final Function(Map<String, dynamic>) onSave;

  const _AddEditStudentForm({this.student, required this.onSave});

  @override
  State<_AddEditStudentForm> createState() => _AddEditStudentFormState();
}

class _AddEditStudentFormState extends State<_AddEditStudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _classController = TextEditingController();
  final _sectionController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _fatherPhoneController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _motherPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  // NEW: Additional field controllers
  final _kidAadhaarController = TextEditingController();
  final _penController = TextEditingController();
  final _fatherAadhaarController = TextEditingController();
  final _motherAadhaarController = TextEditingController();
  final _casteController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      // Split existing name into first and last name
      final nameParts = widget.student!.name.split(' ');
      _firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
      _lastNameController.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      _classController.text = widget.student!.className;
      _sectionController.text = widget.student!.section;
      _genderController.text = widget.student!.gender;
      _emailController.text = widget.student!.email;
              _fatherNameController.text = widget.student!.fatherName;
              _fatherPhoneController.text = widget.student!.fatherPhone;
      _motherNameController.text = widget.student!.motherName;
      _motherPhoneController.text = widget.student!.motherPhone;
      _addressController.text = widget.student!.address;
      // NEW: Populate additional fields
      _kidAadhaarController.text = widget.student!.kidAadhaar;
      _penController.text = widget.student!.pen;
      _fatherAadhaarController.text = widget.student!.fatherAadhaar;
      _motherAadhaarController.text = widget.student!.motherAadhaar;
      _casteController.text = widget.student!.caste;
      _categoryController.text = widget.student!.category;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _classController.dispose();
    _sectionController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _fatherNameController.dispose();
    _fatherPhoneController.dispose();
    _motherNameController.dispose();
    _motherPhoneController.dispose();
    _addressController.dispose();
    // NEW: Dispose additional controllers
    _kidAadhaarController.dispose();
    _penController.dispose();
    _fatherAadhaarController.dispose();
    _motherAadhaarController.dispose();
    _casteController.dispose();
    _categoryController.dispose();
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
            label: 'First Name',
            controller: _firstNameController,
            validator: (value) => value?.isEmpty == true ? 'First name is required' : null,
          ),
          CustomTextField(
            label: 'Last Name',
            controller: _lastNameController,
            validator: (value) => value?.isEmpty == true ? 'Last name is required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Class',
            controller: _classController,
            validator: (value) => value?.isEmpty == true ? 'Class is required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Section',
            controller: _sectionController,
            validator: (value) => value?.isEmpty == true ? 'Section is required' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _genderController.text.isEmpty ? null : _genderController.text,
            decoration: const InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (value) {
              if (value != null) {
                _genderController.text = value;
              }
            },
            validator: (value) => value == null || value.isEmpty ? 'Gender is required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Email',
            controller: _emailController,
            validator: (value) => value?.isEmpty == true ? 'Email is required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Father Name',
            controller: _fatherNameController,
            validator: (value) => value?.isEmpty == true ? 'Father name is required' : null,
          ),
          const SizedBox(height: 16),
          PhoneTextField(
            label: 'Father Phone',
            controller: _fatherPhoneController,
            validator: (value) => value?.isEmpty == true ? 'Father phone is required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Mother Name',
            controller: _motherNameController,
            validator: (value) => value?.isEmpty == true ? 'Mother name is required' : null,
          ),
          const SizedBox(height: 16),
          PhoneTextField(
            label: 'Mother Phone',
            controller: _motherPhoneController,
            validator: (value) => value?.isEmpty == true ? 'Mother phone is required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Address',
            controller: _addressController,
            maxLines: 3,
            validator: (value) => value?.isEmpty == true ? 'Address is required' : null,
          ),
          const SizedBox(height: 16),
          // NEW: Additional fields
          CustomTextField(
            label: 'Kid Aadhaar',
            controller: _kidAadhaarController,
            validator: (value) => value?.isEmpty == true ? 'Kid Aadhaar is required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'PEN',
            controller: _penController,
            validator: (value) => value?.isEmpty == true ? 'PEN is required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Father Aadhaar',
            controller: _fatherAadhaarController,
            validator: (value) => value?.isEmpty == true ? 'Father Aadhaar is required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Mother Aadhaar',
            controller: _motherAadhaarController,
            validator: (value) => value?.isEmpty == true ? 'Mother Aadhaar is required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Caste',
            controller: _casteController,
            validator: (value) => value?.isEmpty == true ? 'Caste is required' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _categoryController.text.isEmpty ? null : _categoryController.text,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'General', child: Text('General')),
              DropdownMenuItem(value: 'OBC', child: Text('OBC')),
              DropdownMenuItem(value: 'SC', child: Text('SC')),
              DropdownMenuItem(value: 'ST', child: Text('ST')),
              DropdownMenuItem(value: 'EWS', child: Text('EWS')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (value) {
              if (value != null) {
                _categoryController.text = value;
              }
            },
            validator: (value) => value == null || value.isEmpty ? 'Category is required' : null,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: widget.student != null ? 'Update Student' : 'Add Student',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final studentData = {
                    'id': widget.student?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    'name': '${_firstNameController.text} ${_lastNameController.text}',
                    'parentEmail': '', // Not in new form
                    'className': _classController.text,
                    'section': _sectionController.text,
                    'gender': _genderController.text,
                    'email': _emailController.text,
                    'admissionDate': widget.student?.admissionDate.toString() ?? DateTime.now().toString(),
                    'parentName': _fatherNameController.text, // Keep as parentName for form compatibility
                    'parentPhone': _fatherPhoneController.text,
                    'motherName': _motherNameController.text,
                    'motherPhone': _motherPhoneController.text,
                    'address': _addressController.text,
                    'isActive': widget.student?.isActive ?? true,
                    // NEW: Additional fields
                    'kidAadhaar': _kidAadhaarController.text,
                    'pen': _penController.text,
                    'fatherAadhaar': _fatherAadhaarController.text,
                    'motherAadhaar': _motherAadhaarController.text,
                    'caste': _casteController.text,
                    'category': _categoryController.text,
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
