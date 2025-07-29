import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class placeLocation {
  const placeLocation(
      {required this.latitude, required this.longitude, required this.address});

  final double latitude;
  final double longitude;
  final String address;
}

class PlaceModel {
  PlaceModel(
      {required this.name,
      this.image,
      this.description = '',
      required this.location,
      String? id})
      : id = id ?? uuid.v4();

  final String id;
  final String name;
  final File? image;
  final String? description;
  final placeLocation location;
}
