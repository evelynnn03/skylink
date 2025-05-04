import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../model/flight_model.dart';

Future<Map<String, dynamic>?> fetchWeatherData(
  Flight flight,
) async {
  const baseUrl =
      'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline';
  const apiKey = 'TVSZYCSMQMFHVNRG96DWAJYCE';
  final lat = flight.originLatitude;
  final lon = flight.originLongitude;
  DateTime dep = flight.scheduledDeparture;
  final timestamp = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dep);

  final uri =
      Uri.parse('$baseUrl/$lat,$lon/$timestamp').replace(queryParameters: {
    'key': apiKey,
    'include': 'current',
    'unitGroup': 'metric',
    'elements':
        'temp,conditions,dew,precip,windspeed,windgust,winddir,visibility,cloudcover,humidity,pressure',
  });

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final current = data['currentConditions'];
      if (current != null) {
        return {
          'depDatetime': timestamp,
          'temperature': current['temp'],
          'conditions': current['conditions'],
          'dew_point': current['dew'],
          'precipitation': current['precip'],
          'wind_speed': current['windspeed'],
          'wind_gust': current['windgust'],
          'wind_direction': current['winddir'],
          'visibility': current['visibility'],
          'cloud_cover': current['cloudcover'],
          'humidity': current['humidity'],
          'pressure': current['pressure'],
        };
      } else {
        print('Weather API error: ${response.statusCode}');
      }
    }
  } catch (e) {
    print('Error fetching weather: $e');
  }
  return null;
}
