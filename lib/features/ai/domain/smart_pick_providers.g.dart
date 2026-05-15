// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_pick_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$smartPickRepositoryHash() =>
    r'97d80287f73a7a692de34ff77a8552a44da9cc20';

/// See also [smartPickRepository].
@ProviderFor(smartPickRepository)
final smartPickRepositoryProvider = Provider<SmartPickRepository>.internal(
  smartPickRepository,
  name: r'smartPickRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$smartPickRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SmartPickRepositoryRef = ProviderRef<SmartPickRepository>;
String _$smartPickHash() => r'51c5908e7b583359348286c1ddbdae2514dac9a2';

/// Premium-only. Returns `null` for non-premium users.
/// Throws [SmartPickUnavailableException] when Gemini fails — the UI should
/// catch that and silently hide the pick card while keeping the ranked list.
///
/// Copied from [smartPick].
@ProviderFor(smartPick)
final smartPickProvider = AutoDisposeFutureProvider<SmartPick?>.internal(
  smartPick,
  name: r'smartPickProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$smartPickHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SmartPickRef = AutoDisposeFutureProviderRef<SmartPick?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
