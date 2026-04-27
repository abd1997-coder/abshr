import 'package:dio/dio.dart';

import '../constants/app_strings.dart';

/// Maps a [DioException] to a short, user-friendly message (Arabic/English via [AppStrings]).
/// Returns `null` when no toast should be shown (e.g. cancelled request).
String? friendlyMessageForDioException(DioException e) {
  if (e.type == DioExceptionType.cancel) return null;
  if (e.requestOptions.extra['skipErrorToast'] == true) return null;

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return AppStrings.errorNetworkTimeout;

    case DioExceptionType.connectionError:
      return AppStrings.errorNoInternet;

    case DioExceptionType.badCertificate:
      return AppStrings.errorSecureConnection;

    case DioExceptionType.badResponse:
      final code = e.response?.statusCode;
      if (code != null) {
        if (code >= 500) return AppStrings.errorServerUnavailable;
        if (code == 401) return AppStrings.errorUnauthorized;
        if (code == 403) return AppStrings.errorForbidden;
        if (code == 404) return AppStrings.errorNotFound;
        if (code == 429) return AppStrings.errorTooManyRequests;
        if (code >= 400) return AppStrings.errorRequestFailed;
      }
      return AppStrings.errorSomethingWrong;

    case DioExceptionType.unknown:
      final raw = e.error?.toString() ?? '';
      if (raw.contains('SocketException') ||
          raw.contains('Failed host lookup') ||
          raw.contains('Network is unreachable')) {
        return AppStrings.errorNoInternet;
      }
      return AppStrings.errorSomethingWrong;

    case DioExceptionType.cancel:
      return null;
  }
}
