
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:lottie/lottie.dart';

class MusicPlayerPage extends StatefulWidget {
  final FileSystemEntity file;
  final AudioPlayer audioPlayer;
  final ValueNotifier<Duration> currentPositionNotifier;
  final List<FileSystemEntity> audioFiles;
  final VoidCallback onPlayNext;
  final VoidCallback onPlayPrevious;

  MusicPlayerPage({
    required this.file,
    required this.audioPlayer,
    required this.currentPositionNotifier,
    required this.audioFiles,
    required this.onPlayNext,
    required this.onPlayPrevious,
  });

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool isFavorited = false;
  bool isMuted = false;
  double previousVolume = 1.0;
  Duration totalDuration = Duration.zero;
  late AnimationController _animationController;
  double _backgroundOpacity = 0.0; // For the fade effect

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: Duration(seconds: 10), vsync: this)
      ..forward()
      ..repeat();

    widget.audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        totalDuration = duration;
      });
    });

    widget.audioPlayer.onPositionChanged.listen((position) {
      widget.currentPositionNotifier.value = position;
    });

    playAudio();

    // Trigger the background fade effect after the widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _backgroundOpacity = 1.0; // Set to fully opaque
      });
    });
  }

  Future<void> playAudio() async {
    await widget.audioPlayer.setSourceDeviceFile(widget.file.path);
    await widget.audioPlayer.resume();
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> _playPause() async {
    if (isPlaying) {
      await widget.audioPlayer.pause();
      _animationController.stop();
    } else {
      await widget.audioPlayer.resume();
      _animationController.forward();
      _animationController.repeat();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _toggleMute() {
    setState(() {
      if (isMuted) {
        widget.audioPlayer.setVolume(previousVolume);
      } else {
        previousVolume = widget.audioPlayer.volume;
        widget.audioPlayer.setVolume(0.0);
      }
      isMuted = !isMuted;
    });
  }

  void _toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Background Image with Fade Effect
        AnimatedOpacity(
          opacity: _backgroundOpacity,
          duration: const Duration(seconds: 2),
          child: SizedBox.expand(
            child: Image.asset(
              'assets/black.jpeg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 50), // Padding at the top
            
            // Music Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                _getFileName(widget.file.path), // Method to get the file name
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 1, // Limit to one line
                overflow: TextOverflow.ellipsis, // Handle long names gracefully
              ),
            ),
            
            const Spacer(), // Push content to the lower part of the page
            
            // Circular Progress Indicator (Lottie Animation can be added here if needed)
            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset(
                    'assets/Animation - 1731567960341.json',
                    controller: _animationController,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            
            // Music Progress Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ValueListenableBuilder<Duration>(
                valueListenable: widget.currentPositionNotifier,
                builder: (context, position, child) {
                  return Slider(
                    activeColor: const Color.fromARGB(255, 6, 252, 47),
                    inactiveColor: Colors.grey,
                    min: 0,
                    max: totalDuration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      await widget.audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  );
                },
              ),
            ),

            // Music Control Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    iconSize: 50,
                    color: Colors.white,
                    onPressed: widget.onPlayPrevious,
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
                    iconSize: 64,
                    color: const Color.fromARGB(255, 6, 252, 47),
                    onPressed: _playPause,
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    iconSize: 50,
                    color: Colors.white,
                    onPressed: widget.onPlayNext,
                  ),
                ],
              ),
            ),
            
            // Mute and Favorite Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border),
                  iconSize: 40,
                  color: Colors.red,
                  onPressed: _toggleFavorite,
                ),
                const SizedBox(width: 30),
                IconButton(
                  icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                  iconSize: 40,
                  color: const Color.fromARGB(255, 3, 183, 238),
                  onPressed: _toggleMute,
                ),
              ],
            ),
            const SizedBox(height: 20), // Add space at the bottom
          ],
        ),
      ],
    ),
  );
}

// Helper method to get the file name from the path
String _getFileName(String path) {
  return path.split('/').last.split('.').first; // Returns only the file name without extension
}
}