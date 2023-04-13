class MoneyTrends {
  final String title;
   final String urlToImage;
final String author;
  final String description;
  final String content;

  MoneyTrends(
      {required this.title,
      required this.urlToImage,
     required this.author,
      required this.description,
      required this.content
      }
      );

  factory MoneyTrends.fromJson(Map<String, dynamic> json) {
    final moneyTrends = json['moneyTrends'];

    return MoneyTrends(
        title: json['title']??'',
       urlToImage: json['urlToImage']??'',
       author: json['author']??' Anonymous',
      description: json['description,']??'',
       content: json['content)']??''
        );
  }
}
