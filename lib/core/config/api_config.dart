class ApiConfig {
  // localhost porque el navegador/app corre fuera de la red interna de Docker
  static const String authBaseUrl = 'http://localhost:3001/api';
  static const String catalogBaseUrl = 'http://localhost:3002/api';
  static const String reservationBaseUrl = 'http://localhost:3003/api';
  static const String paymentBaseUrl = 'http://localhost:3004/api';
  static const String reviewBaseUrl = 'http://localhost:3005/api';
  static const String assistantBaseUrl = 'http://localhost:3006/api';
}