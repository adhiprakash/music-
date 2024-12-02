import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_player/login.dart';


class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  final List<String> playlists = ["Chill Vibes", "Workout Hits", "Top 2023"];
  final List<String> recentSongs = ["Song A", "Song B", "Song C", "Song D"];

  Future<void> _signOut() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Disconnect from Google Sign-In
      await _googleSignIn.disconnect();

      // Navigate to SignInPage and remove previous routes
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: currentUser?.photoURL != null
                      ? NetworkImage(currentUser!.photoURL!)
                      : AssetImage('assets/pinky.jpeg') as ImageProvider,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser?.displayName ?? "User Name",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      currentUser?.email ?? "User Email",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Divider(height: 32, thickness: 1),

            // Playlists Section
            Text(
              "Playlists",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Icon(Icons.playlist_play, size: 50),
                        SizedBox(height: 4),
                        Text(playlists[index]),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(height: 32, thickness: 1),

            // Recently Played Section
            
            Text(
              "Liked Musics",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recentSongs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.music_note),
                    title: Text(recentSongs[index]),
                    trailing: Icon(Icons.play_arrow),
                    onTap: () {
                      // Code to play the selected song
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
