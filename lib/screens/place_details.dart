import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:native_features/models/place.dart';
import 'package:native_features/screens/map.dart';

class PlaceDetails extends StatelessWidget {
  const PlaceDetails({super.key, required this.place});

  String get _locationImage {
    final lat = place.location.latitude;
    final lon = place.location.longitude;

    return "https://maps.geoapify.com/v1/staticmap?style=osm-bright&width=600&height=300&center=lonlat:$lon,$lat&zoom=13&marker=lonlat:$lon,$lat;color:%23ff0000;size:42;text:1&apiKey=${dotenv.env['GEOAPIFY_KEY']}";
  }

  final Place place;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Stack(
        children: [
          Hero(
            tag: place.id,
            child: Image(
              image:
                  kIsWeb
                      ? NetworkImage(place.imagePath)
                      : FileImage(File(place.imagePath)),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => MapScreen(
                                location: place.location,
                                isSelecting: false,
                              ),
                        ),
                      ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(_locationImage),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    place.location.address,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
