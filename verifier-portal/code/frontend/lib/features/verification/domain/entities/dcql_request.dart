import 'package:freezed_annotation/freezed_annotation.dart';

part 'dcql_request.freezed.dart';
part 'dcql_request.g.dart';

@freezed
class DcqlRequest with _$DcqlRequest {
  const factory DcqlRequest({
    required String clientId,
    required String holderChannelDid,
    required String payloadId,
    required Map<String, dynamic> dcqlQuery,
  }) = _DcqlRequest;

  factory DcqlRequest.fromJson(Map<String, dynamic> json) =>
      _$DcqlRequestFromJson(json);
}

@freezed
class DcqlResponse with _$DcqlResponse {
  const factory DcqlResponse({
    required String status,
    required String message,
  }) = _DcqlResponse;

  factory DcqlResponse.fromJson(Map<String, dynamic> json) =>
      _$DcqlResponseFromJson(json);
}
