import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/domain/app_user.dart';

const _publicRoutes = {'/auth/sign-in', '/auth/sign-up'};

String? authGuardFn(AppUser? user, GoRouterState state) {
  final isAuthed = user != null;
  final loc = state.matchedLocation;
  final isPublic = _publicRoutes.contains(loc);

  if (!isAuthed && !isPublic) return '/auth/sign-in';
  if (isAuthed && isPublic) return '/discover';
  return null;
}

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._user);

  AppUser? _user;

  void update(AppUser? user) {
    _user = user;
    notifyListeners();
  }

  String? guard(BuildContext context, GoRouterState state) =>
      authGuardFn(_user, state);
}
