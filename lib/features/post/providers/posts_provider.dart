import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lose_it/features/post/models/post_model.dart';
import 'package:lose_it/core/constants/mock_data.dart';

final postsProvider =
    StateNotifierProvider<PostsNotifier, List<PostModel>>((ref) {
  return PostsNotifier();
});

// Provider for getting only the current user's posts
final userPostsProvider = Provider<List<PostModel>>((ref) {
  final posts = ref.watch(postsProvider);
  return posts.where((p) => p.userId == 'user_1').toList();
});

// Provider for a single post by ID
final postByIdProvider = Provider.family<PostModel?, String>((ref, id) {
  final posts = ref.watch(postsProvider);
  try {
    return posts.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
});

class PostsNotifier extends StateNotifier<List<PostModel>> {
  PostsNotifier() : super(MockData.posts);

  void addPost(PostModel post) {
    state = [post, ...state];
  }

  void removePost(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  void updatePost(PostModel updated) {
    state = state.map((p) => p.id == updated.id ? updated : p).toList();
  }
}
