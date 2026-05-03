import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}

@riverpod
Stream<AuthState> authStateChanges(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
}

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<User?> build() {
    final repository = ref.watch(authRepositoryProvider);
    return repository.currentUser;
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final response = await repository.signUp(
        email: email,
        password: password,
      );
      return response.user;
    });

    if (ref.mounted) {
      state = result;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final response = await repository.signIn(
        email: email,
        password: password,
      );
      return response.user;
    });

    if (ref.mounted) {
      state = result;
    }
  }

  Future<void> signOut() async {
    if (!ref.mounted) return;

    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.signOut();
      return null;
    });

    if (ref.mounted) {
      state = result;
    }
  }
}
