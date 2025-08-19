import 'package:flutter/material.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/app_branding.dart';
import 'package:go_router/go_router.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _loadMockEvents();
  }

  void _loadMockEvents() {
    _events = [
      {
        'id': 1,
        'title': 'Annual Sports Day',
        'description': 'School-wide sports competition',
        'date': DateTime(2024, 2, 15),
        'type': 'Event',
        'color': Colors.blue,
      },
      {
        'id': 2,
        'title': 'Parent-Teacher Meeting',
        'description': 'Quarterly parent-teacher conference',
        'date': DateTime(2024, 2, 20),
        'type': 'Meeting',
        'color': Colors.green,
      },
      {
        'id': 3,
        'title': 'Science Fair',
        'description': 'Student science project exhibition',
        'date': DateTime(2024, 2, 25),
        'type': 'Competition',
        'color': Colors.orange,
      },
      {
        'id': 4,
        'title': 'Holiday - Republic Day',
        'description': 'National holiday',
        'date': DateTime(2024, 1, 26),
        'type': 'Holiday',
        'color': Colors.red,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Calendar'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEventDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // App Branding for Mobile
          const AppBranding(),
          // Calendar Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.purple[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.purple[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Calendar Grid
          Expanded(
            child: _buildCalendarGrid(),
          ),

          // Events for Selected Day
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Events for ${_getDayName(_selectedDay)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _buildEventsList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 42, // 6 weeks * 7 days
      itemBuilder: (context, index) {
        final dayOffset = index - firstWeekday + 1;
        final day = dayOffset > 0 && dayOffset <= daysInMonth ? dayOffset : null;
        final date = day != null ? DateTime(_focusedDay.year, _focusedDay.month, day) : null;
        final isSelected = date != null && _isSameDay(date, _selectedDay);
        final isToday = date != null && _isSameDay(date, DateTime.now());
        final hasEvents = date != null && _getEventsForDate(date).isNotEmpty;

        if (day == null) {
          return Container(); // Empty space
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = date!;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.purple[100] : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isToday ? Colors.purple : Colors.grey[300]!,
                width: isToday ? 2 : 1,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.purple[700] : Colors.black87,
                    ),
                  ),
                ),
                if (hasEvents)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventsList() {
    final dayEvents = _getEventsForDate(_selectedDay);

    if (dayEvents.isEmpty) {
      return const Center(
        child: Text(
          'No events for this day',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: dayEvents.length,
      itemBuilder: (context, index) {
        final event = dayEvents[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: event['color'],
                shape: BoxShape.circle,
              ),
            ),
            title: Text(event['title']),
            subtitle: Text(event['description']),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
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
                  case 'edit':
                    _showAddEditEventDialog(context, event);
                    break;
                  case 'delete':
                    _showDeleteEventDialog(context, event);
                    break;
                }
              },
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getEventsForDate(DateTime date) {
    return _events.where((event) => _isSameDay(event['date'], date)).toList();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _getDayName(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return '${days[date.weekday - 1]}, ${date.day} ${_getMonthName(date.month)}';
  }

  void _showAddEventDialog(BuildContext context) {
    _showAddEditEventDialog(context, null);
  }

  void _showAddEditEventDialog(BuildContext context, Map<String, dynamic>? event) {
    showDialog(
      context: context,
      builder: (context) => _AddEditEventDialog(event: event),
    );
  }

  void _showDeleteEventDialog(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            text: 'Delete',
            backgroundColor: Colors.red,
            onPressed: () {
              setState(() {
                _events.removeWhere((e) => e['id'] == event['id']);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Event "${event['title']}" deleted')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AddEditEventDialog extends StatefulWidget {
  final Map<String, dynamic>? event;

  const _AddEditEventDialog({this.event});

  @override
  State<_AddEditEventDialog> createState() => _AddEditEventDialogState();
}

class _AddEditEventDialogState extends State<_AddEditEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedType = 'Event';
  Color _selectedColor = Colors.blue;
  bool _isRecurring = false;
  String _recurrenceType = 'None';

  final List<String> _eventTypes = [
    'Event', 'Meeting', 'Competition', 'Holiday', 'Exam', 'Other'
  ];

  final List<String> _recurrenceTypes = [
    'None', 'Daily', 'Weekly', 'Monthly', 'Yearly'
  ];

  final List<Color> _colorOptions = [
    Colors.blue, Colors.green, Colors.orange, Colors.purple, 
    Colors.red, Colors.teal, Colors.indigo, Colors.pink
  ];

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _titleController.text = widget.event!['title'];
      _descriptionController.text = widget.event!['description'];
      _selectedDate = widget.event!['date'];
      _selectedColor = widget.event!['color'];
      _selectedType = widget.event!['type'];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.event != null;
    final title = isEditing ? 'Edit Event' : 'Add New Event';

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value?.isEmpty == true ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Date'),
                      subtitle: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _selectedDate = date;
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Time'),
                      subtitle: Text(_selectedTime.format(context)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (time != null) {
                          setState(() {
                            _selectedTime = time;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Event Type',
                  border: OutlineInputBorder(),
                ),
                items: _eventTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value ?? 'Event';
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Event Color:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _colorOptions.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == color ? Colors.black : Colors.grey,
                          width: _selectedColor == color ? 3 : 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isRecurring,
                    onChanged: (value) {
                      setState(() {
                        _isRecurring = value ?? false;
                        if (!_isRecurring) {
                          _recurrenceType = 'None';
                        }
                      });
                    },
                  ),
                  const Text('Recurring Event'),
                ],
              ),
              if (_isRecurring) ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _recurrenceType,
                  decoration: const InputDecoration(
                    labelText: 'Recurrence',
                    border: OutlineInputBorder(),
                  ),
                  items: _recurrenceTypes.skip(1).map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _recurrenceType = value ?? 'Daily';
                    });
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        PrimaryButton(
          text: isEditing ? 'Update' : 'Add',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final event = {
                'id': widget.event?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
                'title': _titleController.text,
                'description': _descriptionController.text,
                'date': DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  _selectedDate.day,
                  _selectedTime.hour,
                  _selectedTime.minute,
                ),
                'type': _selectedType,
                'color': _selectedColor,
                'isRecurring': _isRecurring,
                'recurrenceType': _recurrenceType,
              };

              if (isEditing) {
                // Update existing event
                final index = context.findAncestorStateOfType<_CalendarScreenState>()!
                    ._events.indexWhere((e) => e['id'] == event['id']);
                if (index != -1) {
                  context.findAncestorStateOfType<_CalendarScreenState>()!
                      .setState(() {
                    context.findAncestorStateOfType<_CalendarScreenState>()!
                        ._events[index] = event;
                  });
                }
              } else {
                // Add new event
                context.findAncestorStateOfType<_CalendarScreenState>()!
                    .setState(() {
                  context.findAncestorStateOfType<_CalendarScreenState>()!
                      ._events.add(event);
                });
              }

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Event ${isEditing ? 'updated' : 'added'} successfully!'),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
