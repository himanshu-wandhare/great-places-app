import 'package:flutter/material.dart';
import 'package:native_features/models/place.dart';
import 'package:native_features/screens/place_details.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          "No places added yet.",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder:
          (ctx, index) => ListTile(
            leading: Hero(
              tag: places[index].id,
              child: CircleAvatar(
                radius: 26,
                backgroundImage: FileImage(places[index].image),
              ),
            ),
            title: Text(
              places[index].title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              places[index].location.address,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => PlaceDetails(place: places[index]),
                  ),
                ),
          ),
    );
  }
}
