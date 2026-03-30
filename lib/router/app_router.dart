import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lose_it/features/auth/providers/auth_provider.dart';
import 'package:lose_it/features/auth/screens/login_screen.dart';
import 'package:lose_it/features/auth/screens/signup_screen.dart';
import 'package:lose_it/features/auth/screens/profile_setup_screen.dart';
import 'package:lose_it/features/feed/screens/feed_screen.dart';
import 'package:lose_it/features/post/screens/add_post_screen.dart';
import 'package:lose_it/features/post/screens/item_detail_screen.dart';
import 'package:lose_it/features/request/screens/requests_screen.dart';
import 'package:lose_it/features/profile/screens/profile_screen.dart';
import 'package:lose_it/core/widgets/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isProfileComplete = authState.isProfileComplete;
      final currentPath = state.matchedLocation;
      final isAuthRoute =
          currentPath == '/login' || currentPath == '/signup';
      final isSetupRoute = currentPath == '/profile-setup';

      // Not logged in → go to login
      if (!isLoggedIn && !isAuthRoute) return '/login';
      // Logged in but on auth routes → redirect
      if (isLoggedIn && isAuthRoute) {
        return isProfileComplete ? '/' : '/profile-setup';
      }
      // Logged in but profile not complete → force setup
      if (isLoggedIn && !isProfileComplete && !isSetupRoute) {
        return '/profile-setup';
      }
      // Profile complete but on setup route → go home
      if (isLoggedIn && isProfileComplete && isSetupRoute) {
        return '/';
      }
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignupScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));
            return SlideTransition(position: slideAnimation, child: child);
          },
        ),
      ),

      // Profile setup (initial)
      GoRoute(
        path: '/profile-setup',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfileSetupScreen(isEditing: false),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Profile edit (from profile page)
      GoRoute(
        path: '/edit-profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfileSetupScreen(isEditing: true),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slideAnimation, child: child),
            );
          },
        ),
      ),

      // Main shell with bottom nav
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: FeedScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/add',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AddPostScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/requests',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: RequestsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),

      // Detail route (outside shell — full screen)
      GoRoute(
        path: '/detail/:id',
        pageBuilder: (context, state) {
          final postId = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ItemDetailScreen(postId: postId),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final slideAnimation = Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ));
              return FadeTransition(
                opacity: animation,
                child:
                    SlideTransition(position: slideAnimation, child: child),
              );
            },
          );
        },
      ),
    ],
  );
});
