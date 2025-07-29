import 'package:favorite_places/provider/user_places.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return _placesScreenState();
  }
}

class _placesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> placesFuture;

  @override
  void initState() {
    super.initState();
    placesFuture = ref.read(UserPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(UserPlacesProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Favorite Places'),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddPlace())),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: FutureBuilder(
          future: placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : PlacesList(
                      places: userPlaces,
                    ),
        ));
  }
}
