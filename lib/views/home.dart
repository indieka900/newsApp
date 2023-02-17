// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/views/blog_tile.dart';
import 'package:news_app/views/search_news.dart';
import 'package:news_app/views/shortcut.dart';
import 'package:news_app/views/sources.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = <CategoryModel>[];
  List<ArticleModel> articles = <ArticleModel>[];
  final _textController = TextEditingController();

  bool _loading = true;

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: !_isSearching
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'Trending',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'News',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
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
                      builder: (context) => Searched(source: value),
                    ),
                  );
                  _textController.clear();
                  _isSearching = false;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                  fillColor: Color.fromARGB(255, 77, 75, 75),
                  filled: true,
                  hintText: "Search any categories",
                  hintStyle: TextStyle(color: Colors.green),
                ),
              ),
        actions: [
          IconButton(
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
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'abc-news',
                child: Text('ABC News'),
              ),
              const PopupMenuItem(
                value: 'associated-press',
                child: Text('Associated-press News'),
              ),
              const PopupMenuItem(
                value: 'australian-financial-review',
                child: Text('Australian News'),
              ),
              const PopupMenuItem(
                value: 'bbc-news',
                child: Text('BBC News'),
              ),
              const PopupMenuItem(
                value: 'cnn',
                child: Text('CNN News'),
              ),
              const PopupMenuItem(
                value: 'cbc-news',
                child: Text('CBC News'),
              ),
              const PopupMenuItem(
                value: 'entertainment-weekly',
                child: Text('Entertainment-weekly'),
              ),
              const PopupMenuItem(
                value: 'google-news',
                child: Text('GOOGLE News'),
              ),
              const PopupMenuItem(
                value: 'fox-sports',
                child: Text('Fox sports News'),
              ),
              const PopupMenuItem(
                value: 'hacker-news',
                child: Text('HACKER News'),
              ),
            ],
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
                      Container(
                        padding: const EdgeInsets.all(12),
                        height: 150,
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
                      Container(
                        child: ListView.builder(
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
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
