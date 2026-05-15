import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../auth/domain/app_user.dart';
import '../domain/super_user_providers.dart';

class SuperUsersScreen extends ConsumerWidget {
  const SuperUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final usersAsync = ref.watch(superUsersProvider);

    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: Text(t.superUsersTitle),
        backgroundColor: LALColors.surface,
        actions: [
          IconButton(
            tooltip: t.superUsersRecalculateScores,
            icon: const Icon(Icons.bug_report_outlined),
            onPressed: () async {
              try {
                final count = await ref
                    .read(superUserRepositoryProvider)
                    .recalculateAllScores();
                ref.invalidate(superUsersProvider);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(t.superUsersRecalculatedScores(count)),
                  ),
                );
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error.toString())));
              }
            },
          ),
        ],
      ),
      body: usersAsync.when(
        loading: () => SkeletonList(
          itemCount: 6,
          padding: const EdgeInsets.all(LALSpacing.xl),
          itemBuilder: (_, __) =>
              const SkeletonCard(width: double.infinity, height: 88),
        ),
        error: (error, stackTrace) => ErrorView(
          message: t.superUsersError,
          onRetry: () => ref.invalidate(superUsersProvider),
        ),
        data: (users) => users.isEmpty
            ? _EmptySuperUsers()
            : ListView.separated(
                padding: const EdgeInsets.all(LALSpacing.xl),
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _SuperUserTile(
                  rank: index + 1,
                  user: users[index],
                  onTap: () => context.push('/users/${users[index].uid}'),
                ),
              ),
      ),
    );
  }
}

class _EmptySuperUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.workspace_premium_outlined,
              color: LALColors.c300,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(t.superUsersEmpty, style: LALTypography.labelLarge),
            const SizedBox(height: 6),
            Text(
              t.superUsersEmptyBody,
              textAlign: TextAlign.center,
              style: LALTypography.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _SuperUserTile extends StatelessWidget {
  const _SuperUserTile({
    required this.rank,
    required this.user,
    required this.onTap,
  });

  final int rank;
  final AppUser user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final stats = user.superUserStats;
    final photo = user.photoUrl;
    final name = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!
        : (user.email.isNotEmpty
              ? user.email.split('@').first
              : t.placeAnonymous);

    return Material(
      color: LALColors.surface,
      borderRadius: LALRadii.lgBorder,
      child: InkWell(
        borderRadius: LALRadii.lgBorder,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              SizedBox(
                width: 34,
                child: Text(
                  '#$rank',
                  style: LALTypography.labelLarge.copyWith(
                    color: LALColors.accent,
                  ),
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: LALColors.c100,
                    backgroundImage: photo?.isNotEmpty == true
                        ? CachedNetworkImageProvider(photo!)
                        : null,
                    child: photo?.isNotEmpty == true
                        ? null
                        : const Icon(Icons.person, color: LALColors.c400),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: LALColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: Colors.white,
                        size: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: LALTypography.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.superUsersStatsNoChats(
                        stats.placesCount,
                        stats.reviewsCount,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: LALTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    user.superUserScore.toStringAsFixed(0),
                    style: LALTypography.headlineMedium.copyWith(fontSize: 22),
                  ),
                  Text(t.superUsersScore, style: LALTypography.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
