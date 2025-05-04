// flight_tiles.dart
import 'package:flight_delay_app/src/constants/variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/flight_provider.dart';
import '../screens/flight_info.dart';
import 'flight_tile.dart';

class FlightListTiles extends StatelessWidget {
  final String? airportCode;
  final bool showFavoritesOnly;
  final String title;
  final int maxItems;
  final bool showScrollable;

  const FlightListTiles({
    Key? key,
    this.airportCode,
    this.showFavoritesOnly = false,
    this.title = 'Flights',
    this.maxItems = 0, // 0 means show all
    this.showScrollable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FlightProvider>(
      builder: (context, flightProvider, child) {
        List<dynamic> flights = [];

        if (showFavoritesOnly) {
          flights = flightProvider.favoriteFlights;
        } else if (airportCode != null) {
          flights = flightProvider.getFlightsByAirport(airportCode!);
        } else {
          flights = flightProvider.allFlights;
        }

        // Limit the number of items if maxItems is set
        if (maxItems > 0 && flights.length > maxItems) {
          flights = flights.sublist(0, maxItems);
        }

        if (flights.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: Text(
                showFavoritesOnly
                    ? 'No favourite flights yet.'
                    : 'No flights available.',
                style: TextStyle(
                  fontSize: Variables.responsiveFontSize(context, 16),
                  color: Variables.textLabel,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: Variables.responsiveFontSize(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ListView.builder(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              physics:
                  showScrollable ? null : const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: flights.length,
              itemBuilder: (context, index) {
                final flight = flights[index];
                final isFavorite = flightProvider.isFavorite(flight);

                return FlightTile(
                  flight: flight,
                  isFavorite: isFavorite,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlightInfo(flight: flight),
                      ),
                    );
                  },
                  onFavoriteToggle: (flight) {
                    flightProvider.toggleFavorite(flight.flightNumber);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
