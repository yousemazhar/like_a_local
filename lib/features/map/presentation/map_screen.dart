import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _showingNearMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      body: Stack(
        children: [
          // Map placeholder (replace with GoogleMap widget after API key setup)
          Positioned.fill(
            child: Container(
              color: LALColors.c50,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_outlined, color: LALColors.c300, size: 64),
                    SizedBox(height: 12),
                    Text('Add Google Maps API key\nto enable the map',
                        style: LALTypography.bodyMedium,
                        textAlign: TextAlign.center),
                    SizedBox(height: 8),
                    Text(
                      'android/app/src/main/AndroidManifest.xml\nios/Runner/AppDelegate.swift',
                      style: LALTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
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
                              color: Colors.black.withOpacity(0.08),
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
              onPressed: () => setState(() => _showingNearMe = !_showingNearMe),
              backgroundColor:
                  _showingNearMe ? LALColors.accent : LALColors.surface,
              foregroundColor:
                  _showingNearMe ? Colors.white : LALColors.c900,
              elevation: 2,
              icon: const Icon(Icons.my_location_rounded, size: 18),
              label: const Text('Near Me',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
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
