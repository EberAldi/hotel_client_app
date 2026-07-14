import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/weather_service.dart';

final weatherProvider = FutureProvider((ref) => ref.read(weatherServiceProvider).fetchCurrent());

/// Simula lo que el microservicio de IA generaría dado el clima real.
/// Cuando el servicio 'assistant' exista, esto se reemplaza por una
/// llamada real con el clima como parte del prompt.
String weatherRecommendation(WeatherInfo weather) {
  if (weather.condition.contains('Lluvia') || weather.condition.contains('Tormenta')) {
    return 'Con este clima, el Museo de las Culturas de Oaxaca o un chocolate '
        'caliente en el patio del hotel son buena opción hoy.';
  }
  if (weather.tempC >= 26) {
    return 'Día caluroso — ideal para un mezcal con hielo en una terraza del centro '
        'o una visita temprano a Monte Albán antes de que apriete el sol.';
  }
  return 'Clima perfecto para caminar el centro histórico: Santo Domingo, '
      'el Zócalo y los mercados están a poca distancia del hotel.';
}