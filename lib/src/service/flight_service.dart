import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/flight_model.dart';

class FlightService {
  static Future<List<Flight>> loadFlightsFromAsset() async {
    try {
      final String response = await rootBundle.loadString('assets/mock_flights.json');
      final List<dynamic> data = json.decode(response);

      return data.map((json) => Flight.fromJson(json)).toList();
    } catch (e) {
      print('Error loading flight data: $e');
      return [];
    }
  }
}
