import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lose_it/features/post/providers/posts_provider.dart';
import 'package:lose_it/features/feed/widgets/feed_card.dart';
import 'package:lose_it/core/widgets/empty_state.dart';
import 'package:lose_it/core/widgets/shimmer_loading.dart';
import 'package:lose_it/core/providers/theme_provider.dart';
import 'package:lose_it/features/post/models/post_model.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  bool _isLoading = true;
  ItemStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    // Simulate initial loading
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postsProvider);
    final theme = Theme.of(context);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    final filteredPosts = _selectedFilter == null
        ? posts
        : posts.where((p) => p.status == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'loseIT',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              ref.watch(themeModeProvider) == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              size: 22,
            ),
            onPressed: () => themeNotifier.toggle(),
            tooltip: 'Toggle theme',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _isLoading
          ? const ShimmerLoading()
          : Column(
              children: [
                // Filter chips
                SizedBox(
                  height: 52,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: [
                      _FilterChip(
                        label: 'All',
                        isSelected: _selectedFilter == null,
                        onTap: () =>
                            setState(() => _selectedFilter = null),
                        theme: theme,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: '🔍 Lost',
                        isSelected: _selectedFilter == ItemStatus.lost,
                        onTap: () =>
                            setState(() => _selectedFilter = ItemStatus.lost),
                        theme: theme,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: '✅ Found',
                        isSelected: _selectedFilter == ItemStatus.found,
                        onTap: () =>
                            setState(() => _selectedFilter = ItemStatus.found),
                        theme: theme,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: '🚔 Police',
                        isSelected: _selectedFilter == ItemStatus.police,
                        onTap: () => setState(
                            () => _selectedFilter = ItemStatus.police),
                        theme: theme,
                      ),
                    ],
                  ),
                ),

                // Feed
                Expanded(
                  child: filteredPosts.isEmpty
                      ? const EmptyState(
                          icon: Icons.inbox_rounded,
                          title: 'No items yet',
                          subtitle:
                              'Be the first to report a lost or found item',
                        )
                      : RefreshIndicator(
                          color: theme.colorScheme.primary,
                          onRefresh: () async {
                            setState(() => _isLoading = true);
                            await Future.delayed(
                              const Duration(milliseconds: 800),
                            );
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          },
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Grid for wide screens
                              if (constraints.maxWidth > 800) {
                                return GridView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                      8, 4, 8, 100),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        constraints.maxWidth > 1200 ? 3 : 2,
                                    childAspectRatio: 0.72,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                  ),
                                  itemCount: filteredPosts.length,
                                  itemBuilder: (context, index) => FeedCard(
                                    post: filteredPosts[index],
                                    index: index,
                                  ),
                                );
                              }

                              // List for mobile
                              return ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                    0, 4, 0, 100),
                                itemCount: filteredPosts.length,
                                itemBuilder: (context, index) => FeedCard(
                                  post: filteredPosts[index],
                                  index: index,
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
