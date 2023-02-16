import 'package:flutter/material.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/views/home.dart';

class NewsSorces extends StatefulWidget {
  final String source;
  const NewsSorces({super.key, required this.source});

  @override
  State<NewsSorces> createState() => _NewsSorcesState();
}

class _NewsSorcesState extends State<NewsSorces> {
  List<ArticleModel> articles = <ArticleModel>[];

  @override
  void initState() {
    super.initState();
    getNews();
  }

  getNews() async {
    NewsSource newsClass = NewsSource();
    await newsClass.getNews(widget.source);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  bool _loading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _loading
          ? Container(
              color: Colors.greenAccent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('LOADING')
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () {
                articles.clear;
                return getNews();
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return Blogtile(
                            imageUrl: articles[index].urlToImage,
                            title: articles[index].title,
                            desc: articles[index].description,
                            url: articles[index].url,
                            now: articles[index].publishAT,
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
