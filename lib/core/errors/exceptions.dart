// lib/core/errors/exceptions.dart

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class NoInternetException implements Exception {
  const NoInternetException();

  @override
  String toString() => 'Brak połączenia z internetem.';
}
