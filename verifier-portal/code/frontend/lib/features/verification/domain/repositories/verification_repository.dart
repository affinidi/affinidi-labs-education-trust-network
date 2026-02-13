import '../entities/api_response.dart';
import '../entities/dcql_request.dart';
import '../entities/verify_request.dart';

abstract class VerificationRepository {
  /// Send DCQL request to holder
  /// POST /api/dcql/request
  Future<DcqlResponse> sendDcqlRequest(DcqlRequest request);

  /// Stop connection pool
  /// POST /api/connection-stop
  Future<ApiResponse> stopConnection();

  /// Restart service
  /// POST /api/restart
  Future<ApiResponse> restart();

  /// Verify credential
  /// POST /api/verify
  Future<VerifyResponse> verifyCredential(VerifyRequest request);

  /// Get OOB client information
  /// GET /api/oob/client
  Future<Map<String, dynamic>> getOobClient();
}
