import 'package:favorite_places/main.dart';
import 'package:favorite_places/models/place_model.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';

class PlaceDetails extends StatelessWidget {
  const PlaceDetails({super.key, required this.place});

  final PlaceModel place;

  String get locationImage {
    final lat = place.location.latitude;
    final lng = place.location.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:R%7C$lat,$lng&key=AIzaSyDUu_nen7QeSRxle31y8NXFfDqmbst7r8k';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(place.name),
        ),
        body: Stack(
          children: [
            Image.file(
              place.image!,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),

            // description
            Positioned(
                top: 20,
                right: 0,
                left: 0,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.transparent,
                    Colors.black54,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                  child: Text(place.description!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: colorScheme.onBackground,
                          )),
                )),

            // map and adress
            Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => MapScreen(
                                  location: place.location,
                                  isSelecting: false,
                                )));
                      },
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(locationImage),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: Text(place.location.address,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: colorScheme.onBackground,
                                  )),
                    )
                  ],
                ))
          ],
        ));
  }
}
