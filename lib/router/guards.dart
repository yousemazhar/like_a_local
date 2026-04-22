import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// TODO: After Firebase is configured, replace this with a real auth check:
//
//   final user = ref.read(authStateProvider).valueOrNull;
//   final isAuthed = user != null;
//   final isAuthRoute = _publicRoutes.contains(state.matchedLocation);
//   if (!isAuthed && !isAuthRoute) return '/auth/sign-in';
//   if (isAuthed && isAuthRoute) return '/discover';
//   return null;
//
// Wire the router to refresh on auth state changes via GoRouter(refreshListenable: ...).

String? authGuard(BuildContext context, GoRouterState state) {
  return null;
}
