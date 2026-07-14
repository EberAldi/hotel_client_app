import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherInfo {
  final double tempC;
  final String condition;
  const WeatherInfo({required this.tempC, required this.condition});
}

class WeatherService {
  // Coordenadas del centro de Oaxaca
  static const _lat = 17.0654;
  static const _lon = -96.7236;

  Future<WeatherInfo?> fetchCurrent() async {
    try {
      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$_lat&longitude=$_lon&current=temperature_2m,weather_code',
      );
      final res = await http.get(uri).timeout(const Duration(seconds: 5));
      if (res.statusCode != 200) return null;

      final data = jsonDecode(res.body);
      final temp = (data['current']['temperature_2m'] as num).toDouble();
      final code = data['current']['weather_code'] as int;

      return WeatherInfo(tempC: temp, condition: _describeCode(code));
    } catch (_) {
      return null;
    }
  }

  String _describeCode(int code) {
    if (code == 0) return 'Despejado';
    if (code <= 3) return 'Parcialmente nublado';
    if (code <= 48) return 'Neblina';
    if (code <= 67) return 'Lluvia ligera';
    if (code <= 82) return 'Lluvia';
    if (code <= 99) return 'Tormenta';
    return 'Templado';
  }
}

final weatherServiceProvider = Provider((ref) => WeatherService());