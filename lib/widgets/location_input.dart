import 'dart:convert';

import 'package:favorite_places/models/place_model.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(placeLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return LocationInputState();
  }
}

class LocationInputState extends State<LocationInput> {
  placeLocation? pickedLocation;
  var isGettingLocation = false;

  String get locationImage {
    if (pickedLocation == null) {
      return '';
    }

    final lat = pickedLocation!.latitude;
    final lng = pickedLocation!.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:R%7C$lat,$lng&key=AIzaSyDUu_nen7QeSRxle31y8NXFfDqmbst7r8k';
  }

  Future<void> savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyDUu_nen7QeSRxle31y8NXFfDqmbst7r8k');
    final response = await http.get(url);
    final resdata = json.decode(response.body);
    final address = resdata['results'][0]['formatted_address'];

    setState(() {
      pickedLocation = placeLocation(
          latitude: latitude, longitude: longitude, address: address);
      isGettingLocation = false;
    });
    widget.onSelectLocation(pickedLocation!);
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    savePlace(lat, lng);
  }

  void selectOnMap() async {
    Location location = Location();
    LocationData locationData;

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    final pickedLocation = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
            builder: (ctx) => MapScreen(
                location: placeLocation(
                    latitude: lat, longitude: lng, address: 'address'))));
    if (pickedLocation == null) {
      return;
    }
    savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'No location chosen yet!',
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
    );

    if (pickedLocation != null) {
      content = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (isGettingLocation) {
      content = CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
            width: double.infinity,
            height: 170,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.5))),
            alignment: Alignment.center,
            child: content),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getCurrentLocation,
              label: const Text('Get current location'),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: selectOnMap,
              label: const Text('Choose on map'),
              icon: const Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
