import 'package:flutter/material.dart';
import 'ui/BookmarkListPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Bookmarks List")),
        body: BookmarkListPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}



