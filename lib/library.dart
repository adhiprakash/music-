import 'package:flutter/material.dart';

class LibraryView extends StatefulWidget {
  @override
  _LibraryViewState createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final List<String> songs = [
    "Music 1",
    "Music 2",
    "Music 3",
    "Music 4",
    "Music 5",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 26, 230, 8),
        title: Text("Music Libre"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.music_note),
            title: Text(songs[index]),
            trailing: Icon(Icons.play_arrow),
            onTap: () {
              // Code to play song or navigate to song details
            },
          );
        },
      ),
    );
  }
}
