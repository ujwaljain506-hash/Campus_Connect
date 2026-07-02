class Notice {
  final String id;
  final String title;
  final String body;
  final String department;
  final DateTime createdAt;

  Notice({
    required this.id,
    required this.title,
    required this.body,
    required this.department,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'department': department,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Notice.fromMap(Map<String, dynamic> map) {
    return Notice(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      department: map['department'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}