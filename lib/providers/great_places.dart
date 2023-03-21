import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helper/db_helper.dart';
import 'package:flutter_complete_guide/helper/location_helper.dart';

import '../models/place.dart';

const DB_TABLE_PLACES = 'places';
const DB_TABLE_PLACES_ID = 'id';
const DB_TABLE_PLACES_TITLE = 'title';
const DB_TABLE_PLACES_IMAGE = 'image';
const DB_TABLE_PLACES_LOC_LAT = 'loc_lat';
const DB_TABLE_PLACES_LOC_LNG = 'loc_lng';
const DB_TABLE_PLACES_ADDRESS = 'address';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String title,
    File pickedImage,
    PlaceLocation pickedLocation,
  ) async {
    final address = await LocationHelper.getPlaceAddress(
      pickedLocation.latitude,
      pickedLocation.longitude,
    );
    if (address == null) return;
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address,
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      location: updatedLocation,
      image: pickedImage,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert(DB_TABLE_PLACES, {
      DB_TABLE_PLACES_ID: newPlace.id,
      DB_TABLE_PLACES_TITLE: newPlace.title,
      DB_TABLE_PLACES_IMAGE: newPlace.image.path,
      DB_TABLE_PLACES_LOC_LAT: newPlace.location.latitude,
      DB_TABLE_PLACES_LOC_LNG: newPlace.location.longitude,
      DB_TABLE_PLACES_ADDRESS: newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final data = await DBHelper.get(DB_TABLE_PLACES);
    _items = data
        .map((item) => Place(
              id: item[DB_TABLE_PLACES_ID],
              title: item[DB_TABLE_PLACES_TITLE],
              image: File(item[DB_TABLE_PLACES_IMAGE]),
              location: PlaceLocation(
                  latitude: item[DB_TABLE_PLACES_LOC_LAT],
                  longitude: item[DB_TABLE_PLACES_LOC_LNG],
                  address: item[DB_TABLE_PLACES_ADDRESS]),
            ))
        .toList();
    notifyListeners();
  }
}
