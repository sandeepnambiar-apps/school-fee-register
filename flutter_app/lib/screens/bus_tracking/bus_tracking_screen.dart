import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/bus_tracking_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/bus.dart';

class BusTrackingScreen extends StatefulWidget {
  const BusTrackingScreen({super.key});

  @override
  State<BusTrackingScreen> createState() => _BusTrackingScreenState();
}

class _BusTrackingScreenState extends State<BusTrackingScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BusTrackingProvider>().initializeBusTracking();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // Helper method to get status color for UI elements
  Color _getStatusColor(String status) {
    switch (status) {
      case 'at_school':
        return Colors.green;
      case 'on_route':
        return Colors.orange;
      case 'returning':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get status text
  String _getStatusText(String status) {
    switch (status) {
      case 'at_school':
        return 'At School';
      case 'on_route':
        return 'On Route';
      case 'returning':
        return 'Returning';
      default:
        return 'Unknown';
    }
  }

  // Helper method to format time
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  // Helper method to get bus status color for Google Maps markers
  double _getBusStatusColor(String status) {
    switch (status) {
      case 'at_school':
        return BitmapDescriptor.hueGreen;
      case 'on_route':
        return BitmapDescriptor.hueOrange;
      case 'returning':
        return BitmapDescriptor.hueRed;
      default:
        return BitmapDescriptor.hueBlue;
    }
  }

  // Helper method to calculate distance
  double _calculateDistance(Bus bus) {
    final busProvider = context.read<BusTrackingProvider>();
    if (busProvider.currentLocation == null) return 0.0;
    
    return Geolocator.distanceBetween(
      busProvider.currentLocation!.latitude,
      busProvider.currentLocation!.longitude,
      bus.latitude,
      bus.longitude,
    ) / 1000; // Convert to kilometers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Bus'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<BusTrackingProvider>().fetchBuses();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer2<BusTrackingProvider, AuthProvider>(
        builder: (context, busProvider, authProvider, child) {
          if (busProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (busProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${busProvider.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      busProvider.clearError();
                      busProvider.fetchBuses();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Bus List Header
              _buildBusListHeader(authProvider.user?['role'] ?? 'Parent'),
              
              // Map
              Expanded(
                child: _buildMap(busProvider, authProvider),
              ),
              
              // Bus List
              _buildBusList(busProvider, authProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBusListHeader(String userRole) {
    return Container(
      padding: const EdgeInsets.all(16),
              color: Colors.white,
      child: Row(
        children: [
          Icon(
            Icons.directions_bus,
            color: Colors.blue[600],
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            userRole == 'Parent' ? 'Your Child\'s Bus' : 'All Buses',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Consumer<BusTrackingProvider>(
            builder: (context, busProvider, child) {
              return Text(
                '${busProvider.getActiveBuses.length} Active',
                style: TextStyle(
                  color: Colors.green[600],
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMap(BusTrackingProvider busProvider, AuthProvider authProvider) {
    // For web, show a bus information card instead of Google Maps
    if (kIsWeb) {
      final userRole = authProvider.user?['role'] ?? 'Parent';
      final schoolId = authProvider.user?['schoolId'];
      
      List<Bus> relevantBuses;
      if (userRole == 'Parent') {
        final studentId = authProvider.user?['studentId'] ?? '';
        relevantBuses = busProvider.getBusesForStudent(studentId);
        if (relevantBuses.isEmpty) {
          relevantBuses = busProvider.getAllActiveBuses();
        }
      } else {
        relevantBuses = busProvider.getBusesForSchool(schoolId ?? '');
        if (relevantBuses.isEmpty) {
          relevantBuses = busProvider.getAllActiveBuses();
        }
      }
      
      return Container(
        height: 300,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.map, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Text(
                    'Bus Tracking Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: relevantBuses.isEmpty
                  ? const Center(
                      child: Text(
                        'No buses available for tracking',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: relevantBuses.length,
                      itemBuilder: (context, index) {
                        final bus = relevantBuses[index];
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              Icons.directions_bus,
                              color: _getStatusColor(bus.currentStatus),
                            ),
                            title: Text(
                              'Bus ${bus.busNumber}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Driver: ${bus.driverName}'),
                                Text('Route: ${bus.routeName}'),
                                Text('Status: ${_getStatusText(bus.currentStatus)}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.phone),
                              onPressed: () {
                                // TODO: Implement call functionality
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    }
    
    final userRole = authProvider.user?['role'] ?? 'Parent';
    final schoolId = authProvider.user?['schoolId'];
    
    // Get relevant buses based on user role
    List<Bus> relevantBuses;
    if (userRole == 'Parent') {
      final studentId = authProvider.user?['studentId'] ?? '';
      relevantBuses = busProvider.getBusesForStudent(studentId);
    } else {
      relevantBuses = busProvider.getBusesForSchool(schoolId ?? '');
    }

    // Create markers for buses
    _markers = relevantBuses.map((bus) {
      return Marker(
        markerId: MarkerId(bus.id),
        position: LatLng(bus.latitude, bus.longitude),
        infoWindow: InfoWindow(
          title: 'Bus ${bus.busNumber}',
          snippet: 'Driver: ${bus.driverName}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _getBusStatusColor(bus.currentStatus),
        ),
        onTap: () {
          busProvider.selectBus(bus);
        },
      );
    }).toSet();

    // Add current location marker if available
    if (busProvider.currentLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            busProvider.currentLocation!.latitude,
            busProvider.currentLocation!.longitude,
          ),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Current position',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Calculate map bounds
    if (relevantBuses.isNotEmpty) {
      double minLat = relevantBuses.map((b) => b.latitude).reduce((a, b) => a < b ? a : b);
      double maxLat = relevantBuses.map((b) => b.latitude).reduce((a, b) => a > b ? a : b);
      double minLng = relevantBuses.map((b) => b.longitude).reduce((a, b) => a < b ? a : b);
      double maxLng = relevantBuses.map((b) => b.longitude).reduce((a, b) => a > b ? a : b);

      // Add padding to bounds
      const double padding = 0.01;
      minLat -= padding;
      maxLat += padding;
      minLng -= padding;
      maxLng += padding;

      // Animate to bounds
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLngBounds(
              LatLngBounds(
                southwest: LatLng(minLat, minLng),
                northeast: LatLng(maxLat, maxLng),
              ),
              50, // padding
            ),
          );
        }
      });
    }

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      initialCameraPosition: const CameraPosition(
        target: LatLng(12.9716, 77.5946), // Default to Bangalore
        zoom: 12,
      ),
      markers: _markers,
      polylines: _polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      mapType: MapType.normal,
    );
  }

  Widget _buildBusList(BusTrackingProvider busProvider, AuthProvider authProvider) {
    final userRole = authProvider.user?['role'] ?? 'Parent';
    final schoolId = authProvider.user?['schoolId'];
    
    List<Bus> relevantBuses;
    if (userRole == 'Parent') {
      final studentId = authProvider.user?['studentId'] ?? '';
      relevantBuses = busProvider.getBusesForStudent(studentId);
      if (relevantBuses.isEmpty) {
        relevantBuses = busProvider.getAllActiveBuses();
      }
    } else {
      relevantBuses = busProvider.getBusesForSchool(schoolId ?? '');
      if (relevantBuses.isEmpty) {
        relevantBuses = busProvider.getAllActiveBuses();
      }
    }

    if (relevantBuses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: const Center(
          child: Text(
            'No buses found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: relevantBuses.length,
        itemBuilder: (context, index) {
          final bus = relevantBuses[index];
          final isSelected = busProvider.selectedBus?.id == bus.id;
          
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: isSelected ? Colors.blue[50] : Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(bus.currentStatus),
                child: Text(
                  bus.busNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                'Bus ${bus.busNumber}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Driver: ${bus.driverName}'),
                  Text('Route: ${bus.routeName}'),
                  Text(
                    'Last Updated: ${_formatTime(bus.lastUpdated)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(bus.currentStatus),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(bus.currentStatus),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_calculateDistance(bus)} km',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              onTap: () {
                busProvider.selectBus(bus);
                _animateToBus(bus);
              },
            ),
          );
        },
      ),
    );
  }

  void _animateToBus(Bus bus) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(bus.latitude, bus.longitude),
          15,
        ),
      );
    }
  }
}
