import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

class AuthUser {
  final int id;
  AuthUser(this.id);
}

class AuthNotifier extends StateNotifier<AuthUser?> {
  final Ref ref;
  AuthNotifier(this.ref) : super(null);

  /// Convertit une valeur dynamique en int (gère String ou int)
  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw FormatException('Impossible de convertir $value en int');
  }

  Future<bool> register(String email, String password) async {
    final api = ref.read(apiProvider);
    try {
      final result = await api.register(email, password);
      if (result['success'] == true) {
        final accountId = _toInt(result['account_id']);
        state = AuthUser(accountId);
        return true;
      }
    } catch (e) {
      print('Erreur inscription: $e');
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    final api = ref.read(apiProvider);
    try {
      final result = await api.login(email, password);
      if (result['success'] == true) {
        final accountId = _toInt(result['account_id']);
        state = AuthUser(accountId);
        return true;
      }
    } catch (e) {
      print('Erreur connexion: $e');
    }
    return false;
  }

  Future<void> logout() async {
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthUser?>((ref) {
  return AuthNotifier(ref);
});
