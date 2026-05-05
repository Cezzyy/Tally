import 'package:flutter_test/flutter_test.dart';
import 'package:tally/core/utils/validators.dart';

void main() {
  group('Validators', () {
    test('validateEmail returns error for empty email', () {
      expect(Validators.validateEmail(''), 'Email is required');
      expect(Validators.validateEmail(null), 'Email is required');
    });

    test('validateEmail returns error for invalid email', () {
      expect(Validators.validateEmail('invalid'), 'Enter a valid email');
      expect(Validators.validateEmail('test@'), 'Enter a valid email');
      expect(Validators.validateEmail('@test.com'), 'Enter a valid email');
    });

    test('validateEmail returns null for valid email', () {
      expect(Validators.validateEmail('test@example.com'), null);
      expect(Validators.validateEmail('user.name@domain.co.uk'), null);
    });

    test('validatePassword returns error for empty password', () {
      expect(Validators.validatePassword(''), 'Password is required');
      expect(Validators.validatePassword(null), 'Password is required');
    });

    test('validatePassword returns error for short password', () {
      expect(
        Validators.validatePassword('12345'),
        'Password must be at least 6 characters',
      );
    });

    test('validatePassword returns null for valid password', () {
      expect(Validators.validatePassword('123456'), null);
      expect(Validators.validatePassword('securePassword123'), null);
    });

    test('validateTitle returns error for empty title', () {
      expect(Validators.validateTitle(''), 'Title is required');
      expect(Validators.validateTitle('   '), 'Title is required');
      expect(Validators.validateTitle(null), 'Title is required');
    });

    test('validateTitle returns error for short title', () {
      expect(
        Validators.validateTitle('ab'),
        'Title must be at least 3 characters',
      );
    });

    test('validateTitle returns error for long title', () {
      final longTitle = 'a' * 201;
      expect(
        Validators.validateTitle(longTitle),
        'Title must be less than 200 characters',
      );
    });

    test('validateTitle returns null for valid title', () {
      expect(Validators.validateTitle('Valid Title'), null);
      expect(Validators.validateTitle('   Valid Title   '), null);
    });

    test('validateDescription returns error for long description', () {
      final longDesc = 'a' * 2001;
      expect(
        Validators.validateDescription(longDesc),
        'Description must be less than 2000 characters',
      );
    });

    test('validateDescription returns null for valid description', () {
      expect(Validators.validateDescription(''), null);
      expect(Validators.validateDescription(null), null);
      expect(Validators.validateDescription('Valid description'), null);
    });

    test('validateChecklistItem returns error for empty task', () {
      expect(Validators.validateChecklistItem(''), 'Task is required');
      expect(Validators.validateChecklistItem('   '), 'Task is required');
      expect(Validators.validateChecklistItem(null), 'Task is required');
    });

    test('validateChecklistItem returns error for long task', () {
      final longTask = 'a' * 501;
      expect(
        Validators.validateChecklistItem(longTask),
        'Task must be less than 500 characters',
      );
    });

    test('validateChecklistItem returns null for valid task', () {
      expect(Validators.validateChecklistItem('Valid task'), null);
    });
  });
}
