import 'package:flight_delay_app/src/constants/variables.dart';
import 'package:flutter/material.dart';

import '../widgets/flight_list_tiles.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.greyBG,
      appBar: AppBar(
        backgroundColor: Variables.greyBG,
        title: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Favourites',
            style: TextStyle(
              fontSize: Variables.responsiveFontSize(context, 30),
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 15.0,
          ),
          child: ListView(
            children: [
              FlightListTiles(
                showFavoritesOnly: true,
                title: '',
                showScrollable: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
