class Post {
  final String id;
  final String userId;
  final String username;
  final String caption;
  final String? imageUrl;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> comments;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.caption,
    this.imageUrl,
    required this.createdAt,
    this.likes = const [],
    this.comments = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'caption': caption,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'comments': comments,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      caption: map['caption'] ?? '',
      imageUrl: map['imageUrl'],
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      likes: List<String>.from(map['likes'] ?? []),
      comments: List<String>.from(map['comments'] ?? []),
    );
  }
}