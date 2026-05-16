import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/offline_exception.dart';
import '../../../core/providers/connectivity_provider.dart';
import '../../../core/widgets/lal_state_view.dart';
import '../../../core/widgets/lal_toast.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../auth/domain/auth_providers.dart';
import '../../chat/data/chat_repository.dart';
import '../../chat/domain/chat_providers.dart';
import '../../reminders/domain/reminder_providers.dart';
import '../../reviews/domain/review.dart';
import '../../reviews/domain/review_providers.dart';
import '../../reviews/presentation/review_composer_sheet.dart';
import '../../saved/domain/saved_providers.dart';
import '../domain/place.dart';
import '../domain/place_providers.dart';
import 'widgets/media_gallery.dart';

const _contentOverlap = 22.0;

class PlaceScreen extends ConsumerWidget {
  const PlaceScreen({super.key, required this.placeId});

  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeAsync = ref.watch(placeDetailProvider(placeId));

    return placeAsync.when(
      loading: () => const _PlaceScaffoldLoading(),
      error: (e, _) => _PlaceScaffoldError(onBack: () => context.pop()),
      data: (place) => place == null
          ? _PlaceScaffoldError(onBack: () => context.pop())
          : _PlaceScaffoldData(place: place),
    );
  }
}

class _PlaceScaffoldLoading extends StatelessWidget {
  const _PlaceScaffoldLoading();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SkeletonBox(width: double.infinity, height: 420),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonBox(width: 80, height: 24),
                  SizedBox(height: 10),
                  SkeletonBox(width: 220, height: 32),
                  SizedBox(height: 8),
                  SkeletonBox(width: 140, height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceScaffoldError extends StatelessWidget {
  const _PlaceScaffoldError({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: LALStateView(
        kind: LALStateKind.notFound,
        title: t.placeNotFound,
        body: t.placeNotFoundBody,
        actions: [LALStateAction(label: t.placeGoBack, onTap: onBack)],
      ),
    );
  }
}

class _PlaceScaffoldData extends ConsumerStatefulWidget {
  const _PlaceScaffoldData({required this.place});

  final Place place;

  @override
  ConsumerState<_PlaceScaffoldData> createState() => _PlaceScaffoldDataState();
}

class _PlaceScaffoldDataState extends ConsumerState<_PlaceScaffoldData> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final place = widget.place;
    final savedAsync = ref.watch(isPlacePinnedProvider(place.id));
    final isSaved = savedAsync.valueOrNull ?? false;
    final reminderAsync = ref.watch(isReminderSetProvider(place.id));
    final isReminded = reminderAsync.valueOrNull ?? false;
    final currentUid = ref.watch(authStateProvider).valueOrNull?.uid;
    final isOwner = currentUid != null && currentUid == place.ownerUid;
    final isPremium =
        ref.watch(currentUserDocProvider).valueOrNull?.premium ?? false;

    return Scaffold(
      backgroundColor: LALColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: LALColors.surface,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: LALColors.c900,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            actions: [
              if (isOwner)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: LALColors.c900,
                      ),
                      onPressed: () {
                        if (ref.read(isOnlineProvider).valueOrNull == false) {
                          LALToast.showOffline(context);
                          return;
                        }
                        context.push('/edit-place/${place.id}');
                      },
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: const Icon(
                      Icons.share_outlined,
                      size: 16,
                      color: LALColors.c900,
                    ),
                    onPressed: () async {
                      final link = 'likealocal://place/${place.id}';
                      await Clipboard.setData(ClipboardData(text: link));
                      if (!context.mounted) return;
                      LALToast.show(
                        context,
                        'Link copied to clipboard',
                        kind: LALToastKind.info,
                        duration: const Duration(seconds: 2),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: PlaceMediaGallery(
                photoUrls: place.mediaUrls,
                videoUrls: place.videoUrls,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: _contentOverlap),
              child: Transform.translate(
                offset: const Offset(0, -_contentOverlap),
                child: Container(
                  decoration: const BoxDecoration(
                    color: LALColors.bg,
                    borderRadius: BorderRadius.vertical(top: LALRadii.xl),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: LALSpacing.xl,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: const BoxDecoration(
                                color: LALColors.surfaceAlt,
                                borderRadius: LALRadii.pillBorder,
                              ),
                              child: Text(
                                place.category,
                                style: LALTypography.labelSmall,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              place.title,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              [
                                if (place.neighborhood.isNotEmpty)
                                  place.neighborhood,
                                if (place.city.isNotEmpty) place.city,
                              ].join(' · '),
                              style: LALTypography.bodySmall,
                            ),
                            if (place.ratingAvg > 0) ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: LALColors.accent,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    place.ratingAvg.toStringAsFixed(1),
                                    style: LALTypography.labelMedium,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    t.placeReviewsCount(place.ratingCount),
                                    style: LALTypography.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                            if ((place.priceLevel ?? '').isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: const BoxDecoration(
                                  color: LALColors.surfaceAlt,
                                  borderRadius: LALRadii.pillBorder,
                                ),
                                child: Text(
                                  place.priceLevel!,
                                  style: LALTypography.labelSmall,
                                ),
                              ),
                            ],
                            if (place.address.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.place_outlined,
                                    size: 16,
                                    color: LALColors.c500,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      place.address,
                                      style: LALTypography.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (place.description.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              Text(
                                t.placeAbout,
                                style: LALTypography.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                place.description,
                                style: LALTypography.bodyMedium,
                              ),
                            ],
                            if (place.moods.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              Text(
                                t.placeMoodsTitle,
                                style: LALTypography.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final m in place.moods)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: LALColors.surfaceAlt,
                                        borderRadius: LALRadii.pillBorder,
                                      ),
                                      child: Text(
                                        _localizeMood(t, m),
                                        style: LALTypography.labelSmall,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                            if (place.dishes.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              Text(
                                t.placeDishes,
                                style: LALTypography.labelLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final d in place.dishes)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: LALColors.surface,
                                        borderRadius: LALRadii.pillBorder,
                                      ),
                                      child: Text(
                                        d.name,
                                        style: LALTypography.labelSmall,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (place.tips.isNotEmpty) ...[
                        _TipsCard(tips: place.tips),
                        const SizedBox(height: 20),
                      ],
                      _ContributorCard(
                        ownerIsSuper: place.ownerIsSuper,
                        ownerUid: place.ownerUid,
                        placeId: place.id,
                      ),
                      const SizedBox(height: 24),
                      _ReviewsSection(placeId: place.id),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _PlaceBottomBar(
        place: place,
        isSaved: isSaved,
        isReminded: isReminded,
        isPremium: isPremium,
        onToggleSave: () async {
          try {
            if (!isSaved && !isPremium) {
              final pins = ref.read(savedPinsProvider).valueOrNull ?? [];
              if (pins.length >= 10) {
                _showPinLimitDialog(context, t);
                return;
              }
            }
            await ref.read(savedNotifierProvider.notifier).togglePin(place.id);
          } on OfflineException {
            if (context.mounted) LALToast.showOffline(context);
          }
        },
        onToggleReminder: () async {
          if (ref.read(isOnlineProvider).valueOrNull == false) {
            LALToast.showOffline(context);
            return;
          }
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid == null) return;
          final repo = ref.read(reminderRepositoryProvider);
          if (isReminded) {
            await repo.remove(uid, place.id);
            if (!context.mounted) return;
            LALToast.show(
              context,
              t.reminderRemovedFor(place.title),
              kind: LALToastKind.success,
              duration: const Duration(seconds: 2),
            );
          } else {
            if (!isPremium) {
              final reminders =
                  ref.read(remindersStreamProvider).valueOrNull ?? [];
              if (reminders.length >= 3) {
                if (!context.mounted) return;
                _showReminderLimitDialog(context, t);
                return;
              }
            }
            if (place.lat == 0.0 && place.lng == 0.0) {
              if (!context.mounted) return;
              LALToast.show(
                context,
                t.errorGenericBody,
                kind: LALToastKind.error,
                duration: const Duration(seconds: 2),
              );
              return;
            }
            await repo.set(
              uid: uid,
              placeId: place.id,
              placeTitle: place.title,
              lat: place.lat,
              lng: place.lng,
            );
            if (!context.mounted) return;
            LALToast.show(
              context,
              t.reminderNearPlace(place.title),
              kind: LALToastKind.success,
              duration: const Duration(seconds: 2),
            );
          }
        },
      ),
    );
  }

  void _showReminderLimitDialog(BuildContext context, AppLocalizations t) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.reminderFreeLimitTitle),
        content: Text(t.reminderFreeLimitBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.buttonCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/premium');
            },
            child: Text(t.savedUpgrade),
          ),
        ],
      ),
    );
  }

  void _showPinLimitDialog(BuildContext context, AppLocalizations t) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.pinFreeLimitTitle),
        content: Text(t.pinFreeLimitBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.buttonCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/premium');
            },
            child: Text(t.savedUpgrade),
          ),
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.tips});

  final List<PlaceTip> tips;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: LALColors.surface,
        borderRadius: LALRadii.lgBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.placeTips, style: LALTypography.labelLarge),
          const SizedBox(height: 12),
          for (var i = 0; i < tips.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: LALColors.surfaceAlt,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: LALTypography.labelSmall.copyWith(
                        color: LALColors.c700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(tips[i].text, style: LALTypography.bodyMedium),
                ),
              ],
            ),
            if (i < tips.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

String _localizeMood(AppLocalizations t, String key) {
  switch (key) {
    case 'Romantic':
      return t.moodRomantic;
    case 'Family':
      return t.moodFamily;
    case 'Hidden Gem':
      return t.moodHiddenGem;
    case 'Lively':
      return t.moodLively;
    case 'Peaceful':
      return t.moodPeaceful;
    case 'Foodie':
      return t.moodFoodie;
    case 'Off-the-beaten-track':
      return t.moodOffBeaten;
    default:
      return key;
  }
}

class _ContributorCard extends ConsumerWidget {
  const _ContributorCard({
    required this.ownerIsSuper,
    required this.ownerUid,
    required this.placeId,
  });

  final bool ownerIsSuper;
  final String ownerUid;
  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final ownerUser = ownerUid.isEmpty
        ? null
        : ref.watch(userByIdProvider(ownerUid)).valueOrNull;
    final ownerDisplayName = ownerUser?.displayName ?? '';
    final ownerPhotoUrl = ownerUser?.photoUrl;
    final currentUid = ref.watch(authStateProvider).valueOrNull?.uid;
    final isOwnPlace = currentUid != null && ownerUid == currentUid;

    final chatSettings = ownerUid.isNotEmpty
        ? ref.watch(ownerChatSettingsProvider(ownerUid)).valueOrNull ??
              const <String, dynamic>{}
        : const <String, dynamic>{};
    final chatEnabled = (chatSettings['enabled'] as bool?) ?? true;
    final awayMode = (chatSettings['awayMode'] as bool?) ?? false;

    Future<void> openChat() async {
      if (currentUid == null || ownerUid.isEmpty) return;
      if (awayMode) {
        LALToast.show(context, t.chatOwnerAway, kind: LALToastKind.warning);
        return;
      }
      final availability = await ref
          .read(chatRepositoryProvider)
          .checkOwnerAvailability(ownerUid);
      if (!context.mounted) return;
      if (availability == ChatAvailability.outsideSchedule) {
        LALToast.show(
          context,
          t.chatOwnerUnavailable,
          kind: LALToastKind.warning,
        );
        return;
      }
      String? threadId;
      try {
        threadId = await ref
            .read(chatNotifierProvider.notifier)
            .openWithUser(
              otherUid: ownerUid,
              otherDisplayName: ownerDisplayName.isNotEmpty
                  ? ownerDisplayName
                  : t.placeAnonymous,
              otherIsSuper: ownerIsSuper,
              placeContext: placeId,
            );
      } on OfflineException {
        if (context.mounted) {
          LALToast.showOffline(context);
        }
        return;
      }
      if (threadId != null && context.mounted) {
        context.push('/chat/$threadId');
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      child: Material(
        color: LALColors.surface,
        borderRadius: LALRadii.lgBorder,
        child: InkWell(
          borderRadius: LALRadii.lgBorder,
          onTap: ownerUid.isEmpty
              ? null
              : () => context.push('/users/$ownerUid'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: LALColors.c100,
                        backgroundImage:
                            (ownerPhotoUrl != null && ownerPhotoUrl.isNotEmpty)
                            ? CachedNetworkImageProvider(ownerPhotoUrl)
                            : null,
                        child:
                            (ownerPhotoUrl == null || ownerPhotoUrl.isEmpty)
                            ? const Icon(Icons.person, color: LALColors.c400)
                            : null,
                      ),
                      if (ownerIsSuper)
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: LALColors.accent,
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                BorderSide(color: Colors.white, width: 1.5),
                              ),
                            ),
                            child: const Icon(
                              Icons.workspace_premium_rounded,
                              color: Colors.white,
                              size: 8,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ownerDisplayName.isNotEmpty
                            ? ownerDisplayName
                            : t.placeAnonymous,
                        style: LALTypography.labelLarge,
                      ),
                      Text(
                        ownerIsSuper ? t.placeSuperLocal : t.placeContributor,
                        style: LALTypography.bodySmall.copyWith(
                          color: LALColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isOwnPlace)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: LALColors.surfaceAlt,
                      borderRadius: LALRadii.pillBorder,
                    ),
                    child: Text(
                      'This is your place',
                      style: LALTypography.labelSmall.copyWith(
                        color: LALColors.c600,
                      ),
                    ),
                  )
                else if (chatEnabled && ownerUid.isNotEmpty)
                  ElevatedButton(
                    onPressed: currentUid == null ? null : openChat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LALColors.accent,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: LALColors.c200,
                      disabledForegroundColor: LALColors.c500,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 0,
                    ),
                    child: Text(
                      t.placeChat,
                      style: LALTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceBottomBar extends StatelessWidget {
  const _PlaceBottomBar({
    required this.place,
    required this.isSaved,
    required this.isReminded,
    required this.isPremium,
    required this.onToggleSave,
    required this.onToggleReminder,
  });

  final Place place;
  final bool isSaved;
  final bool isReminded;
  final bool isPremium;
  final VoidCallback onToggleSave;
  final VoidCallback onToggleReminder;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: LALColors.surface,
        border: Border(top: BorderSide(color: LALColors.c100)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onToggleReminder,
              icon: Icon(
                isReminded
                    ? Icons.notifications_active
                    : Icons.notifications_outlined,
                size: 16,
                color: isReminded ? LALColors.accent : null,
              ),
              label: Text(isReminded ? t.reminderSet : t.placeRemindMe),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onToggleSave,
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                size: 16,
              ),
              label: Text(isSaved ? t.placeSaved : t.placeSave),
              style: isSaved
                  ? ElevatedButton.styleFrom(
                      backgroundColor: LALColors.accentSoft,
                      foregroundColor: LALColors.accentDark,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsSection extends ConsumerWidget {
  const _ReviewsSection({required this.placeId});

  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final reviewsAsync = ref.watch(placeReviewsProvider(placeId));
    final myReview = ref.watch(myPlaceReviewProvider(placeId)).valueOrNull;
    final user = ref.watch(authStateProvider).valueOrNull;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                t.placeReviews,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              if (user != null)
                TextButton.icon(
                  onPressed: () {
                    if (ref.read(isOnlineProvider).valueOrNull == false) {
                      LALToast.showOffline(context);
                      return;
                    }
                    ReviewComposerSheet.show(
                      context,
                      placeId: placeId,
                      existing: myReview,
                    );
                  },
                  icon: Icon(
                    myReview == null ? Icons.add : Icons.edit_outlined,
                    size: 16,
                  ),
                  label: Text(
                    myReview == null ? t.placeWriteReview : t.placeEditReview,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          reviewsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: SkeletonBox(width: double.infinity, height: 80),
            ),
            error: (_, __) =>
                Text(t.placeNoReviews, style: LALTypography.bodySmall),
            data: (reviews) => reviews.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: LALColors.surface,
                      borderRadius: LALRadii.lgBorder,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.placeNoReviews, style: LALTypography.labelLarge),
                        const SizedBox(height: 4),
                        Text(
                          t.placeNoReviewsBody,
                          style: LALTypography.bodySmall,
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      for (final r in reviews) ...[
                        _ReviewTile(
                          review: r,
                          isMine: user?.uid == r.authorUid,
                          onDelete: () async {
                            if (ref.read(isOnlineProvider).valueOrNull ==
                                false) {
                              LALToast.showOffline(context);
                              return;
                            }
                            try {
                              await ref
                                  .read(reviewNotifierProvider.notifier)
                                  .delete(placeId, r.id);
                            } on OfflineException {
                              if (context.mounted) {
                                LALToast.showOffline(context);
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({
    required this.review,
    required this.isMine,
    required this.onDelete,
  });

  final Review review;
  final bool isMine;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: LALColors.surface,
        borderRadius: LALRadii.lgBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: LALColors.c100,
                child: Text(
                  review.authorDisplayName.isNotEmpty
                      ? review.authorDisplayName[0].toUpperCase()
                      : '?',
                  style: LALTypography.labelMedium.copyWith(
                    color: LALColors.c600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorDisplayName.isNotEmpty
                          ? review.authorDisplayName
                          : t.placeAnonymous,
                      style: LALTypography.labelMedium,
                    ),
                    Row(
                      children: [
                        for (var i = 1; i <= 5; i++)
                          Icon(
                            i <= review.rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: LALColors.accent,
                            size: 14,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isMine)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: onDelete,
                  tooltip: t.placeDeleteReview,
                ),
            ],
          ),
          if (review.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(review.text, style: LALTypography.bodyMedium),
          ],
          if (review.photoUrls.isNotEmpty || review.videoUrls.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 84,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (var i = 0; i < review.photoUrls.length; i++)
                    _ReviewMediaThumb(
                      url: review.photoUrls[i],
                      isVideo: false,
                      onTap: () => _openReviewGallery(
                        context,
                        review.photoUrls,
                        review.videoUrls,
                        i,
                      ),
                    ),
                  for (var i = 0; i < review.videoUrls.length; i++)
                    _ReviewMediaThumb(
                      url: review.videoUrls[i],
                      isVideo: true,
                      onTap: () => _openReviewGallery(
                        context,
                        review.photoUrls,
                        review.videoUrls,
                        review.photoUrls.length + i,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

void _openReviewGallery(
  BuildContext context,
  List<String> photoUrls,
  List<String> videoUrls,
  int initialIndex,
) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => _ReviewGalleryScreen(
        photoUrls: photoUrls,
        videoUrls: videoUrls,
        initialIndex: initialIndex,
      ),
    ),
  );
}

class _ReviewGalleryScreen extends StatelessWidget {
  const _ReviewGalleryScreen({
    required this.photoUrls,
    required this.videoUrls,
    required this.initialIndex,
  });

  final List<String> photoUrls;
  final List<String> videoUrls;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: PlaceMediaGallery(
        photoUrls: photoUrls,
        videoUrls: videoUrls,
        height: MediaQuery.of(context).size.height,
        photoFit: BoxFit.contain,
        interactive: true,
      ),
    );
  }
}

class _ReviewMediaThumb extends StatelessWidget {
  const _ReviewMediaThumb({
    required this.url,
    required this.isVideo,
    required this.onTap,
  });

  final String url;
  final bool isVideo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: LALRadii.mdBorder,
          child: SizedBox(
            width: 84,
            height: 84,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (isVideo)
                  Container(
                    color: LALColors.c900,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  )
                else
                  CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const ColoredBox(color: LALColors.c100),
                    errorWidget: (_, __, ___) =>
                        const ColoredBox(color: LALColors.c100),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
