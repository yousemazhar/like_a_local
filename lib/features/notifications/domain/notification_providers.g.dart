// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationRepositoryHash() =>
    r'83b40224d05710a721d03e24f4316672e3124f9d';

/// See also [notificationRepository].
@ProviderFor(notificationRepository)
final notificationRepositoryProvider =
    Provider<NotificationRepository>.internal(
      notificationRepository,
      name: r'notificationRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationRepositoryRef = ProviderRef<NotificationRepository>;
String _$myNotificationsHash() => r'06c3164d91ba46d98dac2ae3c8263372475f85c1';

/// See also [myNotifications].
@ProviderFor(myNotifications)
final myNotificationsProvider =
    AutoDisposeStreamProvider<List<AppNotification>>.internal(
      myNotifications,
      name: r'myNotificationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$myNotificationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyNotificationsRef =
    AutoDisposeStreamProviderRef<List<AppNotification>>;
String _$notificationActionsHash() =>
    r'cfa2dfebea2c00fc09e417e0b7b370d08802edd2';

/// See also [NotificationActions].
@ProviderFor(NotificationActions)
final notificationActionsProvider =
    AutoDisposeNotifierProvider<NotificationActions, void>.internal(
      NotificationActions.new,
      name: r'notificationActionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
