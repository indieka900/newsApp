class ArticleModel {
  String? auther;
  String title;
  String description;
  String url;
  String urlToImage;
  String? content;
  String publishAT;

  ArticleModel({
    required this.auther,
    required this.title,
    required this.content,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishAT,
  });
}
