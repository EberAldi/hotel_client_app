import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/review_api.dart';
import '../data/review_models.dart';

final reviewApiProvider = Provider((ref) => ReviewApi());

/// Todas las reseñas aprobadas de habitaciones, agrupadas por objetivoId --
/// una sola llamada de red sirve tanto para el home (rating/conteo por
/// tarjeta) como para el detalle de cada habitación.
final resenasHabitacionesProvider = FutureProvider<Map<String, List<Resena>>>((ref) async {
  final resenas = await ref.read(reviewApiProvider).getResenas(tipoObjetivo: 'HABITACION');
  final Map<String, List<Resena>> agrupadas = {};
  for (final r in resenas) {
    agrupadas.putIfAbsent(r.objetivoId, () => []).add(r);
  }
  return agrupadas;
});
