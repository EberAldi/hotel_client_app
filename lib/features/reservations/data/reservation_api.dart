import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/auth/dio_client.dart';
import '../../../core/config/api_config.dart';

class ReservationApi {
  final DioClient _client = DioClient(ApiConfig.reservationBaseUrl);
  static final _fecha = DateFormat('yyyy-MM-dd');

  /// cliente_id lo asigna el servidor a partir del JWT. La reservación queda
  /// en estado 'draft'/'pendiente_pago' -- el cobro es un paso aparte que
  /// payment-service todavía no expone.
  Future<Map<String, dynamic>> crearReservacion({
    required String habitacionId,
    required DateTime fechaEntrada,
    required DateTime fechaSalida,
    required double precioTotal,
  }) async {
    final response = await _client.dio.post('/reservaciones/', data: {
      'habitacion_id': habitacionId,
      'fecha_entrada': _fecha.format(fechaEntrada),
      'fecha_salida': _fecha.format(fechaSalida),
      'precio_total': precioTotal,
      'estado': 'pendiente_pago',
    });
    return response.data as Map<String, dynamic>;
  }
}

final reservationApiProvider = Provider((ref) => ReservationApi());
