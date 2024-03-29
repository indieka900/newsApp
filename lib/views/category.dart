import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/views/blog_tile.dart';

class CategoryViews extends StatefulWidget {
  final String category, title;
  const CategoryViews({super.key, required this.category, required this.title});

  @override
  State<CategoryViews> createState() => _CategoryViewsState();
}

class _CategoryViewsState extends State<CategoryViews> {
  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;
  String _timeString = '';
  String _errorMessage = '';
  int _page = 1;

  @override
  void initState() {
    super.initState();
    getCategoryNews();
    getTime();
  }

  getTime() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeString = DateFormat('hh:mm a').format(DateTime.now());
      });
    });
    _timeString = DateFormat('hh:mm a').format(DateTime.now());
  }

  getCategoryNews() async {
    NewsCategory newsClass = NewsCategory();
    try {
      await newsClass.getNews(widget.category,_page);
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await getCategoryNews();
      },
      child: Scaffold(
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              const Text(
                'News',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25,
                ),
              ),
            ],
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
                return getCategoryNews();
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
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return Blogtile(
                            auther: articles[index].auther!,
                            now: articles[index].publishAT,
                            imageUrl: articles[index].urlToImage,
                            title: articles[index].title,
                            desc: articles[index].description,
                            url: articles[index].url, ///hashed: '',
                          );
                        },
                      ),
                    ),
            ),
      ),
    );
  }
}
