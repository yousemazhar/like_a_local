import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/connectivity_provider.dart';
import '../../../core/widgets/offline_action_snack_bar.dart';
import '../../../features/auth/domain/auth_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

/// Per-day schedule slot. [day] follows DateTime.weekday: 1=Mon … 7=Sun.
class _DaySlot {
  _DaySlot({
    required this.day,
    required this.enabled,
    required this.fromHour,
    required this.fromMinute,
    required this.toHour,
    required this.toMinute,
  });

  final int day;
  bool enabled;
  int fromHour;
  int fromMinute;
  int toHour;
  int toMinute;

  TimeOfDay get from => TimeOfDay(hour: fromHour, minute: fromMinute);
  TimeOfDay get to => TimeOfDay(hour: toHour, minute: toMinute);

  Map<String, dynamic> toMap() => {
    'enabled': enabled,
    'fromHour': fromHour,
    'fromMinute': fromMinute,
    'toHour': toHour,
    'toMinute': toMinute,
  };

  factory _DaySlot.fromMap(int day, Map<dynamic, dynamic> map) => _DaySlot(
    day: day,
    enabled: (map['enabled'] as bool?) ?? false,
    fromHour: (map['fromHour'] as int?) ?? 9,
    fromMinute: (map['fromMinute'] as int?) ?? 0,
    toHour: (map['toHour'] as int?) ?? 17,
    toMinute: (map['toMinute'] as int?) ?? 0,
  );

  factory _DaySlot.defaultForDay(int day) => _DaySlot(
    day: day,
    enabled: day >= 1 && day <= 5,
    fromHour: 9,
    fromMinute: 0,
    toHour: 17,
    toMinute: 0,
  );
}

// ---------------------------------------------------------------------------

class ChatScheduleScreen extends ConsumerStatefulWidget {
  const ChatScheduleScreen({super.key});

  @override
  ConsumerState<ChatScheduleScreen> createState() => _ChatScheduleScreenState();
}

class _ChatScheduleScreenState extends ConsumerState<ChatScheduleScreen> {
  bool _enforceSchedule = false;
  late List<_DaySlot> _slots;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _slots = List.generate(7, (i) => _DaySlot.defaultForDay(i + 1));
    _loadFromFirestore();
  }

  Future<void> _loadFromFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _loading = false);
      return;
    }
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!mounted) return;

    final chatSettings =
        (doc.data()?['chatSettings'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final enforce = (chatSettings['scheduleEnabled'] as bool?) ?? false;
    final schedule =
        (chatSettings['schedule'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};

    final slots = List.generate(7, (i) {
      final dayKey = '${i + 1}';
      final raw = schedule[dayKey];
      if (raw is Map) return _DaySlot.fromMap(i + 1, raw);
      return _DaySlot.defaultForDay(i + 1);
    });

    setState(() {
      _enforceSchedule = enforce;
      _slots = slots;
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (ref.read(isOnlineProvider).valueOrNull == false) {
      showOfflineActionSnackBar(context);
      return;
    }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _saving = true);

    final scheduleMap = {
      for (final s in _slots) '${s.day}': s.toMap(),
    };

    await ref.read(authRepositoryProvider).updateUserSettings(uid, {
      'chatSettings.scheduleEnabled': _enforceSchedule,
      'chatSettings.schedule': scheduleMap,
    });

    if (mounted) {
      setState(() => _saving = false);
      final t = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.chatScheduleSaved)),
      );
    }
  }

  String _dayName(AppLocalizations t, int weekday) {
    switch (weekday) {
      case 1:
        return t.dayMonday;
      case 2:
        return t.dayTuesday;
      case 3:
        return t.dayWednesday;
      case 4:
        return t.dayThursday;
      case 5:
        return t.dayFriday;
      case 6:
        return t.daySaturday;
      default:
        return t.daySunday;
    }
  }

  Future<void> _pickTime(
    _DaySlot slot,
    bool isFrom,
  ) async {
    final initial = isFrom ? slot.from : slot.to;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        slot.fromHour = picked.hour;
        slot.fromMinute = picked.minute;
      } else {
        slot.toHour = picked.hour;
        slot.toMinute = picked.minute;
      }
    });
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: Text(t.chatScheduleTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text(
                t.buttonSave,
                style: LALTypography.labelMedium.copyWith(
                  color: LALColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SizedBox(height: 16),
                _EnforceToggle(
                  value: _enforceSchedule,
                  label: t.chatScheduleEnforce,
                  subtitle: t.chatScheduleEnforceSubtitle,
                  onChanged: (v) => setState(() => _enforceSchedule = v),
                ),
                if (_enforceSchedule) ...[
                  const SizedBox(height: 16),
                  ..._slots.map(
                    (slot) => _DayRow(
                      dayName: _dayName(t, slot.day),
                      slot: slot,
                      fromLabel: t.chatScheduleFrom,
                      toLabel: t.chatScheduleTo,
                      onToggle: (v) => setState(() => slot.enabled = v),
                      onPickFrom: () => _pickTime(slot, true),
                      onPickTo: () => _pickTime(slot, false),
                      formatTime: _formatTime,
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------

class _EnforceToggle extends StatelessWidget {
  const _EnforceToggle({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.onChanged,
  });

  final bool value;
  final String label;
  final String subtitle;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LALColors.surface,
      child: ListTile(
        leading: const Icon(
          Icons.schedule_outlined,
          color: LALColors.c700,
          size: 22,
        ),
        title: Text(
          label,
          style: LALTypography.bodyMedium.copyWith(color: LALColors.c900),
        ),
        subtitle: Text(subtitle, style: LALTypography.bodySmall),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: LALColors.accent,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.dayName,
    required this.slot,
    required this.fromLabel,
    required this.toLabel,
    required this.onToggle,
    required this.onPickFrom,
    required this.onPickTo,
    required this.formatTime,
  });

  final String dayName;
  final _DaySlot slot;
  final String fromLabel;
  final String toLabel;
  final ValueChanged<bool> onToggle;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final String Function(TimeOfDay) formatTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LALColors.surface,
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  dayName,
                  style: LALTypography.bodyMedium.copyWith(
                    color: LALColors.c900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Switch.adaptive(
                value: slot.enabled,
                onChanged: onToggle,
                activeTrackColor: LALColors.accent,
              ),
            ],
          ),
          if (slot.enabled) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                _TimeChip(
                  label: fromLabel,
                  time: formatTime(slot.from),
                  onTap: onPickFrom,
                ),
                const SizedBox(width: 8),
                Text('–', style: LALTypography.bodySmall),
                const SizedBox(width: 8),
                _TimeChip(
                  label: toLabel,
                  time: formatTime(slot.to),
                  onTap: onPickTo,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.label,
    required this.time,
    required this.onTap,
  });

  final String label;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: LALRadii.mdBorder,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: LALColors.surfaceAlt,
          borderRadius: LALRadii.mdBorder,
          border: Border.all(color: LALColors.c200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: LALTypography.labelSmall.copyWith(color: LALColors.c500),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: LALTypography.bodyMedium.copyWith(
                color: LALColors.c900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
