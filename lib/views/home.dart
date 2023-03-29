// ignore_for_file: avoid_unnecessary_containers, prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/helper/popup.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/views/blog_tile.dart';
import 'package:news_app/views/search_news.dart';
import 'package:news_app/views/shortcut.dart';
import 'package:news_app/views/sources.dart';
import 'package:news_app/views/splash.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = <CategoryModel>[];
  List<ArticleModel> articles = <ArticleModel>[];
  List<ArticleModel> finalarticles = <ArticleModel>[];
  final _textController = TextEditingController();
  int _page = 1;
  String hashed = '';

  bool _loading = true;
  bool _loading1 = false;

  bool _isSearching = false;
  String? _timeString;
  Timer? _timer;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
    getTime();
  }

  getTime() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeString = DateFormat('hh:mm a').format(DateTime.now());
      });
    });
    _timeString = DateFormat('hh:mm a').format(DateTime.now());
  }

  Future<void> getNews() async {
    News newsClass = News();
    try {
      await newsClass.getNews(_page);
      List<ArticleModel> newArticles = newsClass.news;
      setState(() {
        if (_page == 1) {
          articles = newArticles;
        } else {
          articles.addAll(newArticles);
        }
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load news: \n${e.toString()}";
        _loading = false;
      });
    }
  }

  loadmore() async {
    if (_page <= 4) {
      _page++;
      setState(() {
        _loading1 = true;
        articles.clear();
      });
      await getNews();
      setState(() {
        _loading1 = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Splash()
        : Scaffold(
            backgroundColor: _errorMessage.isNotEmpty
                ? const Color.fromARGB(255, 23, 59, 24)
                : Colors.black,
            appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    title: !_isSearching
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Trending',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25,
                                ),
                              ),
                              const Text(
                                'News',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Container(
                                padding: const EdgeInsets.all(3.2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  _timeString!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : TextField(
                            controller: _textController,
                            style: const TextStyle(color: Colors.white),
                            onSubmitted: (value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Searched(
                                    source: value,
                                    search: _textController.text,
                                  ),
                                ),
                              );
                              _textController.clear();
                              _isSearching = false;
                            },
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              fillColor: Color.fromARGB(255, 77, 75, 75),
                              filled: true,
                              hintText: "Search any categories",
                              hintStyle: TextStyle(color: Colors.green),
                            ),
                          ),
                    actions: [
                      if (_errorMessage.isEmpty)
                        Container(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _isSearching = !_isSearching;
                              });
                            },
                            icon: Icon(
                              !_isSearching ? Icons.search : Icons.clear,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      PopupMenuButton(
                        itemBuilder: (context) => popupMenuItems,
                        onSelected: (String newvalue) {
                          setState(() {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NewsSorces(
                                source: newvalue,
                                title: newvalue,
                              ),
                            ));
                          });
                        },
                        color: Colors.green,
                      ),
                    ],
                  ),
            body: RefreshIndicator(
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
                        child: SelectableText(
                          _errorMessage,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              height: 100,
                              child: ListView.builder(
                                itemCount: categories.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Subtitle(
                                    imageUrl: categories[index].imageUrl,
                                    name: categories[index].categoryName,
                                  );
                                },
                              ),
                            ),
                            LazyLoadScrollView(
                              onEndOfPage: () => loadmore(),
                              isLoading: _loading,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: articles.length,
                                //itemExtent: 120,
                                itemBuilder: (context, index) {
                                  return Blogtile(
                                    auther: articles[index].auther!,
                                    imageUrl: articles[index].urlToImage,
                                    title: articles[index].title,
                                    desc: articles[index].description,
                                    url: articles[index].url,
                                    now: articles[index].publishAT,
                                    //hashed: hashed,
                                  );
                                },
                              ),
                            ),
                            _loading1
                                ? Center(
                                    child: Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 50.0),
                                      child: const LinearProgressIndicator(
                                        color: Colors.white,
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: Colors.transparent,
                                  )
                          ],
                        ),
                      ),
                    ),
            ),
            floatingActionButton: !_loading
                ? FloatingActionButton(
                    onPressed: () => loadmore(),
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.refresh),
                  )
                : null,
          );
  }
}
