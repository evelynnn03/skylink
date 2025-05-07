import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/flight_model.dart';
import '../service/airport_service.dart';

class FlightProvider extends ChangeNotifier {
  List<Flight> _allFlights = [];
  final Set<String> _favoriteFlightIds = {};
  Map<String, List<Flight>> _airportFlights = {};

  List<Flight> get allFlights => _allFlights;

  List<Flight> get favoriteFlights => _allFlights
      .where((flight) => _favoriteFlightIds.contains(flight.id))
      .toList();

  // Get list of unique airports
  List<Map<String, dynamic>> getAllAirports() {
    return _airportFlights.keys.map((airportCode) {
      return {
        'airport_code': airportCode,
        'airport_name': AirportService.getNameFromCode(airportCode),
        'upcoming_flights': _airportFlights[airportCode]?.length ?? 0,
      };
    }).toList()
      ..sort((a, b) => a['airport_name']
          .toString()
          .toLowerCase()
          .compareTo(b['airport_name'].toString().toLowerCase()));
  }

  // Get flights by specific airport code
  List<Flight> getFlightsByAirport(String airportCode) {
    return _airportFlights[airportCode] ?? [];
  }

  bool isFavorite(Flight flight) => _favoriteFlightIds.contains(flight.id);

  void toggleFavorite(Flight flight) {
    if (_favoriteFlightIds.contains(flight.id)) {
      _favoriteFlightIds.remove(flight.id);
    } else {
      _favoriteFlightIds.add(flight.id);
    }
    notifyListeners();
  }

  Future<void> loadFlights() async {
    try {
      final String response =
          await rootBundle.loadString('assets/flight_data.json');
      final List<dynamic> rawData = json.decode(response);

      _allFlights = rawData.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> data = entry.value;
        data['id'] ??= index.toString(); // Ensure unique ID
        return Flight.fromJson(data);
      }).toList();

      _organizeFlightsByAirport();
      notifyListeners();
    } catch (e) {
      print('Error loading flights: $e');
    }
  }

  void _organizeFlightsByAirport() {
    _airportFlights.clear();
    for (var flight in _allFlights) {
      _airportFlights.putIfAbsent(flight.originAirport, () => []).add(flight);
      _airportFlights
          .putIfAbsent(flight.destinationAirport, () => [])
          .add(flight);
    }
  }

  // Search flight by flight number and date
  Flight? searchFlight(String flightNumber, DateTime? date) {
    if (date == null) return null;

    final dateString =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    try {
      return _allFlights.firstWhere(
        (flight) {
          final depDate =
              flight.scheduledDeparture.toIso8601String().split('T')[0];
          final arrDate =
              flight.scheduledArrival.toIso8601String().split('T')[0];

          return flight.flightNumber.toLowerCase() ==
                  flightNumber.toLowerCase() &&
              (depDate == dateString || arrDate == dateString);
        },
      );
    } catch (e) {
      return null;
    }
  }

  List<Flight> getUpcomingFlights(DateTime from) {
    return _allFlights
        .where((flight) => flight.scheduledDeparture.isAfter(from))
        .toList();
  }
}
