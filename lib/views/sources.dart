import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/views/blog_tile.dart';

class NewsSorces extends StatefulWidget {
  final String source;
  final String title;
  const NewsSorces({super.key, required this.source, required this.title});

  @override
  State<NewsSorces> createState() => _NewsSorcesState();
}

class _NewsSorcesState extends State<NewsSorces> {
  List<ArticleModel> articles = <ArticleModel>[];
  String _timeString = '';
  String _errorMessage = '';
  int _page = 1;

  @override
  void initState() {
    super.initState();
    getNews();
    getTime();
  }

  getNews() async {
    NewsSource newsClass = NewsSource();
    try {
      await newsClass.getNews(widget.source,_page);
      articles = newsClass.news;
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load news: \n${e.toString()}";
        _loading = false;
      });
    }
  }

  getTime() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeString = DateFormat('hh:mm a').format(DateTime.now());
      });
    });
    _timeString = DateFormat('hh:mm a').format(DateTime.now());
  }

  bool _loading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _errorMessage.isNotEmpty
          ? const Color.fromARGB(255, 23, 59, 24)
          : Colors.black,
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
          ),
        ),
        title: Text(
          widget.title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(3.2),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: Text(
              _timeString,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
        ],
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
                _page <= 5 ? _page++ : _page = 5;
                return getNews();
              },
              child: _errorMessage.isNotEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(15),
                          child: Blogtile(
                            auther: articles[index].auther!,
                            imageUrl: articles[index].urlToImage,
                            title: articles[index].title,
                            desc: articles[index].description,
                            url: articles[index].url,
                            now: articles[index].publishAT,
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
