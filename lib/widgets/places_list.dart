import 'package:favorite_places/main.dart';
import 'package:favorite_places/models/place_model.dart';
import 'package:favorite_places/screens/place_details.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  PlacesList({super.key, required this.places});

  final List<PlaceModel> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const Center(
        child: Text('No places found. Start adding some!'),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 80,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: FileImage(places[index].image!),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => PlaceDetails(place: places[index])));
            },
            title: Text(
              places[index].name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: colorScheme.onBackground, fontSize: 20),
            ),
            subtitle: Text(
              places[index].location.address,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: colorScheme.onBackground,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
