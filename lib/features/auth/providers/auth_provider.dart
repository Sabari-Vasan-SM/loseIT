import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lose_it/features/auth/models/user_model.dart';
import 'package:lose_it/core/constants/mock_data.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final bool isLoading;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserModel? user,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));
    state = AuthState(
      isAuthenticated: true,
      user: MockData.currentUser,
      isLoading: false,
    );
  }

  Future<void> signup(String name, String email, String password) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 1200));
    state = AuthState(
      isAuthenticated: true,
      user: UserModel(
        id: 'user_1',
        name: name,
        email: email,
        avatarUrl: 'https://i.pravatar.cc/300?img=12',
        bio: 'New to LoseIT!',
      ),
      isLoading: false,
    );
  }

  void logout() {
    state = const AuthState();
  }
}
