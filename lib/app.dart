import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/locale_provider.dart';
import 'features/auth/domain/auth_providers.dart';
import 'features/notifications/data/fcm_service.dart';
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
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
