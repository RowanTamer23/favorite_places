import 'dart:io';

import 'package:favorite_places/models/place_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class UserPlacesNotifier extends StateNotifier<List<PlaceModel>> {
  UserPlacesNotifier() : super(const []);

  Future<Database> getDataBase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(
        dbPath,
        'places.db',
      ),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, description TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
      },
      version: 1,
    );
    return db;
  }

  Future<void> loadPlaces() async {
    final db = await getDataBase();
    final data = await db.query('user_places');
    final places = data
        .map((row) => PlaceModel(
            id: row['id'] as String,
            name: row['title'] as String,
            image: File(row['image'] as String),
            description: row['description'] as String,
            location: placeLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String)))
        .toList();
    state = places;
  }

  void addPlace(String title, String description, File image,
      placeLocation location) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final NewPlace = PlaceModel(
        name: title,
        description: description,
        image: copiedImage,
        location: location);

    final db = await getDataBase();
    db.insert('user_places', {
      'id': NewPlace.id,
      'title': NewPlace.name,
      'description': NewPlace.description,
      'image': NewPlace.image!.path,
      'lat': NewPlace.location.latitude,
      'lng': NewPlace.location.longitude,
      'address': NewPlace.location.address
    });

    state = [NewPlace, ...state];
  }
}

final UserPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<PlaceModel>>(
        (ref) => UserPlacesNotifier());
