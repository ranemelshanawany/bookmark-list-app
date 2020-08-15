import 'dart:convert';
import 'package:flutter/material.dart';
import 'bookmark_class.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Bookmarks List")),
        body: HomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url =
      'http://newsapi.org/v2/everything?q=apple&from=2020-08-13&to=2020-08-13&sortBy=popularity&apiKey=eb9535af01634676a4492abdb5b6c3b4';
  Future<List> bookmarkList;

  /*List<Bookmark> parseBookmarks(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Bookmark>((json) => Bookmark.fromJson(json)).toList();
  }*/
  //List data;
  //Bookmark book;

  List<Bookmark> _bookmarks = List<Bookmark>();

  Future<List<Bookmark>> getBookmark() async {
    var response = await http.get(url);
    var bookmarks = List<Bookmark>();

    if (response.statusCode == 200) {
      /*setState(() {
        var convertDataToJson = jsonDecode(response.body);
        bookmarkList = convertDataToJson["articles"];
      });*/
      //return parseBookmarks(response.body);
      var bookmarksJson = json.decode(response.body)['articles'];
      for (var bookmarkJson in bookmarksJson) {
        bookmarks.add(Bookmark.fromJson(bookmarkJson));
      }
    }
    return bookmarks;
  }

  @override
  void initState() {
    super.initState();
    getBookmark().then((value) {
      setState(() {
        _bookmarks.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //makeBookmarkList();

    return ListView.builder(
      itemCount: _bookmarks == null ? 0 : _bookmarks.length,
      //future: getBookmark(),
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          child: Card(
              child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(bookmark: _bookmarks[index]),
                ),
              );
            },
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _bookmarks[index].title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(_bookmarks[index].description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 12, top: 8, bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(_bookmarks[index].urlToImage,
                          width: 150, height: 150, fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
          )),
        );
      },
    );
  }

}

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final Bookmark bookmark;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.bookmark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              bookmark.title,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              bookmark.description,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
