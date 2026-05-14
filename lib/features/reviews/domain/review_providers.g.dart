// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reviewRepositoryHash() => r'1f26171f688c3b836d0beb5584b27f4de91ab52e';

/// See also [reviewRepository].
@ProviderFor(reviewRepository)
final reviewRepositoryProvider = Provider<ReviewRepository>.internal(
  reviewRepository,
  name: r'reviewRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reviewRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReviewRepositoryRef = ProviderRef<ReviewRepository>;
String _$placeReviewsHash() => r'0a0c45600b0f9f2c82236390de29c3dff133b014';

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

/// See also [placeReviews].
@ProviderFor(placeReviews)
const placeReviewsProvider = PlaceReviewsFamily();

/// See also [placeReviews].
class PlaceReviewsFamily extends Family<AsyncValue<List<Review>>> {
  /// See also [placeReviews].
  const PlaceReviewsFamily();

  /// See also [placeReviews].
  PlaceReviewsProvider call(String placeId) {
    return PlaceReviewsProvider(placeId);
  }

  @override
  PlaceReviewsProvider getProviderOverride(
    covariant PlaceReviewsProvider provider,
  ) {
    return call(provider.placeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'placeReviewsProvider';
}

/// See also [placeReviews].
class PlaceReviewsProvider extends AutoDisposeStreamProvider<List<Review>> {
  /// See also [placeReviews].
  PlaceReviewsProvider(String placeId)
    : this._internal(
        (ref) => placeReviews(ref as PlaceReviewsRef, placeId),
        from: placeReviewsProvider,
        name: r'placeReviewsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$placeReviewsHash,
        dependencies: PlaceReviewsFamily._dependencies,
        allTransitiveDependencies:
            PlaceReviewsFamily._allTransitiveDependencies,
        placeId: placeId,
      );

  PlaceReviewsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.placeId,
  }) : super.internal();

  final String placeId;

  @override
  Override overrideWith(
    Stream<List<Review>> Function(PlaceReviewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlaceReviewsProvider._internal(
        (ref) => create(ref as PlaceReviewsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        placeId: placeId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Review>> createElement() {
    return _PlaceReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaceReviewsProvider && other.placeId == placeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, placeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlaceReviewsRef on AutoDisposeStreamProviderRef<List<Review>> {
  /// The parameter `placeId` of this provider.
  String get placeId;
}

class _PlaceReviewsProviderElement
    extends AutoDisposeStreamProviderElement<List<Review>>
    with PlaceReviewsRef {
  _PlaceReviewsProviderElement(super.provider);

  @override
  String get placeId => (origin as PlaceReviewsProvider).placeId;
}

String _$myPlaceReviewHash() => r'5f267b9c938894f2a1979231107da1a500143606';

/// See also [myPlaceReview].
@ProviderFor(myPlaceReview)
const myPlaceReviewProvider = MyPlaceReviewFamily();

/// See also [myPlaceReview].
class MyPlaceReviewFamily extends Family<AsyncValue<Review?>> {
  /// See also [myPlaceReview].
  const MyPlaceReviewFamily();

  /// See also [myPlaceReview].
  MyPlaceReviewProvider call(String placeId) {
    return MyPlaceReviewProvider(placeId);
  }

  @override
  MyPlaceReviewProvider getProviderOverride(
    covariant MyPlaceReviewProvider provider,
  ) {
    return call(provider.placeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'myPlaceReviewProvider';
}

/// See also [myPlaceReview].
class MyPlaceReviewProvider extends AutoDisposeStreamProvider<Review?> {
  /// See also [myPlaceReview].
  MyPlaceReviewProvider(String placeId)
    : this._internal(
        (ref) => myPlaceReview(ref as MyPlaceReviewRef, placeId),
        from: myPlaceReviewProvider,
        name: r'myPlaceReviewProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$myPlaceReviewHash,
        dependencies: MyPlaceReviewFamily._dependencies,
        allTransitiveDependencies:
            MyPlaceReviewFamily._allTransitiveDependencies,
        placeId: placeId,
      );

  MyPlaceReviewProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.placeId,
  }) : super.internal();

  final String placeId;

  @override
  Override overrideWith(
    Stream<Review?> Function(MyPlaceReviewRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MyPlaceReviewProvider._internal(
        (ref) => create(ref as MyPlaceReviewRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        placeId: placeId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Review?> createElement() {
    return _MyPlaceReviewProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyPlaceReviewProvider && other.placeId == placeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, placeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MyPlaceReviewRef on AutoDisposeStreamProviderRef<Review?> {
  /// The parameter `placeId` of this provider.
  String get placeId;
}

class _MyPlaceReviewProviderElement
    extends AutoDisposeStreamProviderElement<Review?>
    with MyPlaceReviewRef {
  _MyPlaceReviewProviderElement(super.provider);

  @override
  String get placeId => (origin as MyPlaceReviewProvider).placeId;
}

String _$reviewNotifierHash() => r'e392af99860ef1cb7726e7dc8664f70b58402350';

/// See also [ReviewNotifier].
@ProviderFor(ReviewNotifier)
final reviewNotifierProvider =
    AutoDisposeNotifierProvider<ReviewNotifier, void>.internal(
      ReviewNotifier.new,
      name: r'reviewNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reviewNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReviewNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
