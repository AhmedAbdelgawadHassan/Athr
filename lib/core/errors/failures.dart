import 'package:dio/dio.dart';

abstract class Failures {
  final String errorMessage;

  const Failures({required this.errorMessage});

  @override
  String toString() => errorMessage;
}

class ServerFailure extends Failures {
  ServerFailure({required super.errorMessage});

  static String _messageFromBody(dynamic data) {
    if (data == null) return 'There was an error , Please try again';
    if (data is String) {
      return data.trim().isEmpty
          ? 'There was an error , Please try again'
          : data.trim();
    }
    if (data is Map) {
      final err = data['error'];
      if (err is Map && err['message'] != null) {
        return err['message'].toString();
      }
      if (data['message'] != null) {
        return data['message'].toString();
      }
    }
    return 'There was an error , Please try again';
  }

  factory ServerFailure.fromDioException(DioException error) {
    String errorMessage = 'there was an error';
    switch (error.type) {
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
        final response = error.response;
        if (response != null) {
          return ServerFailure.fromResponse(
            response.statusCode ?? 0,
            response.data,
          );
        }
        return ServerFailure(
          errorMessage: 'There was an error , Please try again',
        );
      case DioExceptionType.receiveTimeout:
        errorMessage = 'server error';
        break;
      case DioExceptionType.cancel:
      case DioExceptionType.connectionError:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Please check the internet and send again';
        break;
      case DioExceptionType.unknown:
        errorMessage = 'unKnown error';
        break;
    }
    return ServerFailure(errorMessage: errorMessage);
  }

  factory ServerFailure.fromResponse(int statescCode, dynamic json) {
    if (statescCode == 429) {
      return ServerFailure(
        errorMessage:
            'Too many requests. Please wait a moment and try again.',
      );
    }
    if (statescCode >= 400 && statescCode <= 403) {
      return ServerFailure(errorMessage: _messageFromBody(json));
    } else if (statescCode == 404) {
      return ServerFailure(errorMessage: 'Not found , Try again');
    } else if (statescCode == 500) {
      return ServerFailure(errorMessage: 'Server error');
    } else {
      return ServerFailure(
        errorMessage: _messageFromBody(json),
      );
    }
  }
}
