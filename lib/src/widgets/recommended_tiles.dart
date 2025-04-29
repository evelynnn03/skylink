import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/variables.dart';
import '../provider/flight_provider.dart';
import '../screens/airport_flights.dart';

class RecommendedTiles extends StatelessWidget {
  const RecommendedTiles({super.key});

  @override
  Widget build(BuildContext context) {
    final flightProvider = Provider.of<FlightProvider>(context);
    final airports = flightProvider.getAllAirports();
    // Sort airports by the number of upcoming flights
    final sortedAirports = List.from(airports)
      ..sort((a, b) => flightProvider
          .getFlightsByAirport(b['airport_code'])
          .length
          .compareTo(
              flightProvider.getFlightsByAirport(a['airport_code']).length));

    // Take the top 4 airports
    final topAirports = sortedAirports.take(4).toList();

    final screenHeight = MediaQuery.of(context).size.height;
    double recContainerHeight = screenHeight * 0.18;
    double recContainerWidth = recContainerHeight * 0.9;

    return SizedBox(
      height: recContainerHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: topAirports.length,
        itemBuilder: (context, index) {
          final airport = topAirports[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AirportFlights(
                    airportCode: airport['airport_code'],
                    airportName: airport['airport_name'],
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/${airport['airport_code']}.jpg',
                          width: recContainerWidth,
                          height: recContainerHeight,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: recContainerWidth,
                              height: recContainerHeight,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Colors.black87,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      airport['airport_code'],
                      style: TextStyle(
                        fontSize: Variables.responsiveFontSize(context, 20),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
