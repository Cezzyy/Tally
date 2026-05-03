import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env_config.dart';

/// Supabase service singleton for managing database connections
class SupabaseService {
  static SupabaseClient? _client;

  /// Initialize Supabase with environment configuration
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  /// Get the Supabase client instance
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'SupabaseService not initialized. Call SupabaseService.initialize() first.',
      );
    }
    return _client!;
  }

  /// Shorthand for accessing the Supabase client
  static SupabaseClient get supabase => client;

  /// Check if user is authenticated
  static bool get isAuthenticated => client.auth.currentUser != null;

  /// Get current user
  static User? get currentUser => client.auth.currentUser;

  /// Get current user ID
  static String? get currentUserId => client.auth.currentUser?.id;
}
