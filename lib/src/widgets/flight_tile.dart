import 'package:flutter/material.dart';
import 'dart:math';
import '../constants/variables.dart';
import '../model/flight_model.dart';
import '../service/airport_service.dart';

class FlightTile extends StatelessWidget {
  final Flight flight;
  final VoidCallback onTap;
  final bool isFavorite;
  final Function(Flight) onFavoriteToggle;

  const FlightTile({
    Key? key,
    required this.flight,
    required this.onTap,
    this.isFavorite = false,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double tileHeight = screenHeight * 0.2;
    double sizedBoxHeight(height) => height < 600 ? 8 : 10;

    String departureCity = AirportService.getCityFromCode(flight.originAirport);
    String arrivalCity = AirportService.getCityFromCode(flight.destinationAirport);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: tileHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          flight.flightNumber,
                          style: TextStyle(
                            fontSize: Variables.responsiveFontSize(context, 22),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => onFavoriteToggle(flight),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.white,
                            size: Variables.responsiveIconSize(context, 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sizedBoxHeight(screenHeight)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _flightColumn(
                        context,
                        flight.originAirport,
                        departureCity,
                        flight.scheduledDeparture,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Transform.rotate(
                          angle: 90 * (pi / 180),
                          child: Icon(
                            Icons.flight,
                            size: Variables.responsiveIconSize(context, 40),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _flightColumn(
                        context,
                        flight.destinationAirport,
                        arrivalCity,
                        flight.scheduledArrival,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _flightColumn(
      BuildContext context, String code, String city, DateTime time) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          code,
          style: TextStyle(
            fontSize: Variables.responsiveFontSize(context, 40),
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1,
          ),
        ),
        Text(
          city,
          style: TextStyle(
            fontSize: Variables.responsiveFontSize(context, 16),
            color: Colors.white,
            height: 1,
          ),
        ),
        Text(
          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
          style: TextStyle(
            fontSize: Variables.responsiveFontSize(context, 16),
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
