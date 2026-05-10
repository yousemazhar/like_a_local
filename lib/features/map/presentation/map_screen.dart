import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../place/domain/place.dart';
import '../../place/domain/place_providers.dart';
import '../../saved/domain/saved_providers.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static const CameraPosition _fallbackCamera = CameraPosition(
    target: LatLng(30.0444, 31.2357),
    zoom: 6,
  );

  static const List<_DemoMapPlace> _fallbackPlaces = [
    _DemoMapPlace(
      id: 'khan-el-khalili',
      title: 'Khan El Khalili',
      neighborhood: 'Islamic Cairo',
      category: 'Market',
      lat: 30.0478,
      lng: 31.2625,
      rating: 4.7,
    ),
    _DemoMapPlace(
      id: 'zooba-zamalek',
      title: 'Zooba Zamalek',
      neighborhood: 'Zamalek',
      category: 'Restaurant',
      lat: 30.0628,
      lng: 31.2197,
      rating: 4.5,
    ),
    _DemoMapPlace(
      id: 'cairo-tower',
      title: 'Cairo Tower',
      neighborhood: 'Gezira',
      category: 'Viewpoint',
      lat: 30.0459,
      lng: 31.2243,
      rating: 4.6,
    ),
    _DemoMapPlace(
      id: 'maadi-grand-mall',
      title: 'Grand Cafe Maadi',
      neighborhood: 'Maadi',
      category: 'Cafe',
      lat: 29.9602,
      lng: 31.2569,
      rating: 4.4,
    ),
    _DemoMapPlace(
      id: 'al-azhar-park',
      title: 'Al-Azhar Park',
      neighborhood: 'Salah Salem',
      category: 'Park',
      lat: 30.0400,
      lng: 31.2612,
      rating: 4.8,
    ),
    _DemoMapPlace(
      id: 'point-90',
      title: 'Point 90',
      neighborhood: 'New Cairo',
      category: 'Lifestyle',
      lat: 30.0284,
      lng: 31.4917,
      rating: 4.3,
    ),
  ];

  final Completer<GoogleMapController> _mapController = Completer();
  bool _isLocatingUser = false;
  bool _hasLocationPermission = false;
  _DemoMapPlace? _selectedPlace;
  bool _didFitInitialBounds = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeMap());
  }

  List<_DemoMapPlace> _placesFromFirestore(List<Place> places) {
    return places
        .where((p) => p.lat != 0.0 && p.lng != 0.0)
        .map((p) => _DemoMapPlace(
              id: p.id,
              title: p.title,
              neighborhood:
                  p.neighborhood.isNotEmpty ? p.neighborhood : p.city,
              category: p.category,
              address: p.address,
              lat: p.lat,
              lng: p.lng,
              rating: p.ratingAvg > 0 ? p.ratingAvg : null,
            ))
        .toList(growable: false);
  }

  Future<void> _fitBoundsToPlaces(List<_DemoMapPlace> places) async {
    if (places.length < 2) return;
    double minLat = places.first.lat, maxLat = places.first.lat;
    double minLng = places.first.lng, maxLng = places.first.lng;
    for (final p in places) {
      if (p.lat < minLat) minLat = p.lat;
      if (p.lat > maxLat) maxLat = p.lat;
      if (p.lng < minLng) minLng = p.lng;
      if (p.lng > maxLng) maxLng = p.lng;
    }
    final controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat - 0.05, minLng - 0.05),
          northeast: LatLng(maxLat + 0.05, maxLng + 0.05),
        ),
        48,
      ),
    );
  }

  Future<void> _initializeMap() async {
    final permission = await _ensureLocationPermission();
    if (!permission) {
      return;
    }

    await _moveCameraToCurrentLocation();
  }

  Future<bool> _ensureLocationPermission() async {
    final t = AppLocalizations.of(context)!;
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage(t.mapEnableLocationServices);
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
      _showMessage(t.mapLocationDenied);
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
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.mapCannotFetchLocation);
      }
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

  Future<void> _openDirections(_DemoMapPlace place) async {
    final directionsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${place.lat},${place.lng}&travelmode=driving',
    );

    final launched = await launchUrl(
      directionsUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      _showMessage(AppLocalizations.of(context)!.mapCannotOpenMaps);
    }
  }

  Set<Marker> _buildMarkers(List<_DemoMapPlace> places) {
    return places.map((place) {
      final isSelected = place.id == _selectedPlace?.id;
      return Marker(
        markerId: MarkerId(place.id),
        position: LatLng(place.lat, place.lng),
        infoWindow: InfoWindow(
          title: place.title,
          snippet: '${place.category} · ${place.neighborhood}',
        ),
        zIndexInt: isSelected ? 2 : 1,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected ? BitmapDescriptor.hueOrange : BitmapDescriptor.hueRose,
        ),
        onTap: () {
          setState(() => _selectedPlace = place);
          unawaited(_focusPlace(place));
        },
      );
    }).toSet();
  }

  Future<void> _focusPlace(_DemoMapPlace place) async {
    final controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(place.lat, place.lng),
          zoom: 14.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final feedAsync = ref.watch(discoverFeedProvider);
    final places = feedAsync.maybeWhen(
      data: (list) {
        final mapped = _placesFromFirestore(list);
        return mapped.isNotEmpty ? mapped : _fallbackPlaces;
      },
      orElse: () => _fallbackPlaces,
    );
    _selectedPlace ??= places.first;
    if (!_didFitInitialBounds && places.length > 1) {
      _didFitInitialBounds = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_fitBoundsToPlaces(places));
      });
    }
    return Scaffold(
      backgroundColor: LALColors.bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: _fallbackCamera,
              markers: _buildMarkers(places),
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
                            Text(t.mapSearchOnMap,
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
                _isLocatingUser ? t.mapLocating : t.mapNearMe,
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
            child: _MapBottomSheet(
              place: _selectedPlace!,
              placeCount: places.length,
              onDirectionsTap: () => _openDirections(_selectedPlace!),
              onViewDetails: () =>
                  context.push('/place/${_selectedPlace!.id}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapBottomSheet extends ConsumerWidget {
  const _MapBottomSheet({
    required this.place,
    required this.placeCount,
    required this.onDirectionsTap,
    required this.onViewDetails,
  });

  final _DemoMapPlace place;
  final int placeCount;
  final VoidCallback onDirectionsTap;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final isSaved =
        ref.watch(isPlacePinnedProvider(place.id)).valueOrNull ?? false;
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
          Text(
            '${place.category} in ${place.neighborhood}',
            style: LALTypography.bodyMedium.copyWith(color: LALColors.c500),
          ),
          const SizedBox(height: 8),
          Text(
            place.title,
            style: LALTypography.headlineSmall.copyWith(fontSize: 16),
          ),
          if (place.address.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.place_outlined,
                    size: 14, color: LALColors.c500),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    place.address,
                    style: LALTypography.bodySmall
                        .copyWith(color: LALColors.c700),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                t.mapPickCount(placeCount),
                style: LALTypography.bodySmall,
              ),
              if (place.rating != null) ...[
                const SizedBox(width: 10),
                const Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: LALColors.accent,
                ),
                const SizedBox(width: 4),
                Text(
                  place.rating!.toStringAsFixed(1),
                  style: LALTypography.labelSmall,
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDirectionsTap,
                  icon: const Icon(Icons.directions_outlined, size: 16),
                  label: Text(t.mapDirections),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onViewDetails,
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text('Details'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await ref
                        .read(savedNotifierProvider.notifier)
                        .togglePin(place.id);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        content:
                            Text(isSaved ? 'Removed from saved' : 'Saved'),
                      ),
                    );
                  },
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    size: 16,
                  ),
                  label: Text(isSaved ? 'Saved' : t.placeSave),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DemoMapPlace {
  const _DemoMapPlace({
    required this.id,
    required this.title,
    required this.neighborhood,
    required this.category,
    required this.lat,
    required this.lng,
    this.address = '',
    this.rating,
  });

  final String id;
  final String title;
  final String neighborhood;
  final String category;
  final String address;
  final double lat;
  final double lng;
  final double? rating;
}
