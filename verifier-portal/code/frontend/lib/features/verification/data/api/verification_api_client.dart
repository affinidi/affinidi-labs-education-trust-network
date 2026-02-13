import 'package:dio/dio.dart';
import '../../domain/entities/api_response.dart';
import '../../domain/entities/dcql_request.dart';
import '../../domain/entities/verify_request.dart';

class VerificationApiClient {
  final Dio _dio;

  VerificationApiClient(this._dio);

  Future<DcqlResponse> sendDcqlRequest(DcqlRequest request) async {
    final response = await _dio.post(
      '/api/dcql/request',
      data: request.toJson(),
    );
    return DcqlResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ApiResponse> stopConnection() async {
    final response = await _dio.post('/api/connection-stop');
    return ApiResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ApiResponse> restart() async {
    final response = await _dio.post('/api/restart');
    return ApiResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<VerifyResponse> verifyCredential(VerifyRequest request) async {
    final response = await _dio.post('/api/verify', data: request.toJson());
    return VerifyResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getOobClient() async {
    final response = await _dio.get('/api/oob/client');
    return response.data as Map<String, dynamic>;
  }
}
