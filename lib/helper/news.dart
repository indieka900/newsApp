import 'dart:convert';

import '../model/article_model.dart';
import 'package:http/http.dart' as http;

final today = DateTime.now();
final yesterday = today.subtract(
  const Duration(days: 2),
);
final yesterdayDate = yesterday.toLocal().toString().split(' ')[0];

class News {
  List<ArticleModel> news = [];
  Future<void> getNews(int page) async {
    var uri = Uri.https(
      'newsapi.org',
      '/v2/top-headlines',
      {
        "language": "en",
        //'from': yesterdayDate,
        'sortBy': 'popularity',
        'page': page.toString(),
        'apiKey': 'b0c9a7feca8743bbaf4fe054f22359d1',
      },
    );

    var response = await http.get(uri);
    var json = jsonDecode(response.body);

    if (json['status'] == 'error' || json['code'] == 'apiKeyMissing') {
      throw Exception(json['message']);
    }
    if (json['status'] == 'ok') {
      json['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel articlemodel = ArticleModel(
            title: element['title'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            auther: element['source']['name'],
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
  Future<void> getNews(String category, int page) async {
    var uri = Uri.https(
      'newsapi.org',
      '/v2/everything',
      {
        'q': category,
        //'from': yesterdayDate,
        'sortBy': 'publishedAt',
        'page': page.toString(),
        "language": "en",
        'apiKey': '2e97f341c1424ed89bef5209c1bf4544',
      },
    );

    var response = await http.get(uri);
    var json = jsonDecode(response.body);

    if (json['status'] == 'error' || json['code'] == 'apiKeyMissing') {
      throw Exception(json['message']);
    }

    if (json['status'] == 'ok') {
      json['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel articlemodel = ArticleModel(
            title: element['title'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            auther: element['source']['name'],
            content: element['content'],
            publishAT: element['publishedAt'],
          );
          news.add(articlemodel);
        }
      });
    }
  }
}

class NewsSource {
  List<ArticleModel> news = [];
  Future<void> getNews(String source, int page) async {
    var uri = Uri.https(
      'newsapi.org',
      '/v2/everything',
      {
        'sources': source,
        "language": "en",
        'from': yesterdayDate,
        'sortBy': 'publishedAt',
        'page': page.toString(),
        'apiKey': '2e97f341c1424ed89bef5209c1bf4544',
      },
    );

    var response = await http.get(uri);
    var json = jsonDecode(response.body);
    if (json['status'] == 'error' || json['code'] == 'apiKeyMissing') {
      throw Exception(json['message']);
    }
    if (json['status'] == 'ok') {
      json['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel articlemodel = ArticleModel(
            title: element['title'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            auther: element['source']['name'],
            content: element['content'],
            publishAT: element['publishedAt'],
          );
          news.add(articlemodel);
        }
      });
    }
  }
}

class SearchNews {
  List<ArticleModel> news = [];
  Future<void> getNews(String sNews, int page) async {
    var uri = Uri.https(
      'newsapi.org',
      '/v2/everything',
      {
        'q': sNews,
        'sortBy': 'publishedAt',
        "language": "en",
        'page': page.toString(),
        'apiKey': 'b0c9a7feca8743bbaf4fe054f22359d1',
      },
    );

    var response = await http.get(uri);
    var json = jsonDecode(response.body);

    if (json['status'] == 'error' || json['code'] == 'apiKeyMissing') {
      throw Exception(json['message']);
    }
    if (json['status'] == 'ok') {
      json['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel articlemodel = ArticleModel(
            title: element['title'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            auther: element['source']['name'],
            content: element['content'],
            publishAT: element['publishedAt'],
          );
          news.add(articlemodel);
        }
      });
    }
  }
}
