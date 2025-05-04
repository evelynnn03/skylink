import 'package:flight_delay_app/src/constants/variables.dart';
import 'package:flight_delay_app/src/screens/flight_info.dart';
import 'package:flight_delay_app/src/widgets/flight_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/flight_provider.dart';

class AirportFlights extends StatelessWidget {
  final String airportCode;
  final String airportName;

  const AirportFlights(
      {super.key, required this.airportCode, required this.airportName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.greyBG,
      appBar: AppBar(
        backgroundColor: Variables.greyBG,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              airportCode,
              style: TextStyle(
                fontSize: Variables.responsiveFontSize(context, 30),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              airportName,
              style: TextStyle(
                fontSize: Variables.responsiveFontSize(context, 16),
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Variables.backButton(context),
        ),
      ),
      body: Consumer<FlightProvider>(
        builder: (context, flightProvider, child) {
          // Get flights for this airport
          final flights = flightProvider.getFlightsByAirport(airportCode);

          if (flights.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flight,
                    size: Variables.responsiveIconSize(context, 30),
                    color: Colors.white54,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No flights found for $airportCode',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Variables.responsiveFontSize(context, 20),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 15.0,
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: flights.length,
              itemBuilder: (context, index) {
                final flight = flights[index];
                final isFavorite =
                    flightProvider.isFavorite(flight.flightNumber);

                return FlightTile(
                  flight: flight,
                  isFavorite: isFavorite,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FlightInfo(flight: flight),
                      ),
                    );
                  },
                  onFavoriteToggle: (flight) {
                    flightProvider.toggleFavorite(flight.id);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
