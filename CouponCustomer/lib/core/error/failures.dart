// lib/core/error/failures.dart

/// Sealed failure hierarchy.
/// All usecases and repositories return Either<Failure, T> — never throw.
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure()
      : super('No internet connection. Please check and try again.');
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({
    this.statusCode,
    String message = 'Something went wrong. Please try again.',
  }) : super(message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure()
      : super('Session expired. Please login again.');
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure() : super('Failed to load cached data.');
}

class PaymentFailure extends Failure {
  final String? code;
  const PaymentFailure({this.code, String message = 'Payment failed. Please try again.'})
      : super(message);
}

class QrFailure extends Failure {
  const QrFailure() : super('Invalid or tampered QR code.');
}
