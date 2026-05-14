import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:like_a_local/features/auth/domain/auth_providers.dart';
import 'package:like_a_local/features/place/data/place_repository.dart';
import 'package:like_a_local/features/place/domain/place_providers.dart';
import 'package:like_a_local/features/place/presentation/place_screen.dart';
import 'package:like_a_local/features/reminders/data/reminder_repository.dart';
import 'package:like_a_local/features/reminders/domain/reminder_providers.dart';
import 'package:like_a_local/features/reviews/data/review_repository.dart';
import 'package:like_a_local/features/reviews/domain/review_providers.dart';
import 'package:like_a_local/features/saved/data/saved_repository.dart';
import 'package:like_a_local/features/saved/domain/saved_providers.dart';
import 'package:like_a_local/l10n/app_localizations.dart';

void main() {
  testWidgets('PlaceScreen builds without negative margin assertion', (
    WidgetTester tester,
  ) async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('places').doc('place-123').set({
      'title': 'Tasca do Chico',
      'description': 'Classic fado bar in Bairro Alto.',
      'category': 'Bars',
      'moods': <String>[],
      'city': 'Lisbon',
      'neighborhood': 'Bairro Alto',
      'address': 'R. do Diario de Noticias 39',
      'lat': 38.7138,
      'lng': -9.1439,
      'tips': <Map<String, Object?>>[],
      'mediaUrls': <String>[],
      'ownerUid': 'owner-123',
      'ownerIsSuper': false,
      'ratingAvg': 4.7,
      'ratingCount': 12,
      'saveCount': 3,
      'featured': false,
      'hidden': false,
      'createdAt': DateTime(2026, 1, 1).toIso8601String(),
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
          currentUserDocProvider.overrideWith((ref) => Stream.value(null)),
          placeRepositoryProvider.overrideWith(
            (ref) => PlaceRepository(firestore),
          ),
          savedRepositoryProvider.overrideWith(
            (ref) => SavedRepository(firestore),
          ),
          reminderRepositoryProvider.overrideWith(
            (ref) => ReminderRepository(firestore),
          ),
          reviewRepositoryProvider.overrideWith(
            (ref) => ReviewRepository(firestore),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en'), Locale('de')],
          home: PlaceScreen(placeId: 'place-123'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(PlaceScreen), findsOneWidget);
    expect(find.text('Tasca do Chico'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
