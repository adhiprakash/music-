import 'package:flutter/material.dart';
import 'package:music_player/album_view.dart';


class AlbumCard extends StatelessWidget {
  final ImageProvider image;
  final String label;
  final Function? onTap;
  final double size;
  AlbumCard({
    Key? key,
    required this.image,
    required this.label,
    this.onTap,
    this.size = 120,
  }) : super(key: key);
  final globalKey = GlobalKey();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: image,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(label),
        ],
      ),
    );
  }
}
