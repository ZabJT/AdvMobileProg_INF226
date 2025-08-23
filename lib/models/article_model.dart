class Article {
  final int userId;
  final int id;
  final String title;
  final String body;
  final String imageUrl;

  Article({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    required this.imageUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
