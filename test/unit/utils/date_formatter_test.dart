import 'package:flutter_test/flutter_test.dart';
import 'package:tally/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    group('formatDate', () {
      test('formats date correctly', () {
        final date = DateTime(2024, 1, 15);
        expect(DateFormatter.formatDate(date), 'Jan 15, 2024');
      });

      test('formats different months correctly', () {
        expect(DateFormatter.formatDate(DateTime(2024, 1, 1)), 'Jan 01, 2024');
        expect(DateFormatter.formatDate(DateTime(2024, 6, 15)), 'Jun 15, 2024');
        expect(
          DateFormatter.formatDate(DateTime(2024, 12, 31)),
          'Dec 31, 2024',
        );
      });

      test('handles single digit days with leading zero', () {
        final date = DateTime(2024, 3, 5);
        expect(DateFormatter.formatDate(date), 'Mar 05, 2024');
      });

      test('handles different years', () {
        expect(DateFormatter.formatDate(DateTime(2020, 5, 10)), 'May 10, 2020');
        expect(DateFormatter.formatDate(DateTime(2025, 8, 20)), 'Aug 20, 2025');
      });
    });

    group('formatDateTime', () {
      test('formats date and time correctly', () {
        final dateTime = DateTime(2024, 1, 15, 14, 30);
        expect(DateFormatter.formatDateTime(dateTime), 'Jan 15, 2024 14:30');
      });

      test('formats time with leading zeros', () {
        final dateTime = DateTime(2024, 3, 5, 9, 5);
        expect(DateFormatter.formatDateTime(dateTime), 'Mar 05, 2024 09:05');
      });

      test('handles midnight correctly', () {
        final dateTime = DateTime(2024, 6, 15, 0, 0);
        expect(DateFormatter.formatDateTime(dateTime), 'Jun 15, 2024 00:00');
      });

      test('handles end of day correctly', () {
        final dateTime = DateTime(2024, 6, 15, 23, 59);
        expect(DateFormatter.formatDateTime(dateTime), 'Jun 15, 2024 23:59');
      });
    });

    group('formatTime', () {
      test('formats time correctly', () {
        final time = DateTime(2024, 1, 1, 14, 30);
        expect(DateFormatter.formatTime(time), '14:30');
      });

      test('formats time with leading zeros', () {
        final time = DateTime(2024, 1, 1, 9, 5);
        expect(DateFormatter.formatTime(time), '09:05');
      });

      test('handles midnight', () {
        final time = DateTime(2024, 1, 1, 0, 0);
        expect(DateFormatter.formatTime(time), '00:00');
      });

      test('handles noon', () {
        final time = DateTime(2024, 1, 1, 12, 0);
        expect(DateFormatter.formatTime(time), '12:00');
      });

      test('handles end of day', () {
        final time = DateTime(2024, 1, 1, 23, 59);
        expect(DateFormatter.formatTime(time), '23:59');
      });
    });

    group('formatRelative', () {
      test('returns "Just now" for very recent times', () {
        final now = DateTime.now();
        final recent = now.subtract(const Duration(seconds: 30));
        expect(DateFormatter.formatRelative(recent), 'Just now');
      });

      test('returns minutes ago for times within an hour', () {
        final now = DateTime.now();
        final fiveMinutesAgo = now.subtract(const Duration(minutes: 5));
        final thirtyMinutesAgo = now.subtract(const Duration(minutes: 30));

        expect(DateFormatter.formatRelative(fiveMinutesAgo), '5m ago');
        expect(DateFormatter.formatRelative(thirtyMinutesAgo), '30m ago');
      });

      test('returns hours ago for times within a day', () {
        final now = DateTime.now();
        final oneHourAgo = now.subtract(const Duration(hours: 1));
        final twelveHoursAgo = now.subtract(const Duration(hours: 12));

        expect(DateFormatter.formatRelative(oneHourAgo), '1h ago');
        expect(DateFormatter.formatRelative(twelveHoursAgo), '12h ago');
      });

      test('returns days ago for times within a month', () {
        final now = DateTime.now();
        final oneDayAgo = now.subtract(const Duration(days: 1));
        final fifteenDaysAgo = now.subtract(const Duration(days: 15));

        expect(DateFormatter.formatRelative(oneDayAgo), '1d ago');
        expect(DateFormatter.formatRelative(fifteenDaysAgo), '15d ago');
      });

      test('returns months ago for times within a year', () {
        final now = DateTime.now();
        final oneMonthAgo = now.subtract(const Duration(days: 31));
        final sixMonthsAgo = now.subtract(const Duration(days: 180));

        expect(DateFormatter.formatRelative(oneMonthAgo), '1mo ago');
        expect(DateFormatter.formatRelative(sixMonthsAgo), '6mo ago');
      });

      test('returns years ago for times over a year', () {
        final now = DateTime.now();
        final oneYearAgo = now.subtract(const Duration(days: 366));
        final twoYearsAgo = now.subtract(const Duration(days: 730));

        expect(DateFormatter.formatRelative(oneYearAgo), '1y ago');
        expect(DateFormatter.formatRelative(twoYearsAgo), '2y ago');
      });

      test('handles edge case of exactly 1 minute', () {
        final now = DateTime.now();
        final oneMinuteAgo = now.subtract(const Duration(minutes: 1));
        expect(DateFormatter.formatRelative(oneMinuteAgo), '1m ago');
      });

      test('handles edge case of exactly 1 hour', () {
        final now = DateTime.now();
        final oneHourAgo = now.subtract(const Duration(hours: 1));
        expect(DateFormatter.formatRelative(oneHourAgo), '1h ago');
      });

      test('handles edge case of exactly 1 day', () {
        final now = DateTime.now();
        final oneDayAgo = now.subtract(const Duration(days: 1));
        expect(DateFormatter.formatRelative(oneDayAgo), '1d ago');
      });
    });
  });
}
