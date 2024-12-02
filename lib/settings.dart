import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  double _volume = 1.0;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _volume = prefs.getDouble('volume') ?? 1.0;
      _playbackSpeed = prefs.getDouble('playbackSpeed') ?? 1.0;
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setDouble('volume', _volume);
    await prefs.setDouble('playbackSpeed', _playbackSpeed);
  }

  void _resetSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _isDarkMode = false;
      _volume = 1.0;
      _playbackSpeed = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: const Color.fromARGB(255, 100, 238, 7),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Dark Mode Toggle
          SwitchListTile(
            title: Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              _saveSettings();
            },
            secondary: Icon(Icons.dark_mode),
          ),
          SizedBox(height: 20),

          // Volume Control
          ListTile(
            title: Text('Volume'),
            subtitle: Slider(
              activeColor: Colors.green,
              value: _volume,
              min: 0,
              max: 1,
              divisions: 10,
              label: '${(_volume * 100).round()}%',
              onChanged: (value) {
                setState(() {
                  _volume = value;
                });
                _saveSettings();
              },
            ),
            leading: Icon(Icons.volume_up),
          ),
          SizedBox(height: 20),

          // Playback Speed Control
          ListTile(
            title: Text('Playback Speed'),
            subtitle: Slider(
              activeColor: Colors.blue,
              value: _playbackSpeed,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              label: '${_playbackSpeed.toStringAsFixed(1)}x',
              onChanged: (value) {
                setState(() {
                  _playbackSpeed = value;
                });
                _saveSettings();
              },
            ),
            leading: Icon(Icons.speed),
          ),
          SizedBox(height: 20),

          // About Section
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            subtitle: Text('Music Player App v1.0\nDeveloped by [Your Name]'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('About'),
                    content: Text(
                      'This is a simple music player app built with Flutter. Enjoy your favorite tracks with a sleek interface!',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          SizedBox(height: 20),

          // Reset Settings Button
          ListTile(
            title: Text(
              'Reset Settings',
              style: TextStyle(color: Colors.red),
            ),
            leading: Icon(Icons.refresh, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Reset Settings'),
                  content: Text('Are you sure you want to reset all settings?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _resetSettings();
                        Navigator.pop(context);
                      },
                      child: Text('Reset', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}






