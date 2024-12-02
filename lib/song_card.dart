import 'package:flutter/material.dart';
import 'package:music_player/album_view.dart';


class SongCard extends StatelessWidget {
  final AssetImage image;
  final globalKey = GlobalKey();
  SongCard({
    required this.image,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumView(
              key: globalKey,
              image: image,
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        child: Column(
          children: [
            Image(
              image: image,
              width: 140,
              height: 140,
            ),
            Text(
              "Bad Bunny, Drake, Justin Bieber, Taylor Swift, Ed Sheeran",
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
