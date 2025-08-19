import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/app_branding.dart';

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
      appBar: AppBar(
        title: const Text('Student Marks'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
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
          // App Branding for Mobile
          const AppBranding(),
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedClass,
                    decoration: const InputDecoration(
                      labelText: 'Class',
                      border: OutlineInputBorder(),
                    ),
                    items: _classes.map((className) {
                      return DropdownMenuItem(
                        value: className,
                        child: Text(className),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedClass = value ?? 'Class 10';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                    items: _subjects.map((subject) {
                      return DropdownMenuItem(
                        value: subject,
                        child: Text(subject),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubject = value ?? 'All Subjects';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedExam,
                    decoration: const InputDecoration(
                      labelText: 'Exam',
                      border: OutlineInputBorder(),
                    ),
                    items: _exams.map((exam) {
                      return DropdownMenuItem(
                        value: exam,
                        child: Text(exam),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedExam = value ?? 'Mid Term';
                      });
                    },
                  ),
                ),
              ],
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
            trailing: Icon(
              _getMarkIcon(examMark),
              color: _getMarkColor(examMark),
              size: 30,
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
            trailing: Icon(
              _getMarkIcon(mark),
              color: _getMarkColor(mark),
              size: 30,
            ),
          ),
        );
      },
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
}
