import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tally/core/config/env_config.dart';

void main() {
  group('EnvConfig', () {
    setUp(() {
      // Clear environment before each test
      dotenv.testLoad(fileInput: '');
    });

    group('supabaseUrl', () {
      test('returns empty string when SUPABASE_URL is not set', () {
        dotenv.testLoad(fileInput: '');
        expect(EnvConfig.supabaseUrl, '');
      });

      test('returns correct value when SUPABASE_URL is set', () {
        dotenv.testLoad(fileInput: 'SUPABASE_URL=https://test.supabase.co');
        expect(EnvConfig.supabaseUrl, 'https://test.supabase.co');
      });
    });

    group('supabaseAnonKey', () {
      test('returns empty string when SUPABASE_ANON_KEY is not set', () {
        dotenv.testLoad(fileInput: '');
        expect(EnvConfig.supabaseAnonKey, '');
      });

      test('returns correct value when SUPABASE_ANON_KEY is set', () {
        dotenv.testLoad(fileInput: 'SUPABASE_ANON_KEY=test-anon-key-123');
        expect(EnvConfig.supabaseAnonKey, 'test-anon-key-123');
      });
    });

    group('validate', () {
      test('throws exception when SUPABASE_URL is not set', () {
        dotenv.testLoad(fileInput: 'SUPABASE_ANON_KEY=test-key');

        expect(
          () => EnvConfig.validate(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('SUPABASE_URL is not set in .env file'),
            ),
          ),
        );
      });

      test('throws exception when SUPABASE_ANON_KEY is not set', () {
        dotenv.testLoad(fileInput: 'SUPABASE_URL=https://test.supabase.co');

        expect(
          () => EnvConfig.validate(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('SUPABASE_ANON_KEY is not set in .env file'),
            ),
          ),
        );
      });

      test('throws exception when both variables are not set', () {
        dotenv.testLoad(fileInput: '');

        expect(() => EnvConfig.validate(), throwsA(isA<Exception>()));
      });

      test('does not throw when both variables are set', () {
        dotenv.testLoad(
          fileInput: '''
SUPABASE_URL=https://test.supabase.co
SUPABASE_ANON_KEY=test-anon-key-123
''',
        );

        expect(() => EnvConfig.validate(), returnsNormally);
      });

      test('throws exception when SUPABASE_URL is empty string', () {
        dotenv.testLoad(
          fileInput: '''
SUPABASE_URL=
SUPABASE_ANON_KEY=test-key
''',
        );

        expect(() => EnvConfig.validate(), throwsA(isA<Exception>()));
      });

      test('throws exception when SUPABASE_ANON_KEY is empty string', () {
        dotenv.testLoad(
          fileInput: '''
SUPABASE_URL=https://test.supabase.co
SUPABASE_ANON_KEY=
''',
        );

        expect(() => EnvConfig.validate(), throwsA(isA<Exception>()));
      });

      test('handles whitespace in values', () {
        dotenv.testLoad(
          fileInput: '''
SUPABASE_URL=  https://test.supabase.co  
SUPABASE_ANON_KEY=  test-key  
''',
        );

        // dotenv trims whitespace by default
        expect(EnvConfig.supabaseUrl, 'https://test.supabase.co');
        expect(EnvConfig.supabaseAnonKey, 'test-key');
        expect(() => EnvConfig.validate(), returnsNormally);
      });
    });
  });
}
