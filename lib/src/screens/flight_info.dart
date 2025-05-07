import 'package:flight_delay_app/src/constants/variables.dart';
import 'package:flight_delay_app/src/widgets/flight_ticket_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

import '../model/flight_model.dart';
import '../service/airport_service.dart';
import '../service/prediction_service.dart';
// import 'package:lottie/lottie.dart';

class FlightInfo extends StatefulWidget {
  final Flight flight;
  const FlightInfo({super.key, required this.flight});

  @override
  State<FlightInfo> createState() => _FlightInfoState();
}

class _FlightInfoState extends State<FlightInfo> {
  String _getWeatherText(int condition) {
    Map<int, String> weatherMapping = {
      0: 'Clear',
      1: 'Overcast',
      2: 'Partially Cloudy',
      3: 'Rain, Overcast',
      4: 'Rain, Partially Cloudy',
      5: 'Snow, Overcast',
    };
    return weatherMapping[condition] ?? 'Unknown';
  }

  String _getFlightStatus() {
    // Use the prediction result as the flight status, fallback to "Loading..." if not available
    if (_loadingPrediction) return "Loading...";
    return _prediction ?? "Unknown";
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "ON-TIME":
        return Colors.green;
      case "DELAYED":
        return Colors.red;
      case "CANCELLED":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  int condition = 0;
  Map<String, dynamic>? _weather;
  String? _prediction;
  bool _loadingPrediction = true;

  Future<void> _loadPredictionAndWeather() async {
    // Prepare flight data as a map for the API
    final flight = widget.flight;
    final flightData = {
      'flight_code': flight.flightNumber,
      'scheduled_dep_timestamp': flight.scheduledDeparture.toIso8601String(),
      'scheduled_arr_timestamp': flight.scheduledArrival.toIso8601String(),
      'origin_airport': flight.originAirport,
      'destination_airport': flight.destinationAirport,
      'origin_latitude': flight.originLatitude,
      'origin_longitude': flight.originLongitude,
      'destination_latitude': flight.destinationLatitude,
      'destination_longitude': flight.destinationLongitude,
      'distance': flight.distance,
      'season': flight.season,
    };

    final result = await PredictionService.getPrediction(flightData);
    setState(() {
      if (result != null) {
        _prediction = result['prediction']?.toString();
        _weather = result['weather'];

        // Optionally set condition if your weather data provides it
        if (_weather != null && _weather!['condition'] != null) {
          condition = _weather!['condition'];
        }
      }
      _loadingPrediction = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPredictionAndWeather();
  }

  @override
  Widget build(BuildContext context) {
    // Parse the flight data
    final flightData = widget.flight;
    final flightNo = flightData.flightNumber;
    final departure = flightData.originAirport;
    final arrival = flightData.destinationAirport;
    final flightStatus = _getFlightStatus();

    // Parse date and time
    DateTime scheduledDeparture = flightData.scheduledDeparture;
    DateTime scheduledArrival = flightData.scheduledArrival;

    // Format date and time strings
    String departureDate =
        "${scheduledDeparture.day}/${scheduledDeparture.month}/${scheduledDeparture.year}";
    String departureTime =
        "${scheduledDeparture.hour.toString().padLeft(2, '0')}:${scheduledDeparture.minute.toString().padLeft(2, '0')}";
    String arrivalTime =
        "${scheduledArrival.hour.toString().padLeft(2, '0')}:${scheduledArrival.minute.toString().padLeft(2, '0')}";

    // Calculate duration
    Duration flightDuration = scheduledArrival.difference(scheduledDeparture);
    String durationText =
        "${flightDuration.inHours}h ${flightDuration.inMinutes % 60}m";

    String departureCity = AirportService.getCityFromCode(departure);
    String arrivalCity = AirportService.getCityFromCode(arrival);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double containerHeight = screenHeight * 0.68;
    double medSizedBoxHeight(height) => height < 600 ? 15 : 20;

    return Scaffold(
      backgroundColor: Variables.greyBG,
      appBar: AppBar(
        backgroundColor: Variables.greyBG,
        title: Text(
          'Flight Info',
          style: TextStyle(
            fontSize: Variables.responsiveFontSize(context, 30),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Variables.backButton(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 15.0,
        ),
        child: Container(
          height: screenHeight * 0.75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 3,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.07,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Variables.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      flightNo,
                      style: TextStyle(
                        fontSize: Variables.responsiveFontSize(context, 30),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    Text(
                      departureDate,
                      style: TextStyle(
                        fontSize: Variables.responsiveFontSize(context, 30),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ClipPath(
                clipper: FlightTicketClipper(),
                child: Container(
                  padding: const EdgeInsets.all(30.0),
                  height: containerHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FLIGHT AIRPORT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            departure,
                            style: TextStyle(
                              fontSize:
                                  Variables.responsiveFontSize(context, 48),
                              fontWeight: FontWeight.bold,
                              color: Variables.primaryColor,
                            ),
                          ),
                          Transform.rotate(
                            angle:
                                90 * (pi / 180), // Convert degrees to radians
                            child: Icon(
                              Icons.flight,
                              size: Variables.responsiveIconSize(context, 40),
                              color: Variables.primaryColor,
                            ),
                          ),
                          Text(
                            arrival,
                            style: TextStyle(
                              fontSize:
                                  Variables.responsiveFontSize(context, 48),
                              fontWeight: FontWeight.bold,
                              color: Variables.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            departureCity,
                            style: TextStyle(
                              color: Variables.textLabel,
                              fontSize:
                                  Variables.responsiveFontSize(context, 18),
                              fontWeight: FontWeight.bold,
                              height: 0.05,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            arrivalCity,
                            style: TextStyle(
                              color: Variables.textLabel,
                              fontSize:
                                  Variables.responsiveFontSize(context, 18),
                              fontWeight: FontWeight.bold,
                              height: 0.05,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: medSizedBoxHeight(screenHeight)),

                      // DEPARTURE & ARRIVAL TIME (SCHEDULED)
                      SizedBox(
                        height: containerHeight * 0.3,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    departureTime,
                                    style: TextStyle(
                                      fontSize: Variables.responsiveFontSize(
                                          context, 40),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    arrivalTime,
                                    style: TextStyle(
                                      fontSize: Variables.responsiveFontSize(
                                          context, 40),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // SVG curve
                            Positioned(
                              top: 70,
                              left: 0,
                              right: 0,
                              child: SvgPicture.asset(
                                'assets/images/duration curve.svg',
                                width: double.infinity,
                                height: 80,
                              ),
                            ),

                            Positioned(
                              top: 70,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(flightStatus)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    flightStatus,
                                    style: TextStyle(
                                      color: _getStatusColor(flightStatus),
                                      fontWeight: FontWeight.bold,
                                      fontSize: Variables.responsiveFontSize(
                                          context, 18),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Duration text in the center with clock icon
                            Positioned(
                              bottom: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: Variables.responsiveIconSize(
                                          context, 16),
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      durationText,
                                      style: TextStyle(
                                        fontSize: Variables.responsiveFontSize(
                                            context, 18),
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

                      SizedBox(height: medSizedBoxHeight(screenHeight)),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                        indent: 8,
                        endIndent: 8,
                      ),
                      SizedBox(height: medSizedBoxHeight(screenHeight)),

                      // WEATHER SECTION
                      Text(
                        'Weather',
                        style: TextStyle(
                          fontSize: Variables.responsiveFontSize(context, 30),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: _loadingPrediction
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : _weather == null
                                ? Center(
                                    child: Text(
                                      'Unable to load weather data',
                                      style: TextStyle(
                                        fontSize: Variables.responsiveFontSize(
                                            context, 10),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      // if (condition == 0)
                                      //   // Lottie.asset(
                                      //   //   'assets/animations/overcast.json',
                                      //   //   width: 100,
                                      //   //   height: 100,
                                      //   //   fit: BoxFit.cover,
                                      //   // )
                                      //   Icon(
                                      //     Icons.cloud,
                                      //     color: Variables.primaryColor,
                                      //     size: Variables.responsiveIconSize(
                                      //         context, 80),
                                      //   )
                                      if (_weather!['conditions'] == 0)
                                        Icon(
                                          Icons.wb_sunny,
                                          color: Colors.amber,
                                          size: Variables.responsiveIconSize(
                                              context, 80),
                                        )
                                      else if (_weather!['conditions'] == 1)
                                        Icon(
                                          Icons.cloud,
                                          color: Colors.blueGrey,
                                          size: Variables.responsiveIconSize(
                                              context, 80),
                                        )
                                      else if (_weather!['conditions'] == 2)
                                        Icon(
                                          Icons.cloud_queue,
                                          color: Colors.lightBlue,
                                          size: Variables.responsiveIconSize(
                                              context, 80),
                                        )
                                      else if (_weather!['conditions'] == 3 ||
                                          _weather!['conditions'] == 4)
                                        Icon(
                                          Icons.grain,
                                          color: Colors.blue,
                                          size: Variables.responsiveIconSize(
                                              context, 80),
                                        )
                                      else if (_weather!['conditions'] == 5)
                                        Icon(
                                          Icons.ac_unit,
                                          color: Colors.lightBlueAccent,
                                          size: Variables.responsiveIconSize(
                                              context, 80),
                                        )
                                      else
                                        Text(
                                          'Weather: ${_getWeatherText(condition)}', // Fallback Text
                                          style: TextStyle(
                                            fontSize:
                                                Variables.responsiveFontSize(
                                                    context, 20),
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Wind Speed',
                                                style: TextStyle(
                                                  fontSize: Variables
                                                      .responsiveFontSize(
                                                          context, 18),
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                '${_weather!['wind_speed']} mph',
                                                style: TextStyle(
                                                  fontSize: Variables
                                                      .responsiveFontSize(
                                                          context, 20),
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: medSizedBoxHeight(
                                                  screenHeight)),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Visibility',
                                                style: TextStyle(
                                                  fontSize: Variables
                                                      .responsiveFontSize(
                                                          context, 18),
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                '${_weather!['visibility']} miles',
                                                style: TextStyle(
                                                  fontSize: Variables
                                                      .responsiveFontSize(
                                                          context, 20),
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
