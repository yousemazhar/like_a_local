// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$googleSignInHash() => r'367cd1f96536fa0a7f72e2aaad86ec69d81fbc15';

/// See also [googleSignIn].
@ProviderFor(googleSignIn)
final googleSignInProvider = Provider<GoogleSignIn>.internal(
  googleSignIn,
  name: r'googleSignInProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$googleSignInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoogleSignInRef = ProviderRef<GoogleSignIn>;
String _$authRepositoryHash() => r'4798573448e121f701a5f595c45206abb7837aae';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$authStateHash() => r'3e53252b00d8d9b7f963ead64bd4233f9f1b0278';

/// See also [authState].
@ProviderFor(authState)
final authStateProvider = StreamProvider<AppUser?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = StreamProviderRef<AppUser?>;
String _$currentUserDocHash() => r'eb1f74f48e9fc4303138cb83d960f0456d07643c';

/// See also [currentUserDoc].
@ProviderFor(currentUserDoc)
final currentUserDocProvider = StreamProvider<AppUser?>.internal(
  currentUserDoc,
  name: r'currentUserDocProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserDocHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserDocRef = StreamProviderRef<AppUser?>;
String _$userByIdHash() => r'e2f38400a8ae2c7f3e1cf2b6da6da8a9962fea51';

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

/// Public-ish profile lookup for any uid. Used to render owner/author
/// names instead of denormalizing them onto every document.
///
/// Copied from [userById].
@ProviderFor(userById)
const userByIdProvider = UserByIdFamily();

/// Public-ish profile lookup for any uid. Used to render owner/author
/// names instead of denormalizing them onto every document.
///
/// Copied from [userById].
class UserByIdFamily extends Family<AsyncValue<AppUser?>> {
  /// Public-ish profile lookup for any uid. Used to render owner/author
  /// names instead of denormalizing them onto every document.
  ///
  /// Copied from [userById].
  const UserByIdFamily();

  /// Public-ish profile lookup for any uid. Used to render owner/author
  /// names instead of denormalizing them onto every document.
  ///
  /// Copied from [userById].
  UserByIdProvider call(String uid) {
    return UserByIdProvider(uid);
  }

  @override
  UserByIdProvider getProviderOverride(covariant UserByIdProvider provider) {
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
  String? get name => r'userByIdProvider';
}

/// Public-ish profile lookup for any uid. Used to render owner/author
/// names instead of denormalizing them onto every document.
///
/// Copied from [userById].
class UserByIdProvider extends AutoDisposeStreamProvider<AppUser?> {
  /// Public-ish profile lookup for any uid. Used to render owner/author
  /// names instead of denormalizing them onto every document.
  ///
  /// Copied from [userById].
  UserByIdProvider(String uid)
    : this._internal(
        (ref) => userById(ref as UserByIdRef, uid),
        from: userByIdProvider,
        name: r'userByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userByIdHash,
        dependencies: UserByIdFamily._dependencies,
        allTransitiveDependencies: UserByIdFamily._allTransitiveDependencies,
        uid: uid,
      );

  UserByIdProvider._internal(
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
    Stream<AppUser?> Function(UserByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserByIdProvider._internal(
        (ref) => create(ref as UserByIdRef),
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
    return _UserByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserByIdProvider && other.uid == uid;
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
mixin UserByIdRef on AutoDisposeStreamProviderRef<AppUser?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserByIdProviderElement
    extends AutoDisposeStreamProviderElement<AppUser?>
    with UserByIdRef {
  _UserByIdProviderElement(super.provider);

  @override
  String get uid => (origin as UserByIdProvider).uid;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
