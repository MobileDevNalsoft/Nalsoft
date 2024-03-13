import 'package:dio/dio.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        // ignore: deprecated_member_use
        if (error is DioError) {
          switch (error.type) {
            // ignore: deprecated_member_use
            case DioErrorType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            // ignore: deprecated_member_use
            case DioErrorType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            // ignore: deprecated_member_use
            case DioErrorType.unknown:
              errorDescription =
                  "Connection to API server failed due to internet connection";
              break;
            // ignore: deprecated_member_use
            case DioErrorType.receiveTimeout:
              errorDescription =
                  "Receive timeout in connection with API server";
              break;
            // ignore: deprecated_member_use
            case DioErrorType.badResponse:
              break;
            // ignore: deprecated_member_use
            case DioErrorType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
            case DioExceptionType.badCertificate:
            case DioExceptionType.connectionError:
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    }
    return errorDescription;
  }
}
