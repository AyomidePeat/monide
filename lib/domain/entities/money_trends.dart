class MoneyTrends {
  final String title;
  final String description;
  final String url;
  final String imageUrl;

  MoneyTrends({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'url': url,
        'image': imageUrl,
      };

  factory MoneyTrends.fromJson(Map<String, dynamic> json) {
    return MoneyTrends(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      url: json['url'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
    );
  }
}