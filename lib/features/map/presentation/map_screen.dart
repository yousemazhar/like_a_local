import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const CameraPosition _fallbackCamera = CameraPosition(
    target: LatLng(52.5200, 13.4050),
    zoom: 12,
  );

  final Completer<GoogleMapController> _mapController = Completer();
  bool _isLocatingUser = false;
  bool _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeMap());
  }

  Future<void> _initializeMap() async {
    final permission = await _ensureLocationPermission();
    if (!permission) {
      return;
    }

    await _moveCameraToCurrentLocation();
  }

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage('Enable location services to center the map near you.');
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final granted = permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;

    if (mounted) {
      setState(() => _hasLocationPermission = granted);
    }

    if (!granted) {
      _showMessage('Location permission denied. The map will stay interactive.');
    }

    return granted;
  }

  Future<void> _moveCameraToCurrentLocation() async {
    if (_isLocatingUser) {
      return;
    }

    setState(() => _isLocatingUser = true);

    try {
      final position = await Geolocator.getCurrentPosition();
      final controller = await _mapController.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );
    } catch (_) {
      _showMessage('Unable to fetch your current location right now.');
    } finally {
      if (mounted) {
        setState(() => _isLocatingUser = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: _fallbackCamera,
              myLocationEnabled: _hasLocationPermission,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (controller) {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
              },
            ),
          ),

          // App bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 16, color: LALColors.c900),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: LALRadii.pillBorder,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search,
                                color: LALColors.c400, size: 18),
                            const SizedBox(width: 8),
                            Text('Search on map…',
                                style: LALTypography.bodyMedium
                                    .copyWith(color: LALColors.c400)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Near Me FAB
          Positioned(
            bottom: 240,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () async {
                final permission = await _ensureLocationPermission();
                if (!permission) {
                  return;
                }
                await _moveCameraToCurrentLocation();
              },
              backgroundColor:
                  _hasLocationPermission ? LALColors.accent : LALColors.surface,
              foregroundColor:
                  _hasLocationPermission ? Colors.white : LALColors.c900,
              elevation: 2,
              icon: Icon(
                _isLocatingUser
                    ? Icons.location_searching_rounded
                    : Icons.my_location_rounded,
                size: 18,
              ),
              label: Text(
                _isLocatingUser ? 'Locating…' : 'Near Me',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Bottom sheet preview
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _MapBottomSheet(),
          ),
        ],
      ),
    );
  }
}

class _MapBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: LALColors.surface,
        borderRadius: BorderRadius.vertical(top: LALRadii.xl),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 16, spreadRadius: 0),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: LALColors.c200,
                borderRadius: LALRadii.pillBorder,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Tap a pin to preview',
              style: LALTypography.bodyMedium),
          const SizedBox(height: 8),
          Text('3 places near you',
              style: LALTypography.headlineSmall.copyWith(fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined, size: 16),
                  label: const Text('Remind me near'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border, size: 16),
                  label: const Text('Save place'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
