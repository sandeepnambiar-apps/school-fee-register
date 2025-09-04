import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';

class MarksScreen extends StatefulWidget {
  const MarksScreen({super.key});

  @override
  State<MarksScreen> createState() => _MarksScreenState();
}

class _MarksScreenState extends State<MarksScreen> {
  String _selectedClass = 'Class 10';
  String _selectedSubject = 'All Subjects';
  String _selectedExam = 'Mid Term';

  final List<String> _classes = [
    'Class 10',
    'Class 9',
    'Class 8',
    'Class 7',
    'Class 6',
  ];

  final List<String> _subjects = [
    'All Subjects',
    'Mathematics',
    'English',
    'Science',
    'History',
    'Geography',
    'Computer Science',
  ];

  final List<String> _exams = [
    'Mid Term',
    'Final Term',
    'Unit Test 1',
    'Unit Test 2',
    'Practical Exam',
  ];

  final Map<String, Map<String, Map<String, double>>> _marksData = {
    'Class 10': {
      'Mathematics': {
        'Mid Term': 85.5,
        'Final Term': 92.0,
        'Unit Test 1': 88.0,
        'Unit Test 2': 90.5,
        'Practical Exam': 95.0,
      },
      'English': {
        'Mid Term': 78.0,
        'Final Term': 85.5,
        'Unit Test 1': 80.0,
        'Unit Test 2': 82.5,
        'Practical Exam': 88.0,
      },
      'Science': {
        'Mid Term': 88.5,
        'Final Term': 94.0,
        'Unit Test 1': 90.0,
        'Unit Test 2': 92.5,
        'Practical Exam': 96.0,
      },
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: _buildFloatingActionButton(),
      appBar: AppBar(
        title: const Text('Student Marks'),
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
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Printing marks report...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  // Mobile layout - stack vertically
                  return Column(
                    children: [
                      _buildFilterDropdown('Class', _selectedClass, _classes, (value) {
                        setState(() {
                          _selectedClass = value ?? 'Class 10';
                        });
                      }),
                      const SizedBox(height: 16),
                      _buildFilterDropdown('Subject', _selectedSubject, _subjects, (value) {
                        setState(() {
                          _selectedSubject = value ?? 'All Subjects';
                        });
                      }),
                      const SizedBox(height: 16),
                      _buildFilterDropdown('Exam', _selectedExam, _exams, (value) {
                        setState(() {
                          _selectedExam = value ?? 'Mid Term';
                        });
                      }),
                    ],
                  );
                } else {
                  // Desktop layout - row
                  return Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown('Class', _selectedClass, _classes, (value) {
                          setState(() {
                            _selectedClass = value ?? 'Class 10';
                          });
                        }),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFilterDropdown('Subject', _selectedSubject, _subjects, (value) {
                          setState(() {
                            _selectedSubject = value ?? 'All Subjects';
                          });
                        }),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFilterDropdown('Exam', _selectedExam, _exams, (value) {
                          setState(() {
                            _selectedExam = value ?? 'Mid Term';
                          });
                        }),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          
          // Marks Display
          Expanded(
            child: _buildMarksDisplay(),
          ),
        ],
      ),

    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildMarksDisplay() {
    if (_selectedSubject == 'All Subjects') {
      return _buildAllSubjectsMarks();
    } else {
      return _buildSubjectMarks();
    }
  }

  Widget _buildAllSubjectsMarks() {
    final classData = _marksData[_selectedClass];
    if (classData == null) {
      return const Center(
        child: Text(
          'No marks data available for selected class',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: classData.length,
      itemBuilder: (context, index) {
        final subject = classData.keys.elementAt(index);
        final marks = classData[subject]!;
        final examMark = marks[_selectedExam] ?? 0.0;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getMarkColor(examMark),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  examMark.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: Text(
              subject,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text('Exam: $_selectedExam'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getMarkIcon(examMark),
                  color: _getMarkColor(examMark),
                  size: 30,
                ),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    final userRole = authProvider.user?['role'] ?? 'Super Admin';
                    if (userRole == 'SUPER_ADMIN' || userRole == 'SCHOOL_ADMIN' || userRole == 'TEACHER') {
                      return IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _showEditMarksDialog(subject, _selectedExam, examMark),
                        tooltip: 'Edit Marks',
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubjectMarks() {
    final classData = _marksData[_selectedClass];
    if (classData == null || !classData.containsKey(_selectedSubject)) {
      return const Center(
        child: Text(
          'No marks data available for selected subject',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    final marks = classData[_selectedSubject]!;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: marks.length,
      itemBuilder: (context, index) {
        final exam = marks.keys.elementAt(index);
        final mark = marks[exam]!;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getMarkColor(mark),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  mark.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: Text(
              exam,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text('Subject: $_selectedSubject'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getMarkIcon(mark),
                  color: _getMarkColor(mark),
                  size: 30,
                ),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    final userRole = authProvider.user?['role'] ?? 'Super Admin';
                    if (userRole == 'SUPER_ADMIN' || userRole == 'SCHOOL_ADMIN' || userRole == 'TEACHER') {
                      return IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _showEditMarksDialog(_selectedSubject, exam, mark),
                        tooltip: 'Edit Marks',
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddMarksDialog() {
    String selectedClass = _selectedClass;
    String selectedSubject = _selectedSubject == 'All Subjects' ? 'Mathematics' : _selectedSubject;
    String selectedExam = _selectedExam;
    String selectedSection = 'A';
    String? selectedStudent;
    final marksController = TextEditingController();

    // Available sections
    final List<String> availableSections = ['A', 'B', 'C', 'D'];

    // Get students for the selected class
    final studentProvider = context.read<StudentProvider>();
    final students = studentProvider.students.where((student) => 
      student.className == selectedClass || 
      student.className == selectedClass.replaceAll('Class ', '')
    ).toList();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
        title: const Text('Add New Marks'),
                  content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Student selection dropdown
              if (students.isNotEmpty) ...[
                DropdownButtonFormField<String>(
                  value: selectedStudent,
                  decoration: const InputDecoration(
                    labelText: 'Student Name *',
                    border: OutlineInputBorder(),
                  ),
                  items: students.map((student) {
                    return DropdownMenuItem<String>(
                      value: student.id,
                      child: Text('${student.name} (${student.rollNumber})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedStudent = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a student';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              DropdownButtonFormField<String>(
                value: selectedClass,
                decoration: const InputDecoration(
                  labelText: 'Class *',
                  border: OutlineInputBorder(),
                ),
                items: _classes.map((className) {
                  return DropdownMenuItem(value: className, child: Text(className));
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedClass = value!;
                    selectedStudent = null; // Reset student when class changes
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedSection,
                decoration: const InputDecoration(
                  labelText: 'Section *',
                  border: OutlineInputBorder(),
                ),
                items: availableSections.map((section) {
                  return DropdownMenuItem(value: section, child: Text(section));
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedSection = value!;
                    selectedStudent = null; // Reset student when section changes
                  });
                },
              ),
              const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                value: selectedSubject,
                decoration: const InputDecoration(
                  labelText: 'Subject *',
                  border: OutlineInputBorder(),
                ),
                items: _subjects.where((subject) => subject != 'All Subjects').map((subject) {
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
                  labelText: 'Exam *',
                  border: OutlineInputBorder(),
                ),
                items: _exams.map((exam) {
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
                labelText: 'Marks *',
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
                // Validate all required fields
                if (selectedStudent == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a student'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final marks = double.tryParse(marksController.text);
                if (marks != null && marks >= 0 && marks <= 100) {
                  setState(() {
                    if (!_marksData.containsKey(selectedClass)) {
                      _marksData[selectedClass] = {};
                    }
                    if (!_marksData[selectedClass]!.containsKey(selectedSubject)) {
                      _marksData[selectedClass]![selectedSubject] = {};
                    }
                    _marksData[selectedClass]![selectedSubject]![selectedExam] = marks;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Marks added successfully for student: $marks'),
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

  void _showBulkAddMarksDialog() {
    String selectedClass = _selectedClass;
    String selectedSubject = _selectedSubject == 'All Subjects' ? 'Mathematics' : _selectedSubject;
    String selectedExam = _selectedExam;
    final marksController = TextEditingController();

    // Get students for the selected class
    final studentProvider = context.read<StudentProvider>();
    final students = studentProvider.students.where((student) => 
      student.className == selectedClass || 
      student.className == selectedClass.replaceAll('Class ', '')
    ).toList();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Bulk Add Marks'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Class: $selectedClass'),
                Text('Students: ${students.length}'),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedSubject,
                  decoration: const InputDecoration(
                    labelText: 'Subject *',
                    border: OutlineInputBorder(),
                  ),
                  items: _subjects.where((subject) => subject != 'All Subjects').map((subject) {
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
                    labelText: 'Exam *',
                    border: OutlineInputBorder(),
                  ),
                  items: _exams.map((exam) {
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
                    labelText: 'Marks for All Students *',
                    hintText: 'Enter marks (0-100)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Students in $selectedClass:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...students.take(5).map((student) => Text('• ${student.name} (${student.rollNumber})')),
                      if (students.length > 5) Text('... and ${students.length - 5} more'),
                    ],
                  ),
                ),
              ],
            ),
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
                  setState(() {
                    if (!_marksData.containsKey(selectedClass)) {
                      _marksData[selectedClass] = {};
                    }
                    if (!_marksData[selectedClass]!.containsKey(selectedSubject)) {
                      _marksData[selectedClass]![selectedSubject] = {};
                    }
                    _marksData[selectedClass]![selectedSubject]![selectedExam] = marks;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Marks added successfully for ${students.length} students'),
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
              child: const Text('Add for All'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditMarksDialog(String subject, String exam, double currentMarks) {
    final marksController = TextEditingController(text: currentMarks.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Marks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Class: $_selectedClass'),
            Text('Subject: $subject'),
            Text('Exam: $exam'),
            const SizedBox(height: 16),
            TextField(
              controller: marksController,
              decoration: const InputDecoration(
                labelText: 'Marks',
                hintText: 'Enter marks (0-100)',
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
                setState(() {
                  _marksData[_selectedClass]![subject]![exam] = marks;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Marks updated successfully: $marks')),
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
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Color _getMarkColor(double mark) {
    if (mark >= 90) return Colors.green;
    if (mark >= 80) return Colors.blue;
    if (mark >= 70) return Colors.orange;
    if (mark >= 60) return Colors.yellow;
    return Colors.red;
  }

  IconData _getMarkIcon(double mark) {
    if (mark >= 90) return Icons.star;
    if (mark >= 80) return Icons.check_circle;
    if (mark >= 70) return Icons.info;
    if (mark >= 60) return Icons.warning;
    return Icons.error;
  }

  Widget? _buildFloatingActionButton() {
    final userRole = this.userRole;
    if (userRole == 'SUPER_ADMIN' || userRole == 'SCHOOL_ADMIN' || userRole == 'TEACHER') {
      return FloatingActionButton(
        onPressed: () => _showAddMarksDialog(),
        backgroundColor: Colors.orange[600],
        child: const Icon(Icons.add, color: Colors.white),
      );
    }
    return null;
  }

  String get userRole {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.user?['role'] ?? 'USER';
  }
}
