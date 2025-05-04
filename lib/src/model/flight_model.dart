class Flight {
  final String id;
  final String flightNumber;
  final DateTime scheduledDeparture;
  final DateTime scheduledArrival;
  final String originAirport;
  final String destinationAirport;
  final double originLatitude;
  final double originLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final String season;

  Flight({
    required this.id,
    required this.flightNumber,
    required this.scheduledDeparture,
    required this.scheduledArrival,
    required this.originAirport,
    required this.destinationAirport,
    required this.originLatitude,
    required this.originLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.season,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'],
      flightNumber: json['flight_code'],
      scheduledDeparture: DateTime.parse(json['scheduled_dep_timestamp']),
      scheduledArrival: DateTime.parse(json['scheduled_arr_timestamp']),
      originAirport: json['origin_airport'],
      destinationAirport: json['destination_airport'],
      originLatitude: double.parse(json['origin_latitude'].toString()),
      originLongitude: double.parse(json['origin_longitude'].toString()),
      destinationLatitude:
          double.parse(json['destination_latitude'].toString()),
      destinationLongitude:
          double.parse(json['destination_longitude'].toString()),
      season: json['season'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'flight_code': flightNumber,
      'scheduled_dep_timestamp': scheduledDeparture.toIso8601String(),
      'scheduled_arr_timestamp': scheduledArrival.toIso8601String(),
      'origin_airport': originAirport,
      'destination_airport': destinationAirport,
      'origin_latitude': originLatitude,
      'origin_longitude': originLongitude,
      'destination_latitude': destinationLatitude,
      'destination_longitude': destinationLongitude,
      'season': season,
    };
  }
}
