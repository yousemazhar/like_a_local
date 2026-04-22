import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/lal_bottom_nav.dart';
import '../features/ai/presentation/ai_assistant_screen.dart';
import '../features/add_place/presentation/add_place_screen.dart';
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/auth/presentation/sign_up_screen.dart';
import '../features/chat/presentation/chat_thread_screen.dart';
import '../features/chat/presentation/inbox_screen.dart';
import '../features/discover/presentation/discover_screen.dart';
import '../features/map/presentation/map_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/place/presentation/place_screen.dart';
import '../features/premium/presentation/premium_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/saved/presentation/saved_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import 'guards.dart';

final appRouter = GoRouter(
  initialLocation: '/discover',
  redirect: authGuard,
  routes: [
    // Auth (public)
    GoRoute(
      path: '/auth/sign-in',
      builder: (_, __) => const SignInScreen(),
    ),
    GoRoute(
      path: '/auth/sign-up',
      builder: (_, __) => const SignUpScreen(),
    ),

    // Full-screen routes (no bottom nav)
    GoRoute(
      path: '/place/:id',
      builder: (_, state) =>
          PlaceScreen(placeId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/map',
      builder: (_, __) => const MapScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (_, __) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (_, __) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/chat/:threadId',
      builder: (_, state) =>
          ChatThreadScreen(threadId: state.pathParameters['threadId']!),
    ),

    // Fullscreen modals (slide up)
    GoRoute(
      path: '/add-place',
      pageBuilder: (_, __) => const MaterialPage(
        fullscreenDialog: true,
        child: AddPlaceScreen(),
      ),
    ),
    GoRoute(
      path: '/ai',
      pageBuilder: (_, __) => const MaterialPage(
        fullscreenDialog: true,
        child: AiAssistantScreen(),
      ),
    ),
    GoRoute(
      path: '/premium',
      pageBuilder: (_, __) => const MaterialPage(
        fullscreenDialog: true,
        child: PremiumScreen(),
      ),
    ),

    // Bottom-nav shell (5 tabs)
    StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => LALScaffold(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/discover',
              builder: (_, __) => const DiscoverScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (_, __) => const SearchScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/saved',
              builder: (_, __) => const SavedScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inbox',
              builder: (_, __) => const InboxScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
