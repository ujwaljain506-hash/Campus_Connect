class StudyResource {
  final String id;
  final String title;
  final String description;
  final String fileUrl;
  final String subject;
  final String uploadedBy;
  final DateTime createdAt;

  StudyResource({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.subject,
    required this.uploadedBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'fileUrl': fileUrl,
      'subject': subject,
      'uploadedBy': uploadedBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory StudyResource.fromMap(Map<String, dynamic> map) {
    return StudyResource(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      subject: map['subject'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}