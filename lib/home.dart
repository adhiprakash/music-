import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:music_player/musicplayerpage.dart';
import 'package:music_player/settings.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:io';


class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<FileSystemEntity> _audioFiles = [];
  final ValueNotifier<Duration> _currentPositionNotifier = ValueNotifier(Duration.zero);
  final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance shared between both screens
  bool _isPlaying = false;
  int _currentIndex = -1;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    requestPermissions();

    _audioPlayer.onPositionChanged.listen((position) {
      _currentPositionNotifier.value = position;
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _playNext(); // Auto-play next song
    });
  }

  Future<void> requestPermissions() async {
    await Permission.storage.request();
    if (await Permission.storage.isGranted) {
      fetchAudioFiles();
    }
  }

  Future<void> fetchAudioFiles() async {
    List<FileSystemEntity> files = [];
    List<FileSystemEntity> music = Directory('/storage/emulated/0/Music').listSync(recursive: true);
    List<FileSystemEntity> download = Directory('/storage/emulated/0/Download').listSync(recursive: true);
    files.addAll([...music, ...download]);
    List<FileSystemEntity> audioFiles = files.where((file) {
      final path = file.path.toLowerCase();
      return path.endsWith('.mp3') || path.endsWith('.wav') || path.endsWith('.m4a') || path.endsWith('.aac');
    }).toList();

    setState(() {
      _audioFiles = audioFiles;
    });
  }

  Future<void> _playAudio(int index) async {
    if (index >= 0 && index < _audioFiles.length) {
      final file = _audioFiles[index];
      await _audioPlayer.play(DeviceFileSource(file.path));
      setState(() {
        _isPlaying = true;
        _currentIndex = index;
      });
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_currentIndex == -1 && _audioFiles.isNotEmpty) {
        await _playAudio(0);
      } else {
        await _audioPlayer.resume();
      }
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _playNext() async {
    if (_currentIndex + 1 < _audioFiles.length) {
      await _playAudio(_currentIndex + 1);
    }
  }

  Future<void> _playPrevious() async {
    if (_currentIndex - 1 >= 0) {
      await _playAudio(_currentIndex - 1);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 207, 4),
        title: Text("Music World"),
        centerTitle: true,
        actions: [IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
        }, icon: Icon(Icons.menu))],
      ),
      body: Column(
        children: [
          Expanded(
            child: _audioFiles.isNotEmpty
                ? ListView.builder(
                    itemCount: _audioFiles.length,
                    itemBuilder: (context, index) {
                      final file = _audioFiles[index];
                      return ListTile(
                        leading: Icon(Icons.music_note),
                        title: Text(file.path.split('/').last),
                        onTap: () {
                          _playAudio(index);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MusicPlayerPage(
                                file: file,
                                audioPlayer: _audioPlayer, // Pass the same AudioPlayer instance
                                currentPositionNotifier: _currentPositionNotifier, audioFiles: [], onPlayNext: () { _playNext(); }, onPlayPrevious: () {_playPrevious();  },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          // Playback Progression and Controls
          if (_audioFiles.isNotEmpty) ...[
            ValueListenableBuilder<Duration>(
              valueListenable: _currentPositionNotifier,
              builder: (context, position, child) {
                return LinearProgressIndicator(
                  value: _totalDuration.inMilliseconds > 0
                      ? position.inMilliseconds / _totalDuration.inMilliseconds
                      : 0,
                  backgroundColor: const Color.fromARGB(255, 6, 235, 63),
                  color: const Color.fromARGB(255, 240, 31, 4),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous),
                    iconSize: 36,
                    onPressed: _playPrevious,
                  ),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                    iconSize: 48,
                    onPressed: _togglePlayPause,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    iconSize: 36,
                    onPressed: _playNext,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
