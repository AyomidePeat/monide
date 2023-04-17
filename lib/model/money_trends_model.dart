class MoneyTrends {
  final String title;
  final String image;
  final String source;
  final String description;
  // Update to Future<String>
  final String url;

  MoneyTrends({
    required this.title,
    required this.image,
    required this.source,
    required this.description,
    required this.url,
  });

  factory MoneyTrends.fromJson(Map<String, dynamic> json) {
    return MoneyTrends(
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      source: json['source']['name'] ?? 'Anonymous',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
