import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AppLogger {
  static AppLogger? _instance;
  static Talker? _talker;

  AppLogger._();

  static AppLogger get instance {
    _instance ??= AppLogger._();
    return _instance!;
  }

  static Talker get talker {
    if (_talker == null) {
      throw Exception(
        'AppLogger not initialized. Call AppLogger.initialize() first.',
      );
    }
    return _talker!;
  }

  static Future<void> initialize() async {
    _talker = TalkerFlutter.init(
      settings: TalkerSettings(
        enabled: true,
        useConsoleLogs: kDebugMode,
        useHistory: true,
        maxHistoryItems: 1000,
      ),
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(
          enableColors: kDebugMode,
          level: kDebugMode ? LogLevel.verbose : LogLevel.warning,
        ),
      ),
    );

    if (kDebugMode) {
      _talker!.info('AppLogger initialized');
    }
  }

  void debug(String message, [Object? exception, StackTrace? stackTrace]) {
    talker.debug(message, exception, stackTrace);
  }

  void info(String message, [Object? exception, StackTrace? stackTrace]) {
    talker.info(message, exception, stackTrace);
  }

  void warning(String message, [Object? exception, StackTrace? stackTrace]) {
    talker.warning(message, exception, stackTrace);
  }

  void error(String message, [Object? exception, StackTrace? stackTrace]) {
    talker.error(message, exception, stackTrace);
  }

  void critical(String message, [Object? exception, StackTrace? stackTrace]) {
    talker.critical(message, exception, stackTrace);
  }

  void log(String message) {
    talker.log(message);
  }

  void logException(
    Object exception, [
    StackTrace? stackTrace,
    String? message,
  ]) {
    talker.handle(exception, stackTrace, message);
  }

  void logSupabaseOperation(String operation, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      talker.info('Supabase: $operation', data);
    }
  }

  void logNavigation(String route, {Map<String, dynamic>? params}) {
    if (kDebugMode) {
      talker.info('Navigation: $route', params);
    }
  }

  void logStateChange(String provider, dynamic state) {
    if (kDebugMode) {
      talker.debug('State: $provider', state);
    }
  }
}
