import 'dart:convert';
import 'package:http/http.dart' as http;

// Basit bir Post modeli
class Post {
  final int id;
  final String title;
  Post({required this.id, required this.title});
  factory Post.fromJson(Map<String, dynamic> json) =>
      Post(id: json['id'], title: json['title']);
}

class PostService {
  Future<List<Post>> searchPosts(String query) async {
    // Gerçek bir API'de query sunucuya gönderilir, biz burada client-side filtreleme yapıyoruz.
    print('API CALL: Searching for "$query"');
    if (query.isEmpty) return [];

    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) => Post.fromJson(json))
          .where(
            (post) => post.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
