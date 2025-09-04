import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../models/bus.dart';
import '../services/api_service.dart';
class BusTrackingProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Get current school ID - simplified approach
  String get _getCurrentSchoolId {
    return '1'; // Default school ID
  }
  
  List<Bus> _buses = [];
  Bus? _selectedBus;
  bool _isLoading = false;
  String? _error;
  Timer? _locationUpdateTimer;
  
  // Current user's location
  Position? _currentLocation;
  
  // Getters
  List<Bus> get buses => _buses;
  Bus? get selectedBus => _selectedBus;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Position? get currentLocation => _currentLocation;
  
  // Get active buses
  List<Bus> get getActiveBuses => _buses.where((bus) => bus.isActive).toList();
  
  // Get buses for a specific student
  List<Bus> getBusesForStudent(String studentId) {
    return _buses.where((bus) => 
      bus.isActive && bus.studentIds.contains(studentId)
    ).toList();
  }
  
  // Get buses for a specific school
  List<Bus> getBusesForSchool(String schoolId) {
    if (schoolId.isEmpty) {
      return _buses.where((bus) => bus.isActive).toList();
    }
    return _buses.where((bus) => 
      bus.isActive && bus.schoolId == schoolId
    ).toList();
  }
  
  // Get all active buses (fallback)
  List<Bus> getAllActiveBuses() {
    return _buses.where((bus) => bus.isActive).toList();
  }

  // Initialize bus tracking
  Future<void> initializeBusTracking() async {
    await _requestLocationPermission();
    await _getCurrentLocation();
    await fetchBuses();
    _startLocationUpdates();
  }

  // Request location permission
  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _error = 'Location services are disabled.';
      notifyListeners();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _error = 'Location permissions are denied.';
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _error = 'Location permissions are permanently denied.';
      notifyListeners();
      return;
    }
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    try {
      _currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Failed to get current location: $e';
      notifyListeners();
    }
  }

  // Fetch buses from API
  Future<void> fetchBuses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // For now, use mock data since backend API might not be ready
      _loadMockBuses();
      
      // TODO: Uncomment when backend API is ready
      // final response = await _apiService.get('/api/buses');
      // if (response.statusCode == 200) {
      //   final List<dynamic> busesData = response.data;
      //   _buses = busesData.map((json) => Bus.fromJson(json)).toList();
      // } else {
      //   _error = 'Failed to fetch buses';
      // }
    } catch (e) {
      _error = 'Error fetching buses: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load mock bus data for testing
  void _loadMockBuses() {
    _buses = [
      Bus(
        id: '1',
        busNumber: 'BUS-001',
        driverName: 'Rajesh Kumar',
        driverPhone: '+91-9876543210',
        routeName: 'Route A - Central City',
        schoolId: _getCurrentSchoolId,
        latitude: 28.6139, // Delhi coordinates
        longitude: 77.2090,
        lastUpdated: DateTime.now(),
        isActive: true,
        studentIds: ['1', '2', '3'],
        currentStatus: 'on_route',
      ),
      Bus(
        id: '2',
        busNumber: 'BUS-002',
        driverName: 'Amit Singh',
        driverPhone: '+91-9876543211',
        routeName: 'Route B - North Area',
        schoolId: _getCurrentSchoolId,
        latitude: 28.7041,
        longitude: 77.1025,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
        isActive: true,
        studentIds: ['4', '5'],
        currentStatus: 'returning',
      ),
      Bus(
        id: '3',
        busNumber: 'BUS-003',
        driverName: 'Suresh Patel',
        driverPhone: '+91-9876543212',
        routeName: 'Route C - South Zone',
        schoolId: _getCurrentSchoolId,
        latitude: 28.4595,
        longitude: 77.0266,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 10)),
        isActive: true,
        studentIds: ['6', '7'],
        currentStatus: 'at_school',
      ),
    ];
  }

  // Select a specific bus
  void selectBus(Bus bus) {
    _selectedBus = bus;
    notifyListeners();
  }

  // Update bus location (for drivers)
  Future<void> updateBusLocation(String busId, double latitude, double longitude) async {
    try {
      final response = await _apiService.post('/api/buses/$busId/location', data: {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (response.statusCode == 200) {
        // Update local bus data
        final index = _buses.indexWhere((bus) => bus.id == busId);
        if (index != -1) {
          _buses[index] = _buses[index].copyWith(
            latitude: latitude,
            longitude: longitude,
            lastUpdated: DateTime.now(),
          );
          notifyListeners();
        }
      }
    } catch (e) {
      _error = 'Failed to update bus location: $e';
      notifyListeners();
    }
  }

  // Start periodic location updates
  void _startLocationUpdates() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchBuses(); // Refresh bus locations every 30 seconds
    });
  }

  // Stop location updates
  void stopLocationUpdates() {
    _locationUpdateTimer?.cancel();
  }



  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }
}
