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
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Simulate initial loading
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postsProvider);
    final theme = Theme.of(context);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    // Apply filters
    var filteredPosts = _selectedFilter == null
        ? posts
        : posts.where((p) => p.status == _selectedFilter).toList();

    // Apply search
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredPosts = filteredPosts
          .where((p) =>
              p.title.toLowerCase().contains(query) ||
              p.location.toLowerCase().contains(query) ||
              p.description.toLowerCase().contains(query))
          .toList();
    }

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
                // Search bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) =>
                        setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search items, locations...',
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor:
                          theme.colorScheme.primary.withValues(alpha: 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline.withValues(alpha: 0.15),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline.withValues(alpha: 0.15),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),

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
                      ? EmptyState(
                          icon: _searchQuery.isNotEmpty
                              ? Icons.search_off_rounded
                              : Icons.inbox_rounded,
                          title: _searchQuery.isNotEmpty
                              ? 'No results found'
                              : 'No items yet',
                          subtitle: _searchQuery.isNotEmpty
                              ? 'Try a different search term'
                              : 'Be the first to report a lost or found item',
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
