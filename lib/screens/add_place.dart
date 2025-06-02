import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_features/models/place.dart';
import 'package:native_features/providers/places_provider.dart';
import 'package:native_features/widgets/image_input.dart';
import 'package:native_features/widgets/location_input.dart';

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});

  @override
  ConsumerState<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  File? _image;
  PlaceLocation? _selectedLocation;

  String? _validator(String? value) {
    if (value == null || value.isEmpty || value.trim().length <= 1) {
      return "Must be between 2 to 50 characters";
    }
    return null;
  }

  void _onAddPlace() {
    final formCurrentState = _formKey.currentState;

    if (formCurrentState?.validate() ?? false) {
      if (_image == null || _selectedLocation == null) return;
      formCurrentState?.save();

      ref
          .read(placesProvider.notifier)
          .addPlace(_title, _image!, _selectedLocation!);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add a new place")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                validator: _validator,
                onSaved: (newValue) => _title = newValue!.trim(),
              ),
              const SizedBox(height: 10),
              ImageInput(onCapturePicture: (file) => _image = file),
              const SizedBox(height: 10),
              LocationInput(
                onSelectLocation: (location) => _selectedLocation = location,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _onAddPlace,
                label: const Text("Add Place"),
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
