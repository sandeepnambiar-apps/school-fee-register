import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/timetable_provider.dart';
import '../../models/timetable.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/timetable_card_image.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  String _selectedClass = 'Class 10';
  String _selectedDay = 'Monday';
  bool _showAddForm = false;

  final List<String> _classes = [
    'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5',
    'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'
  ];

  final List<String> _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
  ];

  final List<String> _subjects = [
    'Mathematics', 'English', 'Science', 'History', 'Geography', 'Physics',
    'Chemistry', 'Biology', 'Computer Science', 'Physical Education', 'Art', 'Music',
    'Economics', 'Literature', 'Social Studies'
  ];

  final List<String> _teachers = [
    'Mr. Johnson', 'Ms. Davis', 'Dr. Wilson', 'Mr. Brown', 'Ms. Smith',
    'Mr. Lee', 'Ms. Green', 'Mr. Taylor', 'Ms. White', 'Dr. Anderson',
    'Mr. Clark', 'Ms. Johnson'
  ];

  final List<String> _rooms = [
    'Room 101', 'Room 102', 'Room 103', 'Room 104', 'Room 105',
    'Lab 201', 'Lab 202', 'Computer Lab', 'Art Room', 'Music Room',
    'Gym', 'Library'
  ];

  final List<String> _types = ['Theory', 'Practical', 'Lab', 'Activity'];

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _timeController = TextEditingController();
  final _subjectController = TextEditingController();
  final _teacherController = TextEditingController();
  final _roomController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default values
    _subjectController.text = _subjects[0];
    _teacherController.text = _teachers[0];
    _roomController.text = _rooms[0];
    _typeController.text = _types[0];
  }

  @override
  void dispose() {
    _timeController.dispose();
    _subjectController.dispose();
    _teacherController.dispose();
    _roomController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
          // Add Timetable Button (for SuperAdmin, Admin, Teacher)
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final userRole = authProvider.user?['role'] ?? '';
              if (userRole == 'Super Admin' || userRole == 'School Admin' || userRole == 'Teacher') {
                return IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _showAddForm = !_showAddForm;
                    });
                  },
                  tooltip: 'Add Timetable Entry',
                );
              }
              return const SizedBox.shrink();
            },
          ),
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
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final userRole = authProvider.user?['role'] ?? '';
              // Show Add button only for Teacher and Admin roles
              if (userRole == 'Teacher' || userRole == 'School Admin' || userRole == 'Super Admin') {
                return IconButton(
                  icon: Icon(_showAddForm ? Icons.visibility : Icons.add),
                  onPressed: () {
                    setState(() {
                      _showAddForm = !_showAddForm;
                    });
                  },
                  tooltip: _showAddForm ? 'Hide Form' : 'Add Entry',
                );
              }
              return const SizedBox.shrink();
            },
          ),
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
          // Add Timetable Form (for Teacher and Admin)
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final userRole = authProvider.user?['role'] ?? '';
              if (_showAddForm && (userRole == 'Teacher' || userRole == 'School Admin' || userRole == 'Super Admin')) {
                return _buildAddTimetableForm();
              }
              return const SizedBox.shrink();
            },
          ),
          
          // Timetable Header Image
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                const TimetableCardImage(),
                const SizedBox(height: 16),
                Text(
                  'School Timetable',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage and view your class schedules',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
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
                        _selectedClass = value!;
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
                        _selectedDay = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Timetable Content
          Expanded(
            child: _buildTimetableContent(),
          ),
        ],
      ),
      // Floating Action Button for adding timetable entries
      floatingActionButton: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final userRole = authProvider.user?['role'] ?? '';
          if (userRole == 'Super Admin' || userRole == 'School Admin' || userRole == 'Teacher') {
            return FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showAddForm = !_showAddForm;
                });
              },
              backgroundColor: Colors.blue,
              child: Icon(
                _showAddForm ? Icons.close : Icons.add,
                color: Colors.white,
              ),
              tooltip: _showAddForm ? 'Close Add Form' : 'Add Timetable Entry',
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAddTimetableForm() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.add_circle, color: Colors.orange[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Add Timetable Entry',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Class and Day Selection
                if (isMobile) ...[
                  // Mobile: Stack vertically
                  _buildFormField(
                    'Class',
                    DropdownButtonFormField<String>(
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
                          _selectedClass = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    'Day',
                    DropdownButtonFormField<String>(
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
                          _selectedDay = value!;
                        });
                      },
                    ),
                  ),
                ] else ...[
                  // Desktop: Row layout
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          'Class',
                          DropdownButtonFormField<String>(
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
                                _selectedClass = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          'Day',
                          DropdownButtonFormField<String>(
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
                                _selectedDay = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                
                // Time, Subject
                if (isMobile) ...[
                  _buildFormField(
                    'Time',
                    TextFormField(
                      controller: _timeController,
                      decoration: const InputDecoration(
                        labelText: 'Time (e.g., 8:00 AM - 9:00 AM)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter time';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    'Subject',
                    DropdownButtonFormField<String>(
                      value: _subjectController.text,
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
                        _subjectController.text = value!;
                      },
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          'Time',
                          TextFormField(
                            controller: _timeController,
                            decoration: const InputDecoration(
                              labelText: 'Time (e.g., 8:00 AM - 9:00 AM)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter time';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          'Subject',
                          DropdownButtonFormField<String>(
                            value: _subjectController.text,
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
                              _subjectController.text = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                
                // Teacher, Room, Type
                if (isMobile) ...[
                  _buildFormField(
                    'Teacher',
                    DropdownButtonFormField<String>(
                      value: _teacherController.text,
                      decoration: const InputDecoration(
                        labelText: 'Teacher',
                        border: OutlineInputBorder(),
                      ),
                      items: _teachers.map((teacher) {
                        return DropdownMenuItem(
                          value: teacher,
                          child: Text(teacher),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _teacherController.text = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    'Room',
                    DropdownButtonFormField<String>(
                      value: _roomController.text,
                      decoration: const InputDecoration(
                        labelText: 'Room',
                        border: OutlineInputBorder(),
                      ),
                      items: _rooms.map((room) {
                        return DropdownMenuItem(
                          value: room,
                          child: Text(room),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _roomController.text = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    'Type',
                    DropdownButtonFormField<String>(
                      value: _typeController.text,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      items: _types.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _typeController.text = value!;
                      },
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          'Teacher',
                          DropdownButtonFormField<String>(
                            value: _teacherController.text,
                            decoration: const InputDecoration(
                              labelText: 'Teacher',
                              border: OutlineInputBorder(),
                            ),
                            items: _teachers.map((teacher) {
                              return DropdownMenuItem(
                                value: teacher,
                                child: Text(teacher),
                              );
                            }).toList(),
                            onChanged: (value) {
                              _teacherController.text = value!;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          'Room',
                          DropdownButtonFormField<String>(
                            value: _roomController.text,
                            decoration: const InputDecoration(
                              labelText: 'Room',
                              border: OutlineInputBorder(),
                            ),
                            items: _rooms.map((room) {
                              return DropdownMenuItem(
                                value: room,
                                child: Text(room),
                              );
                            }).toList(),
                            onChanged: (value) {
                              _roomController.text = value!;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          'Type',
                          DropdownButtonFormField<String>(
                            value: _typeController.text,
                            decoration: const InputDecoration(
                              labelText: 'Type',
                              border: OutlineInputBorder(),
                            ),
                            items: _types.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              _typeController.text = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showAddForm = false;
                          _resetForm();
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _addTimetableEntry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add Entry'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormField(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTimetableContent() {
    return Consumer<TimetableProvider>(
      builder: (context, timetableProvider, child) {
        final timetable = timetableProvider.timetable;
        
        // Filter timetable by selected class and day
        final filteredTimetable = timetable.where((entry) {
          return entry.className == _selectedClass && entry.dayOfWeek == _selectedDay;
        }).toList();
        
        if (filteredTimetable.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No timetable entries for $_selectedClass on $_selectedDay',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    final userRole = authProvider.user?['role'] ?? '';
                    if (userRole == 'Super Admin' || userRole == 'School Admin' || userRole == 'Teacher') {
                      return Column(
                        children: [
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showAddForm = true;
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add First Entry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Or use the + button in the top bar or floating action button',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredTimetable.length,
          itemBuilder: (context, index) {
            final entry = filteredTimetable[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.schedule,
                    color: Colors.orange[600],
                    size: 20,
                  ),
                ),
                title: Text(
                  entry.subject,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${entry.startTime} - ${entry.endTime}'),
                    Text('${entry.teacherName} • ${entry.room}'),
                  ],
                ),
                trailing: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    final userRole = authProvider.user?['role'] ?? '';
                    if (userRole == 'Teacher' || userRole == 'School Admin' || userRole == 'Super Admin') {
                      return PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editTimetableEntry(entry);
                          } else if (value == 'delete') {
                            _deleteTimetableEntry(entry.id);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 16),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 16),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _addTimetableEntry() {
    if (_formKey.currentState!.validate()) {
      final newEntry = {
        'class': _selectedClass,
        'day': _selectedDay,
        'time': _timeController.text,
        'subject': _subjectController.text,
        'teacher': _teacherController.text,
        'room': _roomController.text,
        'type': _typeController.text,
      };
      
      context.read<TimetableProvider>().addTimetableEntry(newEntry, context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Timetable entry added successfully!')),
      );
      
      setState(() {
        _showAddForm = false;
        _resetForm();
      });
    }
  }

  void _editTimetableEntry(TimetableEntry entry) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit functionality coming soon!')),
    );
  }

  void _deleteTimetableEntry(String id) {
    if (id != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Entry'),
          content: const Text('Are you sure you want to delete this timetable entry?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<TimetableProvider>().deleteTimetableEntry(id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Entry deleted successfully!')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }
  }

  void _resetForm() {
    _timeController.clear();
    _subjectController.text = _subjects[0];
    _teacherController.text = _teachers[0];
    _roomController.text = _rooms[0];
    _typeController.text = _types[0];
  }
}

