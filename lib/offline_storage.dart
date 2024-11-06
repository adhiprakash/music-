import 'package:hive/hive.dart';

Future<void> storeFavoriteSong(String songId) async {
  var box = await Hive.openBox('favorites');
  box.put('favoriteSong', songId);
}