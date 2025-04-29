import 'package:flight_delay_app/src/constants/variables.dart';
import 'package:flight_delay_app/src/widgets/flight_list_tiles.dart';
import 'package:flight_delay_app/src/widgets/recommended_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../provider/flight_provider.dart';
import '../service/airport_service.dart';
import '../widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Wait for the airport data to be loaded before building the UI
    AirportService.initialize(context).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final flightProvider = Provider.of<FlightProvider>(context);
    final airports = flightProvider.getAllAirports();
    print("Fetched Airports: $airports");

    final screenHeight = MediaQuery.of(context).size.height;

    // Ensure flights are loaded
    if (flightProvider.allFlights.isEmpty) {
      flightProvider.loadFlights();
    }

    double smallSizedBoxHeight(height) => height < 600 ? 8 : 10;
    double medSizedBoxHeight(height) => height < 600 ? 15 : 20;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 167, 167),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: screenHeight * 0.6,
              width: double.infinity,
              child: Image.asset(
                'assets/images/window1.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/skylink logo white.svg',
                    height: 130,
                    color: Colors.white,
                  ),
                  SizedBox(height: 45),
                  const Center(
                    child: Text(
                      'connecting you to real-time flight updates',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.35),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 20.0,
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          FlightSearchBar(
                            onSearch: (flightNumber, date) {
                              print(
                                  'DEBUG: Inside onSearch callback with flight: $flightNumber, date: $date');
                              // Access the FlightProvider
                              final flightProvider =
                                  Provider.of<FlightProvider>(context,
                                      listen: false);
                              // Return the matching flight data
                              return flightProvider.searchFlight(
                                  flightNumber, date);
                            },
                          ),
                          SizedBox(height: smallSizedBoxHeight(screenHeight)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Recommended',
                              style: TextStyle(
                                fontSize:
                                    Variables.responsiveFontSize(context, 25),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: smallSizedBoxHeight(screenHeight)),

                          const RecommendedTiles(),

                          SizedBox(height: medSizedBoxHeight(screenHeight)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Upcoming Flights',
                              style: TextStyle(
                                fontSize:
                                    Variables.responsiveFontSize(context, 25),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: smallSizedBoxHeight(screenHeight)),

                          // Display favorite flights
                          const FlightListTiles(
                            showFavoritesOnly: true,
                            title: '',
                            maxItems: 3, // Limit to 3 items
                            showScrollable: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
