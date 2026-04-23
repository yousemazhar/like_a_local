// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$placeRepositoryHash() => r'c1591403788d9fd53e56e1fc62532888f1cc4f4d';

/// See also [placeRepository].
@ProviderFor(placeRepository)
final placeRepositoryProvider = Provider<PlaceRepository>.internal(
  placeRepository,
  name: r'placeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$placeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlaceRepositoryRef = ProviderRef<PlaceRepository>;
String _$discoverFeedHash() => r'608a20f1ed32eebf3b954d0b9dee7a1945cf9bc1';

/// See also [discoverFeed].
@ProviderFor(discoverFeed)
final discoverFeedProvider = AutoDisposeStreamProvider<List<Place>>.internal(
  discoverFeed,
  name: r'discoverFeedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$discoverFeedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DiscoverFeedRef = AutoDisposeStreamProviderRef<List<Place>>;
String _$featuredPlacesHash() => r'46b52fced1be15d143120675430c0473d61c5d75';

/// See also [featuredPlaces].
@ProviderFor(featuredPlaces)
final featuredPlacesProvider = AutoDisposeStreamProvider<List<Place>>.internal(
  featuredPlaces,
  name: r'featuredPlacesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$featuredPlacesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeaturedPlacesRef = AutoDisposeStreamProviderRef<List<Place>>;
String _$trendingPlacesHash() => r'c1cb7d11b9d52bda6c7b1a3f9b0911ba44d21a78';

/// See also [trendingPlaces].
@ProviderFor(trendingPlaces)
final trendingPlacesProvider = AutoDisposeStreamProvider<List<Place>>.internal(
  trendingPlaces,
  name: r'trendingPlacesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trendingPlacesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrendingPlacesRef = AutoDisposeStreamProviderRef<List<Place>>;
String _$placeDetailHash() => r'ab82b84a157b174a6b2a2ea16c6a9d318f5d974e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [placeDetail].
@ProviderFor(placeDetail)
const placeDetailProvider = PlaceDetailFamily();

/// See also [placeDetail].
class PlaceDetailFamily extends Family<AsyncValue<Place?>> {
  /// See also [placeDetail].
  const PlaceDetailFamily();

  /// See also [placeDetail].
  PlaceDetailProvider call(String id) {
    return PlaceDetailProvider(id);
  }

  @override
  PlaceDetailProvider getProviderOverride(
    covariant PlaceDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'placeDetailProvider';
}

/// See also [placeDetail].
class PlaceDetailProvider extends AutoDisposeStreamProvider<Place?> {
  /// See also [placeDetail].
  PlaceDetailProvider(String id)
    : this._internal(
        (ref) => placeDetail(ref as PlaceDetailRef, id),
        from: placeDetailProvider,
        name: r'placeDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$placeDetailHash,
        dependencies: PlaceDetailFamily._dependencies,
        allTransitiveDependencies: PlaceDetailFamily._allTransitiveDependencies,
        id: id,
      );

  PlaceDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<Place?> Function(PlaceDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlaceDetailProvider._internal(
        (ref) => create(ref as PlaceDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Place?> createElement() {
    return _PlaceDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaceDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlaceDetailRef on AutoDisposeStreamProviderRef<Place?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PlaceDetailProviderElement
    extends AutoDisposeStreamProviderElement<Place?>
    with PlaceDetailRef {
  _PlaceDetailProviderElement(super.provider);

  @override
  String get id => (origin as PlaceDetailProvider).id;
}

String _$searchPlacesHash() => r'e0b56f3ece7491f39c25cadbb82d08fdff8918d8';

/// See also [searchPlaces].
@ProviderFor(searchPlaces)
const searchPlacesProvider = SearchPlacesFamily();

/// See also [searchPlaces].
class SearchPlacesFamily extends Family<AsyncValue<List<Place>>> {
  /// See also [searchPlaces].
  const SearchPlacesFamily();

  /// See also [searchPlaces].
  SearchPlacesProvider call(String query) {
    return SearchPlacesProvider(query);
  }

  @override
  SearchPlacesProvider getProviderOverride(
    covariant SearchPlacesProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchPlacesProvider';
}

/// See also [searchPlaces].
class SearchPlacesProvider extends AutoDisposeStreamProvider<List<Place>> {
  /// See also [searchPlaces].
  SearchPlacesProvider(String query)
    : this._internal(
        (ref) => searchPlaces(ref as SearchPlacesRef, query),
        from: searchPlacesProvider,
        name: r'searchPlacesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchPlacesHash,
        dependencies: SearchPlacesFamily._dependencies,
        allTransitiveDependencies:
            SearchPlacesFamily._allTransitiveDependencies,
        query: query,
      );

  SearchPlacesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    Stream<List<Place>> Function(SearchPlacesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchPlacesProvider._internal(
        (ref) => create(ref as SearchPlacesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Place>> createElement() {
    return _SearchPlacesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchPlacesProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchPlacesRef on AutoDisposeStreamProviderRef<List<Place>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchPlacesProviderElement
    extends AutoDisposeStreamProviderElement<List<Place>>
    with SearchPlacesRef {
  _SearchPlacesProviderElement(super.provider);

  @override
  String get query => (origin as SearchPlacesProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
