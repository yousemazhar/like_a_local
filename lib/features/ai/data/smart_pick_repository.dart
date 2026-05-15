import 'package:cloud_functions/cloud_functions.dart';

class SmartPickResult {
  const SmartPickResult({required this.placeId, required this.reason});

  final String placeId;
  final String reason;
}

class SmartPickUnavailableException implements Exception {
  const SmartPickUnavailableException(this.message);
  final String message;

  @override
  String toString() => 'SmartPickUnavailableException: $message';
}

class SmartPickRepository {
  SmartPickRepository(this._functions);

  final FirebaseFunctions _functions;

  Future<SmartPickResult> fetchTopPick() async {
    try {
      final callable = _functions.httpsCallable('geminiTopPick');
      final res = await callable.call(<String, dynamic>{});
      final data = Map<String, dynamic>.from(res.data as Map);
      final placeId = data['placeId'] as String?;
      final reason = data['reason'] as String?;
      if (placeId == null || reason == null) {
        throw const SmartPickUnavailableException('Malformed response');
      }
      return SmartPickResult(placeId: placeId, reason: reason);
    } on FirebaseFunctionsException catch (e) {
      throw SmartPickUnavailableException(e.message ?? e.code);
    } catch (e) {
      throw SmartPickUnavailableException(e.toString());
    }
  }
}
