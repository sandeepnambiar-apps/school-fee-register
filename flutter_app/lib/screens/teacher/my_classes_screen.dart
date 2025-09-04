import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../models/student.dart';

class MyClassesScreen extends StatefulWidget {
  const MyClassesScreen({super.key});

  @override
  State<MyClassesScreen> createState() => _MyClassesScreenState();
}

class _MyClassesScreenState extends State<MyClassesScreen> {
  String? _selectedClass;
  String? _selectedSection;

  final List<String> _availableClasses = ['6', '7', '8', '9', '10', '11', '12'];
  final List<String> _availableSections = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    // Set default class based on teacher's assigned class
    final currentUser = context.read<AuthProvider>().user;
    final teacherClass = currentUser?['class'] ?? '10A';
    _selectedClass = teacherClass.replaceAll(RegExp(r'[A-Z]'), ''); // Extract class number
    _selectedSection = teacherClass.replaceAll(RegExp(r'[0-9]'), ''); // Extract section letter
    
    // Load fresh student data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentProvider>().loadStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('My Classes'),
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
        ],
      ),
      body: Column(
        children: [
          // Class and Section Selection
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedClass,
                    decoration: const InputDecoration(
                      labelText: 'Select Class',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _availableClasses.map((className) {
                      return DropdownMenuItem<String>(
                        value: className,
                        child: Text('Class $className'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedClass = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSection,
                    decoration: const InputDecoration(
                      labelText: 'Select Section',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _availableSections.map((section) {
                      return DropdownMenuItem<String>(
                        value: section,
                        child: Text('Section $section'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSection = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Students List
          Expanded(
            child: Consumer<StudentProvider>(
              builder: (context, studentProvider, child) {
                if (studentProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Debug: Show all students for troubleshooting
                print('Total students in provider: ${studentProvider.students.length}');
                studentProvider.students.forEach((student) {
                  print('Student: ${student.name}, Class: ${student.className}');
                });
                
                // Filter students by selected class and section
                final classStudents = studentProvider.students.where((student) => 
                  student.className == '$_selectedClass$_selectedSection'
                ).toList();

                print('Filtered students for $_selectedClass$_selectedSection: ${classStudents.length}');

                if (classStudents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No students found in Class $_selectedClass Section $_selectedSection',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Debug: Show available classes
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Available students in database:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              ...studentProvider.students.map((student) => 
                                Text('${student.name} - ${student.className}')
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: classStudents.length,
                  itemBuilder: (context, index) {
                    final student = classStudents[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Text(
                            student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          student.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                                                 subtitle: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('Roll No: ${student.rollNumber}'),
                             Text('Section: ${student.section}'),
                             Text('Father: ${student.fatherName}'),
                           ],
                         ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.grade, color: Colors.amber),
                              onPressed: () => _showAddMarksDialog(student),
                              tooltip: 'Add Marks',
                            ),
                            IconButton(
                              icon: const Icon(Icons.assignment, color: Colors.blue),
                              onPressed: () => _showAssignmentsDialog(student),
                              tooltip: 'View Assignments',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

     void _showAddMarksDialog(Student student) {
     String selectedSubject = 'Mathematics';
     String selectedExam = 'Mid Term';
     final marksController = TextEditingController();

     final List<String> subjects = [
       'Mathematics',
       'English',
       'Science',
       'History',
       'Geography',
       'Computer Science',
     ];

     final List<String> exams = [
       'Mid Term',
       'Final Term',
       'Unit Test 1',
       'Unit Test 2',
       'Practical Exam',
     ];

     showDialog(
       context: context,
       builder: (context) => StatefulBuilder(
         builder: (context, setDialogState) => AlertDialog(
           title: Text('Add Marks for ${student.name}'),
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               Text('Class: ${student.className}'),
               Text('Roll No: ${student.rollNumber}'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedSubject,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
                items: subjects.map((subject) {
                  return DropdownMenuItem(value: subject, child: Text(subject));
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedSubject = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedExam,
                decoration: const InputDecoration(
                  labelText: 'Exam',
                  border: OutlineInputBorder(),
                ),
                items: exams.map((exam) {
                  return DropdownMenuItem(value: exam, child: Text(exam));
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedExam = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: marksController,
                decoration: const InputDecoration(
                  labelText: 'Marks',
                  hintText: 'Enter marks (0-100)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final marks = double.tryParse(marksController.text);
                if (marks != null && marks >= 0 && marks <= 100) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Marks added successfully: $marks'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter valid marks between 0 and 100'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

     void _showAssignmentsDialog(Student student) {
     showDialog(
       context: context,
       builder: (context) => AlertDialog(
         title: Text('Assignments for ${student.name}'),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text('Class: ${student.className}'),
             Text('Roll No: ${student.rollNumber}'),
            const SizedBox(height: 16),
            const Text('Recent Assignments:'),
            const SizedBox(height: 8),
            _buildAssignmentItem('Mathematics Assignment 1', 'Submitted'),
            _buildAssignmentItem('English Essay', 'Pending'),
            _buildAssignmentItem('Science Project', 'Graded'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentItem(String title, String status) {
    Color statusColor;
    switch (status) {
      case 'Submitted':
        statusColor = Colors.green;
        break;
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Graded':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
