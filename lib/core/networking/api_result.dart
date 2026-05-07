import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dio/dio.dart';

part 'api_result.freezed.dart';

String mapErrorToUserMessage(Object error) {
  if (error is DioException) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message']?.toString();
      if (message != null && message.trim().isNotEmpty) {
        return message;
      }
      final errors = responseData['errors'];
      if (errors is List && errors.isNotEmpty) {
        final firstError = errors.first?.toString();
        if (firstError != null && firstError.trim().isNotEmpty) {
          return firstError;
        }
      }
    }

    switch (error.response?.statusCode) {
      case 400:
        return 'Please check your input and try again.';
      case 401:
        return 'Your session expired. Please login again.';
      case 403:
        return 'You are not allowed to do this action.';
      case 404:
        return 'Requested data was not found.';
      case 409:
        return 'This action conflicts with existing data.';
      case 422:
        return 'Some fields are invalid. Please review your input.';
      case 500:
      case 502:
      case 503:
        return 'Server is busy now. Please try again in a moment.';
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Please try again.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    }
  }

  final text = error.toString();
  if (text.contains('DioException')) {
    return 'Something went wrong. Please try again.';
  }
  return text;
}

@freezed
class ApiResult <T > with _$ApiResult <T>{
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(String message) = Failure<T>;
}