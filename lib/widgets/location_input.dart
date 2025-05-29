import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:native_features/models/place.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool _isGettingLocation = false;
  PlaceLocation? _pickedLocation;

  String get _locationImage {
    if (_pickedLocation == null) return "";

    final lat = _pickedLocation!.latitude;
    final lon = _pickedLocation!.longitude;

    return "https://staticmap.openstreetmap.de/staticmap.php?center=$lat,$lon&zoom=13&size=600x300&markers=$lat,$lon,red";
  }

  void _getCurrentLocation() async {
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

    setState(() => _isGettingLocation = true);
    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lon = locationData.longitude;

    if (lat == null || lon == null) return;

    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lon",
    );

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'NativeFeatures (try.himanshu.wandhare@gmail.com)',
      },
    );

    final resData = json.decode(response.body);

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lon,
        address: resData['display_name'],
      );
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location choosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        _locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: previewContent,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              label: const Text("Get Current Location"),
              icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: () {},
              label: const Text("Select on Map"),
              icon: Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
