import '../../../core/auth/dio_client.dart';
import '../../../core/config/api_config.dart';
import 'catalog_models.dart';

class CatalogApi {
  final DioClient _client = DioClient(ApiConfig.catalogBaseUrl);

  Future<List<Habitacion>> getHabitaciones({String? estado}) async {
    final response = await _client.dio.get('/habitaciones/', queryParameters: {
      if (estado != null) 'estado': estado,
    });
    return (response.data as List).map((e) => Habitacion.fromJson(e)).toList();
  }

  Future<Habitacion> getHabitacion(String id) async {
    final response = await _client.dio.get('/habitaciones/$id/');
    return Habitacion.fromJson(response.data);
  }

  Future<TipoHabitacion> getTipoHabitacion(String tipoId) async {
    final response = await _client.dio.get('/tipos-habitacion/$tipoId/');
    return TipoHabitacion.fromJson(response.data);
  }

  /// Trae TODAS las imágenes en una sola llamada (el catálogo demo es
  /// pequeño); la UI las agrupa por habitación en vez de pedir una por una.
  Future<List<ImagenHabitacion>> getImagenes() async {
    final response = await _client.dio.get('/imagenes-habitacion/');
    return (response.data as List).map((e) => ImagenHabitacion.fromJson(e)).toList();
  }
}
