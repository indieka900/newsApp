import 'package:flutter/material.dart';

final Map<String, String> newsSources = {
  'abc-news': 'ABC News',
  'associated-press': 'Associated-press News',
  'australian-financial-review': 'Australian News',
  'bbc-news': 'BBC News',
  'cnn': 'CNN News',
  'cbc-news': 'CBC News',
  'entertainment-weekly': 'Entertainment-weekly',
  'google-news': 'GOOGLE News',
  'fox-sports': 'Fox sports News',
  'hacker-news': 'HACKER News',
};

final List<MapEntry<String, String>> popupItems = newsSources.entries.toList();


final List<PopupMenuEntry<String>> popupMenuItems = popupItems
    .map((entry) => PopupMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        ))
    .toList();

