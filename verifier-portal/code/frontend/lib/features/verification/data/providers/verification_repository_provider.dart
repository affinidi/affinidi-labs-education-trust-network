import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/infrastructure/config/app_config.dart';
import '../../domain/repositories/verification_repository.dart';
import '../api/verification_api_client.dart';
import '../repositories/verification_repository_impl.dart';

/// Provider for Dio instance configured for verification backend
final verificationDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.backendApi,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add interceptors for logging
  dio.interceptors.add(
    LogInterceptor(requestBody: true, responseBody: true, error: true),
  );

  return dio;
});

/// Provider for Retrofit API client
final verificationApiClientProvider = Provider<VerificationApiClient>((ref) {
  final dio = ref.watch(verificationDioProvider);
  return VerificationApiClient(dio);
});

/// Provider for VerificationRepository
final verificationRepositoryProvider = Provider<VerificationRepository>((ref) {
  final apiClient = ref.watch(verificationApiClientProvider);
  return VerificationRepositoryImpl(apiClient);
});

/// FutureProvider for getting OOB client data
final oobClientProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(verificationRepositoryProvider);
  return await repository.getOobClient();
});
