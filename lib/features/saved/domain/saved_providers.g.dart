// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$savedRepositoryHash() => r'd172e20a69ee10376ce5ab7e7ac02a5f0537a9ad';

/// See also [savedRepository].
@ProviderFor(savedRepository)
final savedRepositoryProvider = Provider<SavedRepository>.internal(
  savedRepository,
  name: r'savedRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$savedRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SavedRepositoryRef = ProviderRef<SavedRepository>;
String _$savedPinsHash() => r'0d32e736d9da8d94de4ce8cfc37b82fb887ce608';

/// See also [savedPins].
@ProviderFor(savedPins)
final savedPinsProvider = AutoDisposeStreamProvider<List<SavedPin>>.internal(
  savedPins,
  name: r'savedPinsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$savedPinsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SavedPinsRef = AutoDisposeStreamProviderRef<List<SavedPin>>;
String _$savedCollectionsHash() => r'6e562a4648ac1e1000e2545ca9f6a0f57eb733a6';

/// See also [savedCollections].
@ProviderFor(savedCollections)
final savedCollectionsProvider =
    AutoDisposeStreamProvider<List<SavedCollection>>.internal(
      savedCollections,
      name: r'savedCollectionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$savedCollectionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SavedCollectionsRef =
    AutoDisposeStreamProviderRef<List<SavedCollection>>;
String _$isPlacePinnedHash() => r'76a77f2183c1c409e7422d24e7e0cfd07167520f';

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

/// See also [isPlacePinned].
@ProviderFor(isPlacePinned)
const isPlacePinnedProvider = IsPlacePinnedFamily();

/// See also [isPlacePinned].
class IsPlacePinnedFamily extends Family<AsyncValue<bool>> {
  /// See also [isPlacePinned].
  const IsPlacePinnedFamily();

  /// See also [isPlacePinned].
  IsPlacePinnedProvider call(String placeId) {
    return IsPlacePinnedProvider(placeId);
  }

  @override
  IsPlacePinnedProvider getProviderOverride(
    covariant IsPlacePinnedProvider provider,
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
  String? get name => r'isPlacePinnedProvider';
}

/// See also [isPlacePinned].
class IsPlacePinnedProvider extends AutoDisposeStreamProvider<bool> {
  /// See also [isPlacePinned].
  IsPlacePinnedProvider(String placeId)
    : this._internal(
        (ref) => isPlacePinned(ref as IsPlacePinnedRef, placeId),
        from: isPlacePinnedProvider,
        name: r'isPlacePinnedProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$isPlacePinnedHash,
        dependencies: IsPlacePinnedFamily._dependencies,
        allTransitiveDependencies:
            IsPlacePinnedFamily._allTransitiveDependencies,
        placeId: placeId,
      );

  IsPlacePinnedProvider._internal(
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
    Stream<bool> Function(IsPlacePinnedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsPlacePinnedProvider._internal(
        (ref) => create(ref as IsPlacePinnedRef),
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
  AutoDisposeStreamProviderElement<bool> createElement() {
    return _IsPlacePinnedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsPlacePinnedProvider && other.placeId == placeId;
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
mixin IsPlacePinnedRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `placeId` of this provider.
  String get placeId;
}

class _IsPlacePinnedProviderElement
    extends AutoDisposeStreamProviderElement<bool>
    with IsPlacePinnedRef {
  _IsPlacePinnedProviderElement(super.provider);

  @override
  String get placeId => (origin as IsPlacePinnedProvider).placeId;
}

String _$savedNotifierHash() => r'c9a99108d793256d1def3d8e5de48e2229dd7442';

/// See also [SavedNotifier].
@ProviderFor(SavedNotifier)
final savedNotifierProvider =
    AutoDisposeNotifierProvider<SavedNotifier, void>.internal(
      SavedNotifier.new,
      name: r'savedNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$savedNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SavedNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
