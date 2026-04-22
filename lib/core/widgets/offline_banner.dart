import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: LALColors.c800,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text(
            'No internet connection',
            style: LALTypography.labelSmall
                .copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
