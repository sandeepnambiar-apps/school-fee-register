import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../models/timetable.dart';
import 'multi_school_provider.dart';
import '../services/api_service.dart';
import '../services/timetable_api_service.dart';
class TimetableProvider extends ChangeNotifier {
  List<TimetableEntry> _timetable = [];
  bool _isLoading = false;
  String? _error;
  
  static const String _storageKey = 'timetable_data';

  late final ApiService _apiService;
  late final TimetableApiService _timetableApiService;

  // Get current school ID - simplified approach
  String get _getCurrentSchoolId {
    return '1'; // Default school ID
  }

  // Getters
  List<TimetableEntry> get timetable => _timetable;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with persistent storage
  TimetableProvider() {
    _initializeServices();
    _loadData();
  }

  void _initializeServices() {
    _apiService = ApiService();
    _apiService.initialize();
    _timetableApiService = TimetableApiService(_apiService.dio);
  }

  // Load data from API or persistent storage
  Future<void> _loadData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Try to load from API first (when school context is available)
      try {
        // TODO: Get school ID from context when available
        final schoolId = 1; // Default school ID
        final timetable = await _timetableApiService.getAllAssignments(schoolId);
        _timetable = timetable;
        await _saveData(); // Save to local storage for offline access
      } catch (e) {
        // If API fails, load from local storage
        final prefs = await SharedPreferences.getInstance();
        final timetableJson = prefs.getString(_storageKey);
        
        if (timetableJson != null) {
          final List<dynamic> decoded = json.decode(timetableJson);
          _timetable = decoded.map((json) => TimetableEntry.fromJson(json)).toList();
        } else {
          _loadMockData();
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load timetable: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save data to persistent storage
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final timetableJson = json.encode(_timetable.map((t) => t.toJson()).toList());
    await prefs.setString(_storageKey, timetableJson);
  }

  void _loadMockData() {
    _timetable = [
      TimetableEntry(
        id: '1',
        dayOfWeek: 'Monday',
        startTime: '8:00 AM',
        endTime: '9:00 AM',
        subject: 'Mathematics',
        className: '10A',
        teacherId: '1',
        teacherName: 'Mr. Johnson',
        room: 'Room 101',
        schoolId: '1',
        createdAt: DateTime.now(),
      ),
             TimetableEntry(
         id: '2',
         dayOfWeek: 'Monday',
         startTime: '9:00 AM',
         endTime: '10:00 AM',
         subject: 'English',
         className: '10A',
         teacherId: '2',
         teacherName: 'Ms. Davis',
         room: 'Room 102',
         schoolId: '1',
         createdAt: DateTime.now(),
       ),
       TimetableEntry(
         id: '3',
         dayOfWeek: 'Monday',
         startTime: '10:15 AM',
         endTime: '11:15 AM',
         subject: 'Science',
         className: '10A',
         teacherId: '3',
         teacherName: 'Dr. Wilson',
         room: 'Lab 201',
         schoolId: '1',
         createdAt: DateTime.now(),
       ),
       TimetableEntry(
         id: '4',
         dayOfWeek: 'Tuesday',
         startTime: '8:00 AM',
         endTime: '9:00 AM',
         subject: 'History',
         className: '10A',
         teacherId: '4',
         teacherName: 'Mr. Brown',
         room: 'Room 103',
         schoolId: '1',
         createdAt: DateTime.now(),
       ),
       TimetableEntry(
         id: '5',
         dayOfWeek: 'Tuesday',
         startTime: '9:00 AM',
         endTime: '10:00 AM',
         subject: 'Geography',
         className: '10A',
         teacherId: '5',
         teacherName: 'Ms. Green',
         room: 'Room 104',
         schoolId: '1',
         createdAt: DateTime.now(),
       ),
    ];
  }

  // Load timetable from API
  Future<void> loadTimetable() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      // Data is already loaded from persistent storage
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh timetable from API
  Future<void> refreshTimetable() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Get school ID from context when available
      final currentSchoolId = _getCurrentSchoolId;
      final timetable = await _timetableApiService.getAllAssignments(int.parse(currentSchoolId));
      _timetable = timetable;
      
      await _saveData(); // Save to local storage for offline access
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to refresh timetable: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new timetable entry
  Future<void> addTimetableEntry(Map<String, dynamic> entryData, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get current school context
      final multiSchoolProvider = context.read<MultiSchoolProvider>();
      final currentSchoolId = multiSchoolProvider.currentSchoolId;
      
      if (currentSchoolId == null) {
        throw Exception('No school context available');
      }
      
      final newEntry = TimetableEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dayOfWeek: entryData['dayOfWeek'] ?? entryData['day'] ?? 'Monday',
        startTime: entryData['startTime'] ?? '8:00 AM',
        endTime: entryData['endTime'] ?? '9:00 AM',
        subject: entryData['subject'] ?? '',
        className: entryData['className'] ?? entryData['class'] ?? '',
        teacherId: entryData['teacherId']?.toString() ?? '',
        teacherName: entryData['teacherName'] ?? entryData['teacher'] ?? '',
        room: entryData['room'] ?? '',
        schoolId: currentSchoolId,
        createdAt: DateTime.now(),
      );
      
      _timetable.add(newEntry);
      await _saveData(); // Save to persistent storage
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update timetable entry
  Future<void> updateTimetableEntry(Map<String, dynamic> entryData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final id = entryData['id'];
      final index = _timetable.indexWhere((entry) => entry.id == id);
      if (index != -1) {
        final existingEntry = _timetable[index];
        final updatedEntry = existingEntry.copyWith(
          dayOfWeek: entryData['dayOfWeek'] ?? entryData['day'] ?? existingEntry.dayOfWeek,
          startTime: entryData['startTime'] ?? existingEntry.startTime,
          endTime: entryData['endTime'] ?? existingEntry.endTime,
          subject: entryData['subject'] ?? existingEntry.subject,
          className: entryData['className'] ?? entryData['class'] ?? existingEntry.className,
          teacherId: entryData['teacherId']?.toString() ?? existingEntry.teacherId,
          teacherName: entryData['teacherName'] ?? entryData['teacher'] ?? existingEntry.teacherName,
          room: entryData['room'] ?? existingEntry.room,
        );
        
        _timetable[index] = updatedEntry;
        await _saveData(); // Save to persistent storage
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete timetable entry
  Future<void> deleteTimetableEntry(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      _timetable.removeWhere((entry) => entry.id == id);
      await _saveData(); // Save to persistent storage
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get timetable by day
  List<TimetableEntry> getTimetableByDay(String day) {
    return _timetable.where((entry) => entry.dayOfWeek == day).toList();
  }

  // Get timetable by class
  List<TimetableEntry> getTimetableByClass(String className) {
    return _timetable.where((entry) => entry.className == className).toList();
  }

  // Get timetable by teacher
  List<TimetableEntry> getTimetableByTeacher(String teacher) {
    return _timetable.where((entry) => entry.teacherName == teacher).toList();
  }

  // Get timetable by subject
  List<TimetableEntry> getTimetableBySubject(String subject) {
    return _timetable.where((entry) => entry.subject == subject).toList();
  }

  // Get available days
  List<String> get availableDays {
    final days = _timetable.map((entry) => entry.dayOfWeek).toSet().toList();
    days.sort();
    return days;
  }

  // Get available classes
  List<String> get availableClasses {
    final classes = _timetable.map((entry) => entry.className).toSet().toList();
    classes.sort();
    return classes;
  }

  // Get available subjects
  List<String> get availableSubjects {
    final subjects = _timetable.map((entry) => entry.subject).toSet().toList();
    subjects.sort();
    return subjects;
  }

  // Get available teachers
  List<String> get availableTeachers {
    final teachers = _timetable.map((entry) => entry.teacherName).toSet().toList();
    teachers.sort();
    return teachers;
  }

  // Clear all data (for testing)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    _timetable.clear();
    notifyListeners();
  }

  // Reset to mock data
  Future<void> resetToMockData() async {
    _loadMockData();
    await _saveData();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Filter by school context
  void filterBySchoolContext(String? schoolId) {
    if (schoolId == null) {
      // Show all data if no school context
      notifyListeners();
      return;
    }
    
    // Filter timetable entries by school
    final filteredTimetable = _timetable.where((t) => t.schoolId == schoolId).toList();
    
    // Update the filtered lists (you might want to add separate filtered lists)
    notifyListeners();
  }

  // Get timetable for current school
  List<TimetableEntry> getTimetableForCurrentSchool(String? schoolId) {
    if (schoolId == null) return [];
    return _timetable.where((t) => t.schoolId == schoolId).toList();
  }
}
