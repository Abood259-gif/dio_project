

sealed class AppException implements Exception {

final String message;
final int? statusCode;

AppException(this.message , {this.statusCode});

@override
  String toString() => message;

}

class NetworkExcption extends AppException {
  NetworkExcption([super.message = 'Network error occurred. Please check your internet connection.']);
}

class TimeoutException extends AppException {
  TimeoutException([super.message = 'Request timed out. Please try again later.']);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(
    [super.message = 'Unauthorized access. Please check your credentials.']):super(statusCode: 401);
}

class ServerException extends AppException {
  ServerException([super.message = 'Server error occurred. Please try again later.']):super(statusCode: 500);
}

class UnknownException extends AppException {
  UnknownException([super.message = 'An unknown error occurred. Please try again later.']);
}

