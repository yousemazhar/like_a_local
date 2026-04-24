import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/connectivity_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final isOnline = ref.watch(isOnlineProvider).valueOrNull ?? true;
    if (isOnline) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: const ValueKey('offline'),
        width: double.infinity,
        color: LALColors.c800,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 14, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              t.offlineBanner,
              style: LALTypography.labelSmall.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
