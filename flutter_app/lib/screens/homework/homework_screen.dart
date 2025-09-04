import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/homework_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/app_branding.dart';
import '../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeworkProvider>().loadAssignments();
      context.read<HomeworkProvider>().loadSubmissions();
      context.read<HomeworkProvider>().loadGrades();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homework Management'),
        backgroundColor: Colors.lightBlue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Assignments'),
            Tab(text: 'Submissions'),
            Tab(text: 'Grading'),
          ],
        ),
      ),
      body: Column(
        children: [
          const AppBranding(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _AssignmentsTab(),
                _SubmissionsTab(),
                _GradingTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssignmentsTab extends StatelessWidget {
  const _AssignmentsTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeworkProvider>(
      builder: (context, homeworkProvider, child) {
        if (homeworkProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Assignments (${homeworkProvider.assignments.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.lightBlue[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      final role = auth.user?['role'] ?? 'Super Admin';
                      if (role == 'Parent') {
                        return const SizedBox.shrink();
                      }
                      return PrimaryButton(
                        text: 'Add Assignment',
                        onPressed: () => _showAddAssignmentDialog(context),
                        backgroundColor: Colors.lightBlue[600],
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: homeworkProvider.assignments.isEmpty
                  ? const Center(
                      child: Text(
                        'No assignments found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: homeworkProvider.assignments.length,
                      itemBuilder: (context, index) {
                        final assignment = homeworkProvider.assignments[index];
                        return _buildAssignmentCard(context, assignment, homeworkProvider);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAssignmentCard(BuildContext context, Map<String, dynamic> assignment, HomeworkProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.lightBlue[100],
          child: Icon(
            Icons.assignment,
            color: Colors.lightBlue[700],
          ),
        ),
        title: Text(
          assignment['title'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subject: ${assignment['subject']}'),
            Text('Due: ${assignment['dueDate']}'),
            Text('Status: ${assignment['status']}'),
          ],
        ),
        trailing: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            final role = auth.user?['role'] ?? 'Super Admin';
            if (role == 'Parent') {
              return const SizedBox.shrink();
            }
            return PopupMenuButton(
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
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
                    _showAddAssignmentDialog(context, assignment);
                    break;
                  case 'delete':
                    _showDeleteConfirmationDialog(context, assignment, provider);
                    break;
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _showAddAssignmentDialog(BuildContext context, [Map<String, dynamic>? assignment]) {
    final isEditing = assignment != null;
    final titleController = TextEditingController(text: assignment?['title'] ?? '');
    final subjectController = TextEditingController(text: assignment?['subject'] ?? '');
    final descriptionController = TextEditingController(text: assignment?['description'] ?? '');
    final dueDateController = TextEditingController(text: assignment?['dueDate'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Assignment' : 'Add New Assignment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dueDateController,
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  border: OutlineInputBorder(),
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
              if (titleController.text.isNotEmpty && subjectController.text.isNotEmpty) {
                final assignmentData = {
                  'id': assignment?['id'] ?? DateTime.now().millisecondsSinceEpoch,
                  'title': titleController.text,
                  'subject': subjectController.text,
                  'description': descriptionController.text,
                  'dueDate': dueDateController.text,
                  'status': 'Active',
                };

                if (isEditing) {
                  context.read<HomeworkProvider>().updateAssignment(assignmentData);
                } else {
                  context.read<HomeworkProvider>().addAssignment(assignmentData);
                }

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Assignment ${isEditing ? 'updated' : 'added'} successfully!'),
                    backgroundColor: Colors.green[600],
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue[600],
              foregroundColor: Colors.white,
            ),
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Map<String, dynamic> assignment, HomeworkProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: Text('Are you sure you want to delete "${assignment['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              provider.deleteAssignment(assignment['id']);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${assignment['title']} deleted successfully'),
                  backgroundColor: Colors.red[600],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SubmissionsTab extends StatelessWidget {
  const _SubmissionsTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeworkProvider>(
      builder: (context, homeworkProvider, child) {
        if (homeworkProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Submissions (${homeworkProvider.submissions.length})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.lightBlue[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: homeworkProvider.submissions.isEmpty
                  ? const Center(
                      child: Text(
                        'No submissions found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: homeworkProvider.submissions.length,
                      itemBuilder: (context, index) {
                        final submission = homeworkProvider.submissions[index];
                        return _buildSubmissionCard(context, submission);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubmissionCard(BuildContext context, Map<String, dynamic> submission) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Icon(
            Icons.upload_file,
            color: Colors.green[700],
          ),
        ),
        title: Text(
          submission['studentName'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assignment: ${submission['assignmentTitle']}'),
            Text('Submitted: ${submission['submittedDate']}'),
            Text('Status: ${submission['status']}'),
          ],
        ),
        trailing: _getStatusChip(submission['status']),
      ),
    );
  }

  Widget _getStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Submitted':
        color = Colors.blue;
        break;
      case 'Graded':
        color = Colors.green;
        break;
      case 'Late':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }
}

class _GradingTab extends StatelessWidget {
  const _GradingTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeworkProvider>(
      builder: (context, homeworkProvider, child) {
        if (homeworkProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Grades (${homeworkProvider.grades.length})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.lightBlue[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: homeworkProvider.grades.isEmpty
                  ? const Center(
                      child: Text(
                        'No grades found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: homeworkProvider.grades.length,
                      itemBuilder: (context, index) {
                        final grade = homeworkProvider.grades[index];
                        return _buildGradeCard(context, grade);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGradeCard(BuildContext context, Map<String, dynamic> grade) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.amber[100],
          child: Icon(
            Icons.grade,
            color: Colors.amber[700],
          ),
        ),
        title: Text(
          grade['studentName'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assignment: ${grade['assignmentTitle']}'),
            Text('Grade: ${grade['grade']}'),
            Text('Comments: ${grade['comments']}'),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber[600],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            grade['grade'],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

