import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app/views/home.dart';
import 'package:splashscreen/splashscreen.dart';

  
class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 6,
      navigateAfterSeconds:  const Home(),
      title:  const Text('NewsApp',textScaleFactor: 2,),
      image:  Image.network('https://media.istockphoto.com/id/1390033645/photo/world-news-background-which-can-be-used-for-broadcast-news.jpg?b=1&s=170667a&w=0&k=20&c=glqFWZtWU4Zqyxd8CRu5_Or81zqwe7cyhturXaIFEOA='),
      loadingText: const Text("Loading"),
      photoSize: 100.0,
      loaderColor: Colors.blue,
    );
  }
}
