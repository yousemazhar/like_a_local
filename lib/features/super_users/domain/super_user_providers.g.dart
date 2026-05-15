// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'super_user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$superUserRepositoryHash() =>
    r'0a96b6f659c371ff2069aedbe3f9134eb2127a1c';

/// See also [superUserRepository].
@ProviderFor(superUserRepository)
final superUserRepositoryProvider = Provider<SuperUserRepository>.internal(
  superUserRepository,
  name: r'superUserRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$superUserRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SuperUserRepositoryRef = ProviderRef<SuperUserRepository>;
String _$superUsersHash() => r'bec7b8c153710edf69d8439fef91148060cc60b8';

/// See also [superUsers].
@ProviderFor(superUsers)
final superUsersProvider = AutoDisposeStreamProvider<List<AppUser>>.internal(
  superUsers,
  name: r'superUsersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$superUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SuperUsersRef = AutoDisposeStreamProviderRef<List<AppUser>>;
String _$publicUserHash() => r'306795a0bd744a430b069040d5bd3a8fb9872883';

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

/// See also [publicUser].
@ProviderFor(publicUser)
const publicUserProvider = PublicUserFamily();

/// See also [publicUser].
class PublicUserFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [publicUser].
  const PublicUserFamily();

  /// See also [publicUser].
  PublicUserProvider call(String uid) {
    return PublicUserProvider(uid);
  }

  @override
  PublicUserProvider getProviderOverride(
    covariant PublicUserProvider provider,
  ) {
    return call(provider.uid);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'publicUserProvider';
}

/// See also [publicUser].
class PublicUserProvider extends AutoDisposeStreamProvider<AppUser?> {
  /// See also [publicUser].
  PublicUserProvider(String uid)
    : this._internal(
        (ref) => publicUser(ref as PublicUserRef, uid),
        from: publicUserProvider,
        name: r'publicUserProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$publicUserHash,
        dependencies: PublicUserFamily._dependencies,
        allTransitiveDependencies: PublicUserFamily._allTransitiveDependencies,
        uid: uid,
      );

  PublicUserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    Stream<AppUser?> Function(PublicUserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PublicUserProvider._internal(
        (ref) => create(ref as PublicUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<AppUser?> createElement() {
    return _PublicUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicUserProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PublicUserRef on AutoDisposeStreamProviderRef<AppUser?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _PublicUserProviderElement
    extends AutoDisposeStreamProviderElement<AppUser?>
    with PublicUserRef {
  _PublicUserProviderElement(super.provider);

  @override
  String get uid => (origin as PublicUserProvider).uid;
}

String _$publicUserPlacesHash() => r'7514612823f927c934396a1b626eab6e1aeac48c';

/// See also [publicUserPlaces].
@ProviderFor(publicUserPlaces)
const publicUserPlacesProvider = PublicUserPlacesFamily();

/// See also [publicUserPlaces].
class PublicUserPlacesFamily extends Family<AsyncValue<List<Place>>> {
  /// See also [publicUserPlaces].
  const PublicUserPlacesFamily();

  /// See also [publicUserPlaces].
  PublicUserPlacesProvider call(String uid) {
    return PublicUserPlacesProvider(uid);
  }

  @override
  PublicUserPlacesProvider getProviderOverride(
    covariant PublicUserPlacesProvider provider,
  ) {
    return call(provider.uid);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'publicUserPlacesProvider';
}

/// See also [publicUserPlaces].
class PublicUserPlacesProvider extends AutoDisposeStreamProvider<List<Place>> {
  /// See also [publicUserPlaces].
  PublicUserPlacesProvider(String uid)
    : this._internal(
        (ref) => publicUserPlaces(ref as PublicUserPlacesRef, uid),
        from: publicUserPlacesProvider,
        name: r'publicUserPlacesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$publicUserPlacesHash,
        dependencies: PublicUserPlacesFamily._dependencies,
        allTransitiveDependencies:
            PublicUserPlacesFamily._allTransitiveDependencies,
        uid: uid,
      );

  PublicUserPlacesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    Stream<List<Place>> Function(PublicUserPlacesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PublicUserPlacesProvider._internal(
        (ref) => create(ref as PublicUserPlacesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Place>> createElement() {
    return _PublicUserPlacesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicUserPlacesProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PublicUserPlacesRef on AutoDisposeStreamProviderRef<List<Place>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _PublicUserPlacesProviderElement
    extends AutoDisposeStreamProviderElement<List<Place>>
    with PublicUserPlacesRef {
  _PublicUserPlacesProviderElement(super.provider);

  @override
  String get uid => (origin as PublicUserPlacesProvider).uid;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
