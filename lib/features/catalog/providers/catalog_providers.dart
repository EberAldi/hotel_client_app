import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/catalog_api.dart';
import '../data/catalog_models.dart';

final catalogApiProvider = Provider((ref) => CatalogApi());

final habitacionesProvider = FutureProvider<List<Habitacion>>((ref) {
  return ref.read(catalogApiProvider).getHabitaciones(estado: 'disponible');
});

final habitacionPorIdProvider = FutureProvider.family<Habitacion, String>((ref, id) {
  return ref.read(catalogApiProvider).getHabitacion(id);
});

final tipoHabitacionProvider = FutureProvider.family<TipoHabitacion, String>((ref, tipoId) {
  return ref.read(catalogApiProvider).getTipoHabitacion(tipoId);
});

/// Agrupadas por habitacionId -- una sola llamada de red para todo el catálogo.
final imagenesPorHabitacionProvider = FutureProvider<Map<String, List<ImagenHabitacion>>>((ref) async {
  final imagenes = await ref.read(catalogApiProvider).getImagenes();
  final Map<String, List<ImagenHabitacion>> agrupadas = {};
  for (final img in imagenes) {
    agrupadas.putIfAbsent(img.habitacionId, () => []).add(img);
  }
  return agrupadas;
});
