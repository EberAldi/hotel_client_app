class ApiConfig {
  // Todo pasa por el mismo dominio en producción (nginx enruta internamente
  // a cada microservicio); no se usan puertos, a diferencia del entorno local.
  static const String _cloudBaseUrl = 'https://hotel-microservicios.duckdns.org';

  static const String authBaseUrl = '$_cloudBaseUrl/api/auth';
  static const String catalogBaseUrl = '$_cloudBaseUrl/api/catalogo';
  static const String reservationBaseUrl = '$_cloudBaseUrl/api/reservaciones';
  static const String paymentBaseUrl = '$_cloudBaseUrl/api/pagos';
  static const String reviewBaseUrl = '$_cloudBaseUrl/api/resenas';
  static const String assistantBaseUrl = '$_cloudBaseUrl/api/asistente';
}