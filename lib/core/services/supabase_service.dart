import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tally/core/config/env_config.dart';
import 'package:tally/core/logging/app_logger.dart';

class SupabaseService {
  static SupabaseClient? _client;

  static Future<void> initialize() async {
    AppLogger.instance.info('Initializing Supabase');

    try {
      await Supabase.initialize(
        url: EnvConfig.supabaseUrl,
        anonKey: EnvConfig.supabaseAnonKey,
      );
      _client = Supabase.instance.client;
      AppLogger.instance.info('Supabase client initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.instance.error('Failed to initialize Supabase', e, stackTrace);
      rethrow;
    }
  }

  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'SupabaseService not initialized. Call SupabaseService.initialize() first.',
      );
    }
    return _client!;
  }

  static SupabaseClient get supabase => client;

  static bool get isAuthenticated => client.auth.currentUser != null;

  static User? get currentUser => client.auth.currentUser;

  static String? get currentUserId => client.auth.currentUser?.id;
}
