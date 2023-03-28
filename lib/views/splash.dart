import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app/views/home.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 1,
      navigateAfterSeconds:  const Home(),
      title: const Text(
        'NewsApp',
        textScaleFactor: 3,
        style: TextStyle(
          color: Colors.white,
          backgroundColor: Color.fromARGB(143, 0, 0, 0),
        ),
      ),
      image: Image.asset('assets/images/background.jpg'),
      loadingText: const Text("Loading"),
      imageBackground: const AssetImage(
          'assets/images/background.jpg',),
      photoSize: 150.0,
      loaderColor: const Color.fromARGB(255, 250, 251, 252),
    );
  }
}
