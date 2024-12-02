import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<FileSystemEntity> allAudioFiles = [];
  List<FileSystemEntity> searchResults = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  // Request permissions and load audio files if granted
  Future<void> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      loadAudioFiles();
    } else {
      // Handle denied permission scenario
      print("Storage permission denied.");
    }
  }

  // Load audio files from specified directories
  Future<void> loadAudioFiles() async {
    final musicDir = Directory('/storage/emulated/0/Music');
    final downloadDir = Directory('/storage/emulated/0/Download');

    List<FileSystemEntity> musicFiles = [];
    List<FileSystemEntity> downloadFiles = [];

    if (await musicDir.exists()) {
      musicFiles = musicDir.listSync().where((file) => file.path.endsWith('.mp3')).toList();
    }
    if (await downloadDir.exists()) {
      downloadFiles = downloadDir.listSync().where((file) => file.path.endsWith('.mp3')).toList();
    }

    setState(() {
      allAudioFiles = [...musicFiles, ...downloadFiles];
      searchResults = allAudioFiles;
    });
  }

  // Search function to filter files based on the query
  void searchAudioFiles(String query) {
    final results = allAudioFiles.where((file) {
      final fileName = file.path.split('/').last.toLowerCase();
      return fileName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Search Audio Files"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search for audio files...",
                prefixIcon: Icon(Icons.search, color: Colors.purple),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: searchAudioFiles, // Call search function on text change
            ),
          ),
          Expanded(
            child: searchResults.isNotEmpty
                ? ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final file = searchResults[index];
                      final fileName = file.path.split('/').last;

                      return ListTile(
                        title: Text(
                          fileName,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        onTap: () {
                          // Code to navigate to the music player page or play the audio file
                        },
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "No audio files found",
                      style: TextStyle(color: Colors.purple, fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
