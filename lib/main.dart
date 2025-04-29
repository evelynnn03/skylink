import 'package:flight_delay_app/src/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/provider/flight_provider.dart';
import 'src/service/airport_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (ctx) => FlightProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize flights on app startup
    Future.delayed(Duration.zero, () {
      Provider.of<FlightProvider>(context, listen: false).loadFlights();
    });

    AirportService.initialize(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flight App',
      theme: ThemeData(
        fontFamily: 'Proxima Nova',
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 150, 182, 255)),
        useMaterial3: true,
      ),
      home: const MyBottomNavBar(),
    );
  }
}
