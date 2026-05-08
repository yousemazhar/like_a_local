import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/domain/auth_providers.dart';
import '../../place/domain/place.dart';
import '../../place/domain/place_providers.dart';
import '../../saved/domain/saved_providers.dart';

part 'profile_screen.g.dart';

@riverpod
Stream<List<Place>> myOwnedPlaces(MyOwnedPlacesRef ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(placeRepositoryProvider).byOwner(user.uid);
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserDocProvider);
    final pinsAsync = ref.watch(savedPinsProvider);
    final placesAsync = ref.watch(myOwnedPlacesProvider);
    final user = userAsync.valueOrNull;
    final pinCount = pinsAsync.valueOrNull?.length ?? 0;
    final places = placesAsync.valueOrNull ?? const <Place>[];

    return Scaffold(
      backgroundColor: LALColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: LALColors.surface,
            floating: true,
            title: Text(t.profileTitle,
                style: Theme.of(context).textTheme.headlineSmall),
            actions: [
              IconButton(
                onPressed: () => context.push('/settings'),
                icon:
                    const Icon(Icons.settings_outlined, color: LALColors.c900),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),
                _AvatarSection(user: user),
                const SizedBox(height: 20),
                _StatsRow(
                  placesCount: places.length,
                  pinCount: pinCount,
                  helpfulCount: _readCounter(user, 'helpfulCount'),
                ),
                const SizedBox(height: 16),
                _TrustStrip(),
                if (kDebugMode) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/test-payment'),
                      icon: const Icon(Icons.credit_card),
                      label: Text(t.profileTestPay),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _TestPushButton(),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _ShowFcmTokensButton(),
                  ),
                ],
                const SizedBox(height: 24),
                _PlacesGrid(places: places, loading: placesAsync.isLoading),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _readCounter(AppUser? user, String key) {
    // counters are written by Cloud Functions, not yet on AppUser model;
    // surface 0 by default until that field flows through.
    return 0;
  }
}

class _AvatarSection extends StatelessWidget {
  const _AvatarSection({required this.user});
  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final photo = user?.photoUrl;
    final name = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : (user?.email.split('@').first ?? t.profileYourName);
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: LALColors.c100,
              backgroundImage: (photo != null && photo.isNotEmpty)
                  ? CachedNetworkImageProvider(photo)
                  : null,
              child: (photo == null || photo.isEmpty)
                  ? const Icon(Icons.person,
                      color: LALColors.c400, size: 48)
                  : null,
            ),
            if (user?.role == 'super')
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: LALColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.workspace_premium_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(name, style: LALTypography.headlineMedium),
        const SizedBox(height: 4),
        Text(user?.email ?? t.profileLocation, style: LALTypography.bodySmall),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.placesCount,
    required this.pinCount,
    required this.helpfulCount,
  });

  final int placesCount;
  final int pinCount;
  final int helpfulCount;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(value: '$placesCount', label: t.profileStatPlaces),
        const _Divider(),
        _StatItem(value: '$pinCount', label: t.profileStatSaved),
        const _Divider(),
        _StatItem(value: '$helpfulCount', label: t.profileStatHelpful),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: LALTypography.headlineMedium.copyWith(fontSize: 24)),
        const SizedBox(height: 2),
        Text(label, style: LALTypography.bodySmall),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: LALColors.c100);
  }
}

class _TrustStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: LALColors.surface,
        borderRadius: LALRadii.lgBorder,
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_outlined,
              color: LALColors.accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.profileVerified, style: LALTypography.labelLarge),
                Text(t.profileVerifiedBody,
                    style: LALTypography.bodySmall.copyWith(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TestPushButton extends StatefulWidget {
  @override
  State<_TestPushButton> createState() => _TestPushButtonState();
}

class _TestPushButtonState extends State<_TestPushButton> {
  bool _busy = false;

  Future<void> _send() async {
    setState(() => _busy = true);
    try {
      final res = await FirebaseFunctions.instanceFor(region: 'us-central1')
          .httpsCallable('sendTestNotification')
          .call();
      final data = res.data as Map?;
      final tokens = data?['tokens'] ?? 0;
      final delivered = data?['delivered'] ?? 0;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tokens == 0
                ? 'Inbox written. No FCM tokens registered yet — open the app once on a real device to register.'
                : 'Push sent · $delivered / $tokens token(s) delivered.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Test push failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: _busy ? null : _send,
      icon: _busy
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.notifications_active_outlined),
      label: const Text('Test push notification'),
    );
  }
}

class _ShowFcmTokensButton extends StatelessWidget {
  const _ShowFcmTokensButton();

  Future<List<String>> _loadTokens() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const [];
    final snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final raw = snap.data()?['fcmTokens'];
    if (raw is List) {
      return raw.whereType<String>().toList();
    }
    return const [];
  }

  Future<void> _show(BuildContext context) async {
    final tokens = await _loadTokens();
    if (!context.mounted) return;
    if (tokens.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'No FCM tokens registered yet. Open the app on a real device first.'),
        ),
      );
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('FCM tokens (${tokens.length})'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: tokens.length,
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (_, i) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Token ${i + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                SelectableText(
                  tokens[i],
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: tokens.join('\n')),
              );
              if (!ctx.mounted) return;
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text('Copied ${tokens.length} token(s) to clipboard'),
                ),
              );
            },
            child: const Text('Copy all'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _show(context),
      icon: const Icon(Icons.vpn_key_outlined),
      label: const Text('Show FCM registration tokens'),
    );
  }
}

class _PlacesGrid extends StatelessWidget {
  const _PlacesGrid({required this.places, required this.loading});
  final List<Place> places;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(t.profileMyPlaces, style: LALTypography.labelLarge),
        ),
        const SizedBox(height: 12),
        if (loading)
          const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (places.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Icon(Icons.add_location_alt_outlined,
                      color: LALColors.c300, size: 40),
                  const SizedBox(height: 12),
                  Text(t.profileNoPlaces,
                      style: LALTypography.bodyMedium),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: places.length,
              itemBuilder: (context, i) {
                final p = places[i];
                return GestureDetector(
                  onTap: () => context.push('/place/${p.id}'),
                  child: ClipRRect(
                    borderRadius: LALRadii.lgBorder,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (p.mediaUrls.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: p.mediaUrls.first,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(color: LALColors.c100),
                            errorWidget: (_, __, ___) =>
                                Container(color: LALColors.c100),
                          )
                        else
                          Container(color: LALColors.c100),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 28, 10, 8),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black54],
                              ),
                            ),
                            child: Text(
                              p.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: LALTypography.labelLarge
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
