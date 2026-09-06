class Question {
  final String id;
  final String title;
  final String body;
  final String askedBy;
  final DateTime createdAt;

  Question({
    required this.id,
    required this.title,
    required this.body,
    required this.askedBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'askedBy': askedBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      askedBy: map['askedBy'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}