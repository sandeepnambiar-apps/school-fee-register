import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/app_branding.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  String _selectedClass = 'Class 10';
  String _selectedDay = 'Monday';

  final List<String> _classes = [
    'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5',
    'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'
  ];

  final List<String> _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
  ];

  final Map<String, Map<String, List<Map<String, dynamic>>>> _timetableData = {
    'Class 10': <String, List<Map<String, dynamic>>>{
      'Monday': <Map<String, dynamic>>[
        {'time': '8:00 AM - 9:00 AM', 'subject': 'Mathematics', 'teacher': 'Mr. Johnson'},
        {'time': '9:00 AM - 10:00 AM', 'subject': 'English', 'teacher': 'Ms. Davis'},
        {'time': '10:15 AM - 11:15 AM', 'subject': 'Science', 'teacher': 'Dr. Wilson'},
        {'time': '11:15 AM - 12:15 PM', 'subject': 'History', 'teacher': 'Mr. Brown'},
        {'time': '12:15 PM - 1:15 PM', 'subject': 'Lunch Break', 'teacher': ''},
        {'time': '1:15 PM - 2:15 PM', 'subject': 'Geography', 'teacher': 'Ms. Smith'},
        {'time': '2:15 PM - 3:15 PM', 'subject': 'Computer Science', 'teacher': 'Mr. Lee'},
      ],
      'Tuesday': <Map<String, dynamic>>[
        {'time': '8:00 AM - 9:00 AM', 'subject': 'English', 'teacher': 'Ms. Davis'},
        {'time': '9:00 AM - 10:00 AM', 'subject': 'Mathematics', 'teacher': 'Mr. Johnson'},
        {'time': '10:15 AM - 11:15 AM', 'subject': 'Physics', 'teacher': 'Dr. Wilson'},
        {'time': '11:15 AM - 12:15 PM', 'subject': 'Chemistry', 'teacher': 'Ms. Green'},
        {'time': '12:15 PM - 1:15 PM', 'subject': 'Lunch Break', 'teacher': ''},
        {'time': '1:15 PM - 2:15 PM', 'subject': 'Physical Education', 'teacher': 'Mr. Taylor'},
        {'time': '2:15 PM - 3:15 PM', 'subject': 'Art', 'teacher': 'Ms. White'},
      ],
      'Wednesday': <Map<String, dynamic>>[
        {'time': '8:00 AM - 9:00 AM', 'subject': 'Science', 'teacher': 'Dr. Wilson'},
        {'time': '9:00 AM - 10:00 AM', 'subject': 'Mathematics', 'teacher': 'Mr. Johnson'},
        {'time': '10:15 AM - 11:15 AM', 'subject': 'English', 'teacher': 'Ms. Davis'},
        {'time': '11:15 AM - 12:15 PM', 'subject': 'Biology', 'teacher': 'Dr. Anderson'},
        {'time': '12:15 PM - 1:15 PM', 'subject': 'Lunch Break', 'teacher': ''},
        {'time': '1:15 PM - 2:15 PM', 'subject': 'Economics', 'teacher': 'Mr. Clark'},
        {'time': '2:15 PM - 3:15 PM', 'subject': 'Music', 'teacher': 'Ms. Johnson'},
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Timetable'),
        backgroundColor: Colors.blue,
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
                const SnackBar(content: Text('Printing timetable...')),
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
                    value: _selectedDay,
                    decoration: const InputDecoration(
                      labelText: 'Day',
                      border: OutlineInputBorder(),
                    ),
                    items: _days.map((day) {
                      return DropdownMenuItem(
                        value: day,
                        child: Text(day),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDay = value ?? 'Monday';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Timetable
          Expanded(
            child: _buildTimetable(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetable() {
    final timetable = _timetableData[_selectedClass]?[_selectedDay] ?? [];
    
    if (timetable.isEmpty) {
      return const Center(
        child: Text(
          'No timetable data available for selected class and day',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: timetable.length,
      itemBuilder: (context, index) {
        final period = timetable[index];
        final isBreak = period['subject'] == 'Lunch Break';
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 60,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isBreak ? Colors.orange[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                period['time'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isBreak ? Colors.orange[700] : Colors.blue[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            title: Text(
              period['subject'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isBreak ? Colors.orange[700] : Colors.black87,
              ),
            ),
            subtitle: period['teacher'].isNotEmpty 
                ? Text('Teacher: ${period['teacher']}')
                : null,
            trailing: isBreak 
                ? const Icon(Icons.restaurant, color: Colors.orange)
                : const Icon(Icons.school, color: Colors.blue),
          ),
        );
      },
    );
  }
}

