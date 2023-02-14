import 'dart:convert';

import '../model/article_model.dart';
import 'package:http/http.dart' as http;


final today = DateTime.now();
final yesterday = today.subtract(const Duration(days: 2),);
final yesterdayDate = yesterday.toLocal().toString().split(' ')[0];


class News {
  List<ArticleModel> news = [];
  Future<void> getNews() async {
    var uri = Uri.https(
      'newsapi.org',
      '/v2/top-headlines',
      {
        'country': 'us',
        //'sources':'bbc-news',
        'category': 'general',
        'apiKey': '2e97f341c1424ed89bef5209c1bf4544',
      },
    );

    var response = await http.get(uri);
    var json = jsonDecode(response.body);
    if (json['status'] == 'ok') {
      json['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel articlemodel = ArticleModel(
            title: element['title'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            auther: element['author'],
            content: element['content'],
            publishAT: element['publishedAt'],
          );
          news.add(articlemodel);
        }
      });
    }
  }
}


class NewsCategory {
  List<ArticleModel> news = [];
  

  Future<void> getNews(String category) async {
    var uri = Uri.https(
      'newsapi.org',
      '/v2/everything',
      {
        'q': category,
        'from': yesterdayDate,
        'sortBy': 'popularity',
        'apiKey': '2e97f341c1424ed89bef5209c1bf4544',
      },
    );

    var response = await http.get(uri);
    var json = jsonDecode(response.body);
    if (json['status'] == 'ok') {
      json['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel articlemodel = ArticleModel(
            title: element['title'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            auther: element['author'],
            content: element['content'],
            publishAT: element['publishedAt'],
          );
          news.add(articlemodel);
        }
      });
    }
  }
}
