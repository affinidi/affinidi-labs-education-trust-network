import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_request.freezed.dart';
part 'verify_request.g.dart';

@freezed
class VerifyRequest with _$VerifyRequest {
  const factory VerifyRequest({required String data}) = _VerifyRequest;

  factory VerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyRequestFromJson(json);
}

@freezed
class VerifyResponse with _$VerifyResponse {
  const factory VerifyResponse({
    required bool isValid,
    required List<String> errors,
    required List<String> warnings,
  }) = _VerifyResponse;

  factory VerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyResponseFromJson(json);
}
