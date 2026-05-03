import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/services/supabase_service.dart';

class AuthRepository {
  final SupabaseClient _client = SupabaseService.client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.instance.info('Attempting sign up for: $email');
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      AppLogger.instance.info('Sign up successful for: $email');
      return response;
    } catch (e, stackTrace) {
      AppLogger.instance.error('Sign up failed', e, stackTrace);
      rethrow;
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.instance.info('Attempting sign in for: $email');
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      AppLogger.instance.info('Sign in successful for: $email');
      return response;
    } catch (e, stackTrace) {
      AppLogger.instance.error('Sign in failed', e, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      AppLogger.instance.info('Attempting sign out');
      await _client.auth.signOut();
      AppLogger.instance.info('Sign out successful');
    } catch (e, stackTrace) {
      AppLogger.instance.error('Sign out failed', e, stackTrace);
      rethrow;
    }
  }

  User? get currentUser => _client.auth.currentUser;

  bool get isAuthenticated => currentUser != null;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
