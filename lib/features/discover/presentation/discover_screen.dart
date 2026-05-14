import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/lal_chip.dart';
import '../../../core/widgets/lal_header.dart';
import '../../../core/widgets/place_card.dart';
import '../../../core/widgets/savable_place_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../features/notifications/domain/notification_providers.dart';
import '../../../features/place/domain/place.dart';
import '../../../features/place/domain/place_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

const _demoPlaces = [
  (
    title: 'Tasca do Chico',
    neighborhood: 'Alfama',
    category: 'Restaurant',
    imageUrl:
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&q=80',
  ),
  (
    title: 'Miradouro da Graça',
    neighborhood: 'Graça',
    category: 'Viewpoint',
    imageUrl:
        'https://images.unsplash.com/photo-1534430480872-3498386e7856?w=600&q=80',
  ),
  (
    title: 'LX Factory',
    neighborhood: 'Alcântara',
    category: 'Market',
    imageUrl:
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&q=80',
  ),
];

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  int _selectedCategory = 0;
  int _selectedDistanceFilter = 1;
  double _customRadiusKm = 2;
  Position? _currentPosition;
  bool _isLocating = true;

  static const _categoryKeys = <String?>[
    null, // All
    'Restaurant',
    'Café',
    'Bar',
    'Viewpoint',
    'Market',
    'Museum',
    'Park',
  ];

  AsyncValue<List<Place>> _filtered(AsyncValue<List<Place>> source) {
    final key = _categoryKeys[_selectedCategory];
    if (key == null) return source;
    return source.whenData(
      (places) => places
          .where(
            (p) =>
                p.category.toLowerCase() == key.toLowerCase() ||
                p.category.toLowerCase().contains(key.toLowerCase()),
          )
          .toList(growable: false),
    );
  }

  double get _nearbyRadiusKm => switch (_selectedDistanceFilter) {
    0 => 1,
    1 => 5,
    2 => 10,
    _ => _customRadiusKm,
  };

  @override
  void initState() {
    super.initState();
    _loadCurrentPosition();
  }

  Future<void> _loadCurrentPosition() async {
    setState(() => _isLocating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => _isLocating = false);
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _isLocating = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _isLocating = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _editCustomRadius() async {
    final value = await showDialog<double>(
      context: context,
      builder: (_) => _CustomRadiusDialog(initialRadiusKm: _customRadiusKm),
    );

    if (value == null || value <= 0 || !mounted) return;
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;

    setState(() {
      _customRadiusKm = value;
      _selectedDistanceFilter = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final nearbyAsync = _filtered(ref.watch(discoverFeedProvider));
    final trendingAsync = _filtered(ref.watch(trendingPlacesProvider));
    final unreadCount = ref
        .watch(myNotificationsProvider)
        .maybeWhen(
          data: (items) => items.where((n) => !n.read).length,
          orElse: () => 0,
        );

    return Scaffold(
      backgroundColor: LALColors.bg,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: LALHeader(
                    location: 'Lisbon',
                    unreadCount: unreadCount,
                    onNotificationsTap: () => context.push('/notifications'),
                  ),
                ),
                SliverToBoxAdapter(child: _SearchPill()),
                SliverToBoxAdapter(
                  child: _FeaturedSection(
                    featuredAsync: nearbyAsync,
                    currentPosition: _currentPosition,
                    isLocating: _isLocating,
                    radiusKm: _nearbyRadiusKm,
                    selectedDistanceFilter: _selectedDistanceFilter,
                    customRadiusKm: _customRadiusKm,
                    onDistanceFilterSelected: (i) {
                      if (i == 3) {
                        _editCustomRadius();
                      } else {
                        setState(() => _selectedDistanceFilter = i);
                      }
                    },
                    onRetryLocation: _loadCurrentPosition,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _CategoryChips(
                    selected: _selectedCategory,
                    onSelect: (i) => setState(() => _selectedCategory = i),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _TrendingSection(trendingAsync: trendingAsync),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => context.go('/search'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: LALColors.surface,
          borderRadius: LALRadii.pillBorder,
          border: Border.all(color: LALColors.c200),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: LALColors.c400, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                t.discoverSearchHint,
                style: LALTypography.bodyMedium.copyWith(color: LALColors.c400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomRadiusDialog extends StatefulWidget {
  const _CustomRadiusDialog({required this.initialRadiusKm});

  final double initialRadiusKm;

  @override
  State<_CustomRadiusDialog> createState() => _CustomRadiusDialogState();
}

class _CustomRadiusDialogState extends State<_CustomRadiusDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialRadiusKm.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(t.discoverCustomDistance),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: t.discoverDistanceKm,
          suffixText: 'km',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.buttonCancel),
        ),
        FilledButton(
          onPressed: () {
            final parsed = double.tryParse(_controller.text.trim());
            Navigator.of(context).pop(parsed);
          },
          child: Text(t.buttonSave),
        ),
      ],
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection({
    required this.featuredAsync,
    required this.currentPosition,
    required this.isLocating,
    required this.radiusKm,
    required this.selectedDistanceFilter,
    required this.customRadiusKm,
    required this.onDistanceFilterSelected,
    required this.onRetryLocation,
  });

  final AsyncValue<List<Place>> featuredAsync;
  final Position? currentPosition;
  final bool isLocating;
  final double radiusKm;
  final int selectedDistanceFilter;
  final double customRadiusKm;
  final ValueChanged<int> onDistanceFilterSelected;
  final VoidCallback onRetryLocation;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: t.discoverNearYou,
          action: t.discoverSeeAll,
          onActionTap: () => context.push('/map'),
        ),
        const SizedBox(height: 10),
        _DistanceFilters(
          selected: selectedDistanceFilter,
          customRadiusKm: customRadiusKm,
          onSelect: onDistanceFilterSelected,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 360,
          child: isLocating
              ? SkeletonList(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  padding: const EdgeInsets.symmetric(
                    horizontal: LALSpacing.xl,
                  ),
                  itemBuilder: (_, __) =>
                      const SkeletonCard(width: 240, height: 340),
                )
              : currentPosition == null
              ? _LocationUnavailable(onRetry: onRetryLocation)
              : featuredAsync.when(
                  loading: () => SkeletonList(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    padding: const EdgeInsets.symmetric(
                      horizontal: LALSpacing.xl,
                    ),
                    itemBuilder: (_, __) =>
                        const SkeletonCard(width: 240, height: 340),
                  ),
                  error: (_, __) => _NearbyEmpty(onRetry: onRetryLocation),
                  data: (places) {
                    final nearby = _nearbyPlaces(places);
                    return nearby.isEmpty
                        ? _NearbyEmpty(onRetry: onRetryLocation)
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: LALSpacing.xl,
                            ),
                            itemCount: nearby.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (_, i) {
                              final place = nearby[i].place;
                              return SavablePlaceCard(
                                placeId: place.id,
                                imageUrl: place.mediaUrls.isNotEmpty
                                    ? place.mediaUrls.first
                                    : '',
                                title: place.title,
                                neighborhood:
                                    '${place.neighborhood} · ${_formatDistance(nearby[i].distanceMeters)}',
                                category: place.category,
                                rating: place.ratingAvg > 0
                                    ? place.ratingAvg
                                    : null,
                                onTap: () => context.push('/place/${place.id}'),
                              );
                            },
                          );
                  },
                ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  List<_PlaceDistance> _nearbyPlaces(List<Place> places) {
    final position = currentPosition;
    if (position == null) return const [];

    final maxDistanceMeters = radiusKm * 1000;
    final nearby = places
        .where((place) => place.lat != 0 || place.lng != 0)
        .map(
          (place) => _PlaceDistance(
            place: place,
            distanceMeters: Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              place.lat,
              place.lng,
            ),
          ),
        )
        .where((entry) => entry.distanceMeters <= maxDistanceMeters)
        .toList();

    nearby.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    return nearby;
  }

  String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}

class _PlaceDistance {
  const _PlaceDistance({required this.place, required this.distanceMeters});

  final Place place;
  final double distanceMeters;
}

class _DistanceFilters extends StatelessWidget {
  const _DistanceFilters({
    required this.selected,
    required this.customRadiusKm,
    required this.onSelect,
  });

  final int selected;
  final double customRadiusKm;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final labels = [
      '1 km',
      '5 km',
      '10 km',
      '${customRadiusKm.toStringAsFixed(customRadiusKm % 1 == 0 ? 0 : 1)} km',
    ];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => LALChip(
          label: i == 3 ? t.discoverCustomDistanceFilter(labels[i]) : labels[i],
          isSelected: selected == i,
          leadingIcon: i == 3 ? Icons.tune_rounded : null,
          onTap: () => onSelect(i),
        ),
      ),
    );
  }
}

class _LocationUnavailable extends StatelessWidget {
  const _LocationUnavailable({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return _NearbyMessage(
      icon: Icons.location_off_outlined,
      title: t.mapNoLocation,
      body: t.mapNoLocationBody,
      actionLabel: t.errorRetry,
      onAction: onRetry,
    );
  }
}

class _NearbyEmpty extends StatelessWidget {
  const _NearbyEmpty({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return _NearbyMessage(
      icon: Icons.place_outlined,
      title: t.discoverNoNearbyPlaces,
      body: t.discoverNoNearbyPlacesBody,
      actionLabel: t.discoverRefreshLocation,
      onAction: onRetry,
    );
  }
}

class _NearbyMessage extends StatelessWidget {
  const _NearbyMessage({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LALColors.surface,
        borderRadius: LALRadii.xlBorder,
        border: Border.all(color: LALColors.c100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: LALColors.c400, size: 36),
          const SizedBox(height: 10),
          Text(title, style: LALTypography.labelLarge),
          const SizedBox(height: 4),
          Text(
            body,
            textAlign: TextAlign.center,
            style: LALTypography.bodySmall.copyWith(color: LALColors.c500),
          ),
          const SizedBox(height: 14),
          TextButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final categories = <String>[
      t.categoryAll,
      t.categoryRestaurant,
      t.categoryCafe,
      t.categoryBar,
      t.categoryViewpoint,
      t.categoryMarket,
      t.categoryMuseum,
      t.categoryPark,
    ];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => LALChip(
          label: categories[i],
          isSelected: selected == i,
          onTap: () => onSelect(i),
        ),
      ),
    );
  }
}

class _TrendingSection extends StatelessWidget {
  const _TrendingSection({required this.trendingAsync});

  final AsyncValue<List<Place>> trendingAsync;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        SectionTitle(title: t.discoverTrending),
        const SizedBox(height: 12),
        SizedBox(
          height: 168,
          child: trendingAsync.when(
            loading: () => SkeletonList(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
              itemBuilder: (_, __) =>
                  const SkeletonCard(width: 200, height: 148),
            ),
            error: (_, __) => _demoTrendingList(context),
            data: (places) => places.isEmpty
                ? _demoTrendingList(context)
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: LALSpacing.xl,
                    ),
                    itemCount: places.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => SavablePlaceCard(
                      placeId: places[i].id,
                      imageUrl: places[i].mediaUrls.isNotEmpty
                          ? places[i].mediaUrls.first
                          : '',
                      title: places[i].title,
                      neighborhood: places[i].neighborhood,
                      variant: PlaceCardVariant.trending,
                      onTap: () => context.push('/place/${places[i].id}'),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _demoTrendingList(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      itemCount: _demoPlaces.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, i) => PlaceCard(
        imageUrl: _demoPlaces[i].imageUrl,
        title: _demoPlaces[i].title,
        neighborhood: _demoPlaces[i].neighborhood,
        variant: PlaceCardVariant.trending,
        onTap: () => context.push('/place/demo-$i'),
      ),
    );
  }
}
