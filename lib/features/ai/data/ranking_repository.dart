import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class RankingRepository {
  RankingRepository(this._db, this._functions);

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;

  Stream<List<String>> rankedPlaceIds(String uid) =>
      _db.collection('rankings').doc(uid).snapshots().map((d) {
        final data = d.data();
        if (data == null) return const <String>[];
        final ids = (data['placeIds'] as List?) ?? const [];
        return ids.cast<String>();
      });

  Future<void> refresh() async {
    try {
      final callable = _functions.httpsCallable('rankPlacesForUser');
      await callable.call(<String, dynamic>{});
    } catch (_) {
      // Silent fallback to heuristic feed; surfaced via empty stream.
    }
  }
}
