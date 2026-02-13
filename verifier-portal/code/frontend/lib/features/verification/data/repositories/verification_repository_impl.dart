import '../../domain/entities/api_response.dart';
import '../../domain/entities/dcql_request.dart';
import '../../domain/entities/verify_request.dart';
import '../../domain/repositories/verification_repository.dart';
import '../api/verification_api_client.dart';

class VerificationRepositoryImpl implements VerificationRepository {
  final VerificationApiClient _apiClient;

  VerificationRepositoryImpl(this._apiClient);

  @override
  Future<DcqlResponse> sendDcqlRequest(DcqlRequest request) async {
    return await _apiClient.sendDcqlRequest(request);
  }

  @override
  Future<ApiResponse> stopConnection() async {
    return await _apiClient.stopConnection();
  }

  @override
  Future<ApiResponse> restart() async {
    return await _apiClient.restart();
  }

  @override
  Future<VerifyResponse> verifyCredential(VerifyRequest request) async {
    return await _apiClient.verifyCredential(request);
  }

  @override
  Future<Map<String, dynamic>> getOobClient() async {
    return await _apiClient.getOobClient();
  }
}
