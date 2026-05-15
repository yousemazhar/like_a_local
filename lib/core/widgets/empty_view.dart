import 'package:flutter/material.dart';

import 'lal_state_view.dart';

/// Thin compatibility wrapper around [LALStateView]. Prefer [LALStateView]
/// directly in new code.
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.title,
    required this.body,
    this.action,
    this.onActionTap,
    this.icon,
  });

  final String title;
  final String body;
  final String? action;
  final VoidCallback? onActionTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return LALStateView(
      kind: LALStateKind.empty,
      title: title,
      body: body,
      icon: icon,
      actions: [
        if (action != null && onActionTap != null)
          LALStateAction(label: action!, onTap: onActionTap!),
      ],
    );
  }
}
