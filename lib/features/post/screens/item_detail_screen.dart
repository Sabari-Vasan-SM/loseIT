import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:lose_it/features/post/providers/posts_provider.dart';
import 'package:lose_it/features/request/models/request_model.dart';
import 'package:lose_it/features/request/providers/requests_provider.dart';
import 'package:lose_it/core/widgets/status_badge.dart';
import 'package:lose_it/core/widgets/cached_image.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final String postId;

  const ItemDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _requestItem() {
    final post = ref.read(postByIdProvider(widget.postId));
    if (post == null) return;

    final newRequest = RequestModel(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      postId: post.id,
      postTitle: post.title,
      postImage: post.imageUrl,
      requesterId: 'user_1',
      requesterName: 'Alex Johnson',
      requesterAvatar: 'https://i.pravatar.cc/300?img=12',
      status: RequestStatus.pending,
      createdAt: DateTime.now(),
    );

    ref.read(requestsProvider.notifier).addRequest(newRequest);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ Request sent successfully!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF00CDAC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _contactOwner() {
    final post = ref.read(postByIdProvider(widget.postId));
    if (post == null) return;

    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage(post.userAvatar),
            ),
            const SizedBox(height: 12),
            Text(
              post.userName,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    post.contactInfo,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.message_outlined, size: 20),
                label: const Text('Send Message'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = ref.watch(postByIdProvider(widget.postId));
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 700;

    if (post == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Post not found')),
      );
    }

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            // Hero image app bar
            SliverAppBar(
              expandedHeight: isWide ? 400 : 300,
              pinned: true,
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.4),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 18, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: CachedImage(
                  imageUrl: post.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status + Time
                        Row(
                          children: [
                            StatusBadge(status: post.status, isLarge: true),
                            const Spacer(),
                            Icon(
                              Icons.access_time_rounded,
                              size: 16,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timeago.format(post.createdAt),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          post.title,
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // User info
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundImage:
                                    NetworkImage(post.userAvatar),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.userName,
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Posted by',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: _contactOwner,
                                icon: Icon(
                                  Icons.message_outlined,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Description
                        Text(
                          'Description',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.description,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            height: 1.6,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Location row
                        _InfoRow(
                          icon: Icons.location_on_outlined,
                          label: 'Location',
                          value: post.location,
                          theme: theme,
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: Icons.phone_outlined,
                          label: 'Contact',
                          value: post.contactInfo,
                          theme: theme,
                        ),
                        const SizedBox(height: 36),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: ElevatedButton.icon(
                                  onPressed: _requestItem,
                                  icon: const Icon(Icons.front_hand_rounded,
                                      size: 20),
                                  label: Text(
                                    'Request Item',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 52,
                              child: OutlinedButton.icon(
                                onPressed: _contactOwner,
                                icon: const Icon(Icons.call_outlined,
                                    size: 20),
                                label: Text(
                                  'Contact',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
