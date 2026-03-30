import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lose_it/features/auth/models/user_model.dart';

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

  bool get isProfileComplete => user?.isProfileComplete ?? false;

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
    await Future.delayed(const Duration(milliseconds: 1200));
    state = AuthState(
      isAuthenticated: true,
      user: UserModel(
        id: 'user_1',
        name: '',
        email: email,
        avatarUrl: 'https://i.pravatar.cc/300?img=12',
        isProfileComplete: false,
      ),
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
        isProfileComplete: false,
      ),
      isLoading: false,
    );
  }

  void completeProfile({
    required String name,
    required String email,
    required String contactNumber,
    required String bio,
    required String avatarUrl,
  }) {
    if (state.user == null) return;
    state = state.copyWith(
      user: state.user!.copyWith(
        name: name,
        email: email,
        contactNumber: contactNumber,
        bio: bio,
        avatarUrl: avatarUrl,
        isProfileComplete: true,
      ),
    );
  }

  void updateProfile({
    String? name,
    String? email,
    String? contactNumber,
    String? bio,
    String? avatarUrl,
  }) {
    if (state.user == null) return;
    state = state.copyWith(
      user: state.user!.copyWith(
        name: name,
        email: email,
        contactNumber: contactNumber,
        bio: bio,
        avatarUrl: avatarUrl,
      ),
    );
  }

  void logout() {
    state = const AuthState();
  }
}
