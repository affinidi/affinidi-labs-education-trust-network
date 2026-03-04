import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../features/vault/data/vault_service/vault_service.dart';
import 'notification_counter_type.dart';
import 'notification_service_state.dart';

part 'notification_service.g.dart';

/// Service responsible for tracking notification counters for app features.
///
/// This service:
/// - Observes contacts and connections providers for badge counts.
/// - Maintains per-type counters (contacts, connections) in state.
/// - Exposes counter state via the provider for UI to display aggregated
///  counts.
@Riverpod(keepAlive: true)
class NotificationService extends _$NotificationService {
  NotificationService() : super();

  @override
  NotificationServiceState build() {
    // Listen to vault service changes to update credential count
    ref.listen(vaultServiceProvider, (previous, next) {
      final count = next.claimedCredentials?.length ?? 0;
      updateCredentialCount(count);
    });

    return NotificationServiceState();
  }

  void updateCredentialCount(int count) {
    final updatedCounters = Map<NotificationCounterType, int>.from(
      state.counters,
    );
    updatedCounters[NotificationCounterType.nexigen] = count;
    state = state.copyWith(counters: updatedCounters);
  }
}
