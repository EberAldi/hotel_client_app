import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/auth/dio_client.dart';
import '../../../core/config/api_config.dart';

class PaymentApi {
  final DioClient _client = DioClient(ApiConfig.paymentBaseUrl);

  /// POST /api/pagos/pagos/ -- crea el pago en estado 'pendiente'.
  Future<Map<String, dynamic>> crearPago({
    required String reservacionId,
    required double monto,
    required String metodo, // 'tarjeta' | 'efectivo' | 'paypal'
  }) async {
    final response = await _client.dio.post('/pagos/', data: {
      'reservacion_id': reservacionId,
      'monto': monto,
      'metodo': metodo,
    });
    return response.data as Map<String, dynamic>;
  }

  /// POST /api/pagos/pagos/{id}/confirmar/ -- única forma legítima de marcar
  /// un pago como 'exitoso' (genera la factura automáticamente).
  Future<Map<String, dynamic>> confirmarPago(String pagoId, {String idTransaccion = ''}) async {
    final response = await _client.dio.post('/pagos/$pagoId/confirmar/', data: {
      'id_transaccion': idTransaccion,
    });
    return response.data as Map<String, dynamic>;
  }
}

final paymentApiProvider = Provider((ref) => PaymentApi());
