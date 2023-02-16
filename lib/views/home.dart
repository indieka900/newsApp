// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/model/category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/views/article.dart';
import 'package:news_app/views/category.dart';
import 'package:intl/intl.dart';
import 'package:news_app/views/search_news.dart';
import 'package:news_app/views/sources.dart';
//import 'package:pull_to_refresh/pull_to_refresh.dart';

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
                },
                decoration: const InputDecoration(
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

class Subtitle extends StatelessWidget {
  final String imageUrl, name;
  const Subtitle({
    super.key,
    required this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return CategoryViews(
                category: name.toLowerCase(),
                title: name,
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 60,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Blogtile extends StatelessWidget {
  final String imageUrl, title, desc, url, now;

  const Blogtile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.desc,
    required this.url,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(now);
    // Calculate the difference between the current time and the parsed date
    Duration difference = DateTime.now().difference(dateTime);

    // Helper function to format a duration as a human-readable string
    String formatDuration(Duration duration) {
      if (duration.inSeconds < 60) {
        return "${duration.inSeconds} seconds ago";
      } else if (duration.inMinutes < 60) {
        return "${duration.inMinutes} minutes ago";
      } else if (duration.inHours < 24) {
        return "${duration.inHours} hours ago";
      } else {
        int days = duration.inDays;
        if (days == 1) {
          return "yesterday";
        } else if (days <= 7) {
          return "$days days ago";
        } else {
          return DateFormat("MMM d, y").format(dateTime);
        }
      }
    }

    // Format the difference as a human-readable string
    String formattedDifference = formatDuration(difference);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return WebViewApp(
                link: url,
              );
            },
          ),
        );
      },
      child: Container(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(imageUrl),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  // child: ClipRRect(
                  //   borderRadius: BorderRadius.circular(15),
                  //   child: Image.network(imageUrl),
                  // ),
                ),
                Positioned(
                  bottom: 10,
                  right: 30,
                  child: Text(
                    formattedDifference.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      backgroundColor: Colors.black45,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                decoration: TextDecoration.underline,
                fontSize: 20,
              ),
            ),
            Text(
              desc,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
