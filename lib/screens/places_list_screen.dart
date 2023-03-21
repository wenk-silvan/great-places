import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/place.dart';
import 'package:flutter_complete_guide/providers/great_places.dart';
import 'package:flutter_complete_guide/screens/add_place_screen.dart';
import 'package:flutter_complete_guide/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<GreatPlaces>(
                    builder: (ctx, greatPlaces, child) =>
                        greatPlaces.items.length <= 0
                            ? child
                            : ListView.builder(
                                itemCount: greatPlaces.items.length,
                                itemBuilder: (ctx, i) =>
                                    placesListItem(ctx, greatPlaces.items[i])),
                    child: Center(
                      child: const Text('No places yet...'),
                    ),
                  ),
      ),
    );
  }

  Widget placesListItem(BuildContext ctx, Place place) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: FileImage(place.image),
      ),
      title: Text(place.title),
      subtitle: Text(place.location.address),
      onTap: () {
        Navigator.of(ctx).pushNamed(
          PlaceDetailScreen.routeName,
          arguments: place.id,
        );
      },
    );
  }
}
