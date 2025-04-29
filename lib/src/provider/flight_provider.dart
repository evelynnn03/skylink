import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../service/airport_service.dart';

class FlightProvider extends ChangeNotifier {
  List<dynamic> _allFlights = [];
  final Set<String> _favoriteFlightIds = {};
  Map<String, List<dynamic>> _airportFlights = {};

  List<dynamic> get allFlights => _allFlights;
  List<dynamic> get favoriteFlights => _allFlights
      .where((flight) => _favoriteFlightIds.contains(flight['id']))
      .toList();

  List<Map<String, dynamic>> getAllAirports() {
    List<Map<String, dynamic>> airports =
        _airportFlights.keys.map((airportCode) {
      return {
        'airport_code': airportCode,
        'airport_name': AirportService.getNameFromCode(airportCode),
        'upcoming_flights': _airportFlights[airportCode]?.length ?? 0,
      };
    }).toList();

    // Sort airports by name alphabetically
    airports
        .sort((a, b) => a['airport_name'].toString().toLowerCase().compareTo(
              b['airport_name'].toString().toLowerCase(),
            ));

    return airports;
  }

  // Get flights by airport
  List<dynamic> getFlightsByAirport(String airportCode) {
    return _airportFlights[airportCode] ?? [];
  }

  // Check if a flight is favorited
  bool isFavorite(Map<String, dynamic> flight) {
    return _favoriteFlightIds.contains(flight['id']);
  }

  // Toggle favorite status
  void toggleFavorite(Map<String, dynamic> flight) {
    if (_favoriteFlightIds.contains(flight['id'])) {
      _favoriteFlightIds.remove(flight['id']);
    } else {
      _favoriteFlightIds.add(flight['id']);
    }
    notifyListeners();
  }

  // Initialize and load flights
  Future<void> loadFlights() async {
    try {
      final String response =
          await rootBundle.loadString('assets/flight_data.json');
      final List<dynamic> data = json.decode(response);

      // Ensure each flight has an id
      for (var i = 0; i < data.length; i++) {
        if (!data[i].containsKey('id')) {
          data[i]['id'] = i.toString();
        }
      }

      _allFlights = data;

      // Organize flights by airport
      _organizeFlightsByAirport();

      notifyListeners();
    } catch (e) {
      print('Error loading flights: $e');
    }
  }

  // Organize flights by airport
  void _organizeFlightsByAirport() {
    _airportFlights = {};

    for (var flight in _allFlights) {
      String departureCode = flight['departure'];
      String arrivalCode = flight['arrival'];

      // Add to departure airport list
      _airportFlights.putIfAbsent(departureCode, () => []).add(flight);

      // Add to arrival airport list
      _airportFlights.putIfAbsent(arrivalCode, () => []).add(flight);
    }
  }

  Map<String, dynamic>? searchFlight(String flightNumber, DateTime? date) {
    if (date == null) return null;

    // Format the date to match the API format (YYYY-MM-DD)
    final dateString =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    return _allFlights.firstWhere(
      (flight) {
        // Extract only the date (YYYY-MM-DD) from the flight's scheduled times
        String departureDate = flight['scheduled_departure'].split('T')[0];
        String arrivalDate = flight['scheduled_arrival'].split('T')[0];

        return flight['flight_no'] == flightNumber &&
            (departureDate == dateString || arrivalDate == dateString);
      },
      orElse: () => null,
    );
  }
}
