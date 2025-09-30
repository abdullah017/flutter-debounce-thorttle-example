import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/post_service.dart';

final postServiceProvider = Provider((ref) => PostService());

final searchProvider = FutureProvider.autoDispose.family<List<Post>, String>((
  ref,
  query,
) async {
  // query boşsa, istek yapma.
  if (query.isEmpty) {
    return [];
  }
  // API isteğini tetikle.
  return ref.watch(postServiceProvider).searchPosts(query);
});
