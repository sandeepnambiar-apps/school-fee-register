import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/bus_tracking_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/bus.dart';

class DriverLocationScreen extends StatefulWidget {
  const DriverLocationScreen({super.key});

  @override
  State<DriverLocationScreen> createState() => _DriverLocationScreenState();
}

class _DriverLocationScreenState extends State<DriverLocationScreen> {
  Bus? _selectedBus;
  bool _isUpdating = false;
  String? _error;
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  void _startLocationUpdates() {
    // Update location every 30 seconds
    _locationTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateBusLocation();
    });
  }

  Future<void> _updateBusLocation() async {
    if (_selectedBus == null) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await context.read<BusTrackingProvider>().updateBusLocation(
        _selectedBus!.id,
        position.latitude,
        position.longitude,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to update location: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Location Update'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer2<BusTrackingProvider, AuthProvider>(
        builder: (context, busProvider, authProvider, child) {
          final schoolId = authProvider.user?['schoolId'] ?? '';
          
          // Only show buses for the driver's school
          final availableBuses = busProvider.getBusesForSchool(schoolId);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.directions_bus,
                              color: Colors.blue[600],
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Driver Location Update',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'School: ${authProvider.user?['schoolName'] ?? 'Unknown'}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Select your bus and your location will be automatically updated every 30 seconds.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Bus Selection
                if (availableBuses.isNotEmpty) ...[
                  const Text(
                    'Select Your Bus:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...availableBuses.map((bus) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: RadioListTile<Bus>(
                      value: bus,
                      groupValue: _selectedBus,
                      onChanged: (Bus? value) {
                        setState(() {
                          _selectedBus = value;
                        });
                      },
                      title: Text(
                        'Bus ${bus.busNumber}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Route: ${bus.routeName}'),
                          Text('Driver: ${bus.driverName}'),
                          Text(
                            'Status: ${_getStatusText(bus.currentStatus)}',
                            style: TextStyle(
                              color: _getStatusColor(bus.currentStatus),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      secondary: CircleAvatar(
                        backgroundColor: _getStatusColor(bus.currentStatus),
                        child: Text(
                          bus.busNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )),

                  const SizedBox(height: 24),

                  // Manual Update Button
                  if (_selectedBus != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isUpdating ? null : _updateBusLocation,
                        icon: _isUpdating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.location_on),
                        label: Text(
                          _isUpdating ? 'Updating...' : 'Update Location Now',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ] else ...[
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          'No buses available for your school',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                // Error Display
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _error = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],

                // Status Information
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status Information:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildStatusItem('🟢 At School', 'Bus is at the school'),
                        _buildStatusItem('🟠 On Route', 'Bus is on the way to pick up students'),
                        _buildStatusItem('🔴 Returning', 'Bus is returning to school'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'at_school':
        return Colors.green;
      case 'on_route':
        return Colors.orange;
      case 'returning':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

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
}
