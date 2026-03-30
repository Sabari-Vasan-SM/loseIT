import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lose_it/features/auth/providers/auth_provider.dart';
import 'package:lose_it/features/post/providers/posts_provider.dart';
import 'package:lose_it/core/providers/theme_provider.dart';
import 'package:lose_it/core/widgets/cached_image.dart';
import 'package:lose_it/core/widgets/empty_state.dart';
import 'package:lose_it/core/widgets/status_badge.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userPosts = ref.watch(userPostsProvider);
    final theme = Theme.of(context);
    final user = authState.user;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 22,
            ),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert_rounded),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined,
                        size: 20,
                        color: theme.colorScheme.onSurface),
                    const SizedBox(width: 12),
                    const Text('Settings'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  ref.read(authProvider.notifier).logout();
                },
                child: const Row(
                  children: [
                    Icon(Icons.logout_rounded,
                        size: 20, color: Color(0xFFFF6B6B)),
                    SizedBox(width: 12),
                    Text('Logout',
                        style: TextStyle(color: Color(0xFFFF6B6B))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Profile header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      backgroundImage: NetworkImage(user.avatarUrl),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  if (user.bio.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      user.bio,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatItem(
                        count: userPosts.length.toString(),
                        label: 'Posts',
                        theme: theme,
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        color: theme.dividerColor,
                      ),
                      _StatItem(
                        count: userPosts
                            .where((p) => p.status.name == 'lost')
                            .length
                            .toString(),
                        label: 'Lost',
                        theme: theme,
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        color: theme.dividerColor,
                      ),
                      _StatItem(
                        count: userPosts
                            .where((p) => p.status.name == 'found')
                            .length
                            .toString(),
                        label: 'Found',
                        theme: theme,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: theme.dividerColor),
                ],
              ),
            ),
          ),

          // Section title
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Text(
                'My Posts',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),

          // Posts grid
          if (userPosts.isEmpty)
            SliverFillRemaining(
              child: EmptyState(
                icon: Icons.photo_library_outlined,
                title: 'No Posts Yet',
                subtitle: 'Share lost or found items\nto help the community',
                actionLabel: 'Create Post',
                onAction: () => context.go('/add'),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = userPosts[index];
                    return GestureDetector(
                      onTap: () => context.push('/detail/${post.id}'),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedImage(
                            imageUrl: post.imageUrl,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // Gradient overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.6),
                                  ],
                                  stops: const [0.5, 1.0],
                                ),
                              ),
                            ),
                          ),
                          // Status badge
                          Positioned(
                            top: 6,
                            right: 6,
                            child: StatusBadge(status: post.status),
                          ),
                          // Title
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: Text(
                              post.title,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: userPosts.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  final ThemeData theme;

  const _StatItem({
    required this.count,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
