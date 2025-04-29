import 'package:flight_delay_app/src/constants/variables.dart';
import 'package:flight_delay_app/src/provider/flight_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/airport_service.dart';
import 'airport_flights.dart';

class Airports extends StatefulWidget {
  const Airports({super.key});

  @override
  State<Airports> createState() => _AirportsState();
}

class _AirportsState extends State<Airports> {
  @override
  void initState() {
    super.initState();
    AirportService.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    final flightProvider = Provider.of<FlightProvider>(context, listen: false);
    final airports = flightProvider.getAllAirports();
    final screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.18;

    return Scaffold(
      backgroundColor: Variables.greyBG,
      appBar: AppBar(
        backgroundColor: Variables.greyBG,
        title: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Airports',
            style: TextStyle(
              fontSize: Variables.responsiveFontSize(context, 30),
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: airports.length,
          itemBuilder: (context, index) {
            final airport = airports[index];

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
                margin: const EdgeInsets.all(10.0),
                height: containerHeight,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 235, 235),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 0.5,
                      blurRadius: 8,
                      offset: Offset(-5, -3),
                    ),

                    // Grey shadow on the bottom right for contrast
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 0.5,
                      blurRadius: 8,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 120,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        child: Image.asset(
                          'assets/images/${airport['airport_code']}.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              airport['airport_name'],
                              style: TextStyle(
                                fontSize:
                                    Variables.responsiveFontSize(context, 18),
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              airport['airport_code'],
                              style: TextStyle(
                                color: Variables.textLabel,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    Variables.responsiveFontSize(context, 16),
                              ),
                            ),
                            Text(
                              'Upcoming Flights: ${flightProvider.getFlightsByAirport(airport['airport_code']).length}',
                              style: TextStyle(
                                color: Variables.textLabel,
                                fontSize:
                                    Variables.responsiveFontSize(context, 16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
