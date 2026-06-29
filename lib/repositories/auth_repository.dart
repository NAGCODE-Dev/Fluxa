import 'package:financas/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  AuthRepository([SupabaseClient? client]) : _clientOverride = client;

  final SupabaseClient? _clientOverride;

  SupabaseClient? get _client {
    if (_clientOverride != null) {
      return _clientOverride;
    }

    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  Session? getCurrentSession() {
    return _client?.auth.currentSession;
  }

  Stream<AuthState> authStateChanges() {
    return _client?.auth.onAuthStateChange ?? const Stream.empty();
  }

  Future<void> signInWithGoogle() {
    final client = _requireClient();
    return client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: SupabaseConfig.redirectTo,
    );
  }

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) {
    final client = _requireClient();
    return client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) {
    final client = _requireClient();
    return client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: SupabaseConfig.redirectTo,
    );
  }

  Future<void> signOut() {
    final client = _requireClient();
    return client.auth.signOut();
  }

  SupabaseClient _requireClient() {
    final client = _client;
    if (client == null) {
      throw const AuthException(
        'Sincronização indisponível neste ambiente.',
      );
    }

    return client;
  }
}
