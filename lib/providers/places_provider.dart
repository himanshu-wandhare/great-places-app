import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_features/models/place.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  void addPlace(String title, String imagePath, PlaceLocation location) {
    final place = Place(title: title, imagePath: imagePath, location: location);
    state = [...state, place];
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);
