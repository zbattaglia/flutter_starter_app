// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      // apps will use the default them based on a device
      // the theme can be changed using ThemeData to customize to your liking
      theme: ThemeData(
        primaryColor: Colors.purple,
        canvasColor: Colors.yellow,
      ),
      home: RandomWords(),
    );
  }
}

// both classes below were created by typint "stful" and selecting stateful widget
// the RandomWords widget just creates its state class
// _RandomWordsState is automatically generated (underscore is standard for state),
// this enforces privacy 
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}
// state class extends its parent class
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; //Creates an array of type WordPair
  final _saved = Set<WordPair>(); //Creates a Set(~array) of type WordPair to save all of the favorited words
  final _biggerFont = TextStyle(fontSize: 18.0); //variable of type TextStyle that can be applied to text
  // widget to build scolling list of suggestions. ListView is typical for large / infinite lists
  Widget _buildSuggestions() {
    return ListView.builder(
      // sets 16 point padding to list
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        // every other row will be a divider
        if (i.isOdd) return Divider();
        // sets index to i divided by 2 (index = number of words without dividers)
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          // when number of words is greater than 10, generate more suggestions
          // .addAll appends everything onto the list (_suggestions)
          _suggestions.addAll(generateWordPairs().take(10));
        }
        // returns buildRow on each index in suggestions
        return _buildRow(_suggestions[index]);
      });
  }

  // Widget to build each row / index
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair); //checks saved set and returns true if pair is in set

    // list tile is a rendered index of a list
    return ListTile(
      // title of type text = pair (from english_words) in pascalCase with 
      // custom font size applied
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      // add a trailing (after Text) icon to the text
      // if alreadySaved is true show favorite icon, else show border
      // if alreadySaved is true color icon red, else null
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      // Method to add / remove tile from saved onTap
      onTap: () {
        // call set state on tap. if alreadySaved, remove from set, else add to set
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          }
          else {
            _saved.add(pair);
          }
        });
      }
    );
  }

  // pushSaved is a void function because it doesn't return anything
  void _pushSaved() {
    // the navigator is what handles routing in flutter. Pushing onto the navigator changes to
    // that page. Popping off of Navigator will return to the previous page
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          // tiles maps over the saved set
          final tiles = _saved.map(
            // each item in the map is a "pair" of type WordPair
            (WordPair pair) {
              // returns a listTile with the title of the pair in pascalCase with the larger font style
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          // adds a 1 pixel divider between each tile on tiles
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          // render / build of new page
          return Scaffold(
            // creates an AppBar with a title
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            // the body is a ListView
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  // override widget will be the build / display of app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar across top with title specified
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        // creates an IconButton on the appbar to change pages (routes) by calling pushSaved
        // actions always take an array of child widgets
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      // body is return of _buildSuggestions()
      body: _buildSuggestions(),
    );
  }
}