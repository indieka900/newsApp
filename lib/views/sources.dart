import 'package:flutter/material.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/views/blog_tile.dart';
import 'package:news_app/views/home.dart';

class NewsSorces extends StatefulWidget {
  final String source;
  final String title;
  const NewsSorces({super.key, required this.source, required this.title});

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),),
        title: Text(
          widget.title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
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
