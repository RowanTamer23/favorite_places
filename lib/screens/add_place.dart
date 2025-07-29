import 'dart:io';

import 'package:favorite_places/main.dart';
import 'package:favorite_places/models/place_model.dart';
import 'package:favorite_places/provider/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlace extends ConsumerStatefulWidget {
  AddPlace({
    super.key,
  });

  @override
  ConsumerState<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  File? selectedImage;
  placeLocation? selectedLocation;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  void savePlace() {
    final savedTitle = titleController.text;
    final savedDescription = descriptionController.text;

    if (savedTitle.isEmpty && savedDescription.isEmpty ||
        selectedImage == null ||
        selectedLocation == null) {
      return;
    }

    ref.read(UserPlacesProvider.notifier).addPlace(
        savedTitle, savedDescription, selectedImage!, selectedLocation!);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        appBar: AppBar(
          title: const Text('Add Place'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    label: Text(
                  'Name',
                  style: TextStyle(
                      color: colorScheme.onPrimaryContainer, fontSize: 15),
                )),
              ),
              TextField(
                controller: descriptionController,
                maxLength: 500,
                maxLines: 2,
                decoration: InputDecoration(
                    label: Text(
                  'Description',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontSize: 15,
                  ),
                )),
              ),
              const SizedBox(
                height: 20,
              ),
              ImageInput(onPickedImage: (image) {
                selectedImage = image;
              }),
              const SizedBox(
                height: 20,
              ),
              LocationInput(
                onSelectLocation: (location) {
                  selectedLocation = location;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'reset',
                        style: TextStyle(color: colorScheme.onPrimaryContainer),
                      )),
                  ElevatedButton.icon(
                    onPressed: savePlace,
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Add',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
