import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tally/app.dart';
import 'package:tally/core/config/env_config.dart';
import 'package:tally/core/logging/app_logger.dart';
import 'package:tally/core/services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppLogger.initialize();
  AppLogger.instance.info('Starting Tally application');

  await dotenv.load(fileName: '.env');
  AppLogger.instance.info('Environment variables loaded');

  EnvConfig.validate();
  AppLogger.instance.info('Environment configuration validated');

  await SupabaseService.initialize();
  AppLogger.instance.info('Supabase initialized');

  runApp(const ProviderScope(child: TallyApp()));
}
