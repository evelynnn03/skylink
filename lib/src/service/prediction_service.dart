import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionService {
  static const String apiUrl =
      'http://10.0.2.2:5000/predict'; // Android emulator

  static Future<Map<String, dynamic>?> getPrediction(
      Map<String, dynamic> flightData) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(flightData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('SUCCESS: $data');
        return {
          'prediction': data['prediction'],
          'probabilities': data['probabilities'],
          'weather': data['weather'],
        };
      } else {
        print('Error from server: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Prediction error: $e');
      return null;
    }
  }
}
