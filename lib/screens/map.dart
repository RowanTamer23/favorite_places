import 'package:favorite_places/models/place_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      this.location =
          const placeLocation(latitude: 0, longitude: 0, address: ''),
      this.isSelecting = true});
  final placeLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapScreen> {
  LatLng? pickedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick a location' : 'Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop(pickedPosition);
                },
                icon: const Icon(Icons.save_alt)),
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (position) {
                setState(() {
                  pickedPosition = position;
                });
              },
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.location.latitude, widget.location.longitude),
            zoom: 18),
        markers: (pickedPosition == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                    markerId: const MarkerId('m1'),
                    position: pickedPosition ??
                        LatLng(widget.location.latitude,
                            widget.location.longitude))
              },
      ),
    );
  }
}
