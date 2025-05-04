import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AirportService {
  static Map<String, dynamic> _airportData = {};
  static bool _isInitialized = false;

  static Future<void> initialize(BuildContext context) async {
    if (_isInitialized) return;

    try {
      final String jsonData =
          await rootBundle.loadString('assets/airport.json');

      // Parse the JSON data properly based on its structure
      final List<dynamic> airports = json.decode(jsonData);

      // Convert the list to a map with IATA code as the key
      _airportData = {};
      for (var airport in airports) {
        if (airport['iata'] != null && airport['iata'].toString().isNotEmpty) {
          _airportData[airport['iata']] = airport;
        }
      }

      _isInitialized = true;
      print('Airport data initialized with ${_airportData.length} airports');
    } catch (e) {
      print('Error loading airport data: $e');
    }
  }

  static String getCityFromCode(String code) {
    if (!_isInitialized) return code;
    print("Airport region: ${_airportData[code]?['region_name']}");

    return _airportData[code]?['region_name'] ?? code;
  }

  static String getNameFromCode(String code) {
    if (!_isInitialized) return code;
    print("Airport name: ${_airportData[code]?['airport']}");

    return _airportData[code]?['airport'] ?? code;
  }

  // Helper method to check if initialization is complete
  static bool isInitialized() {
    return _isInitialized;
  }
}
