import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/connectivity_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/widgets/lal_toast.dart';
import 'core/widgets/offline_banner.dart';
import 'features/auth/domain/auth_providers.dart';
import 'features/notifications/data/fcm_service.dart';
import 'features/reminders/data/reminder_location_service.dart';
import 'l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);

    ref.listen(authStateProvider, (prev, next) {
      final user = next.valueOrNull;
      if (user != null) {
        FcmService.instance.register();
        ReminderLocationService.instance.start(user.uid);
      } else {
        ReminderLocationService.instance.stop();
      }
    });

    return MaterialApp.router(
      title: 'LikeALocal',
      theme: AppTheme.light,
      routerConfig: router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('de')],
      builder: (context, child) => _ConnectivityShell(child: child),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _ConnectivityShell extends ConsumerStatefulWidget {
  const _ConnectivityShell({required this.child});

  final Widget? child;

  @override
  ConsumerState<_ConnectivityShell> createState() => _ConnectivityShellState();
}

class _ConnectivityShellState extends ConsumerState<_ConnectivityShell> {
  bool _hasSeenConnectivity = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    ref.listen(isOnlineProvider, (previous, next) {
      final online = next.valueOrNull;
      if (online == null) return;
      if (!_hasSeenConnectivity) {
        _hasSeenConnectivity = true;
        return;
      }
      LALToast.show(
        context,
        online ? t.offlineBackOnline : t.offlineBanner,
        kind: online ? LALToastKind.success : LALToastKind.warning,
        duration: const Duration(seconds: 2),
      );
    });

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child ?? const SizedBox.shrink(),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(bottom: false, child: OfflineBanner()),
        ),
      ],
    );
  }
}
