import 'package:flutter/material.dart';

import '../../services/notification_service/notification_counter_type.dart';

enum Tabs {
  // dashboard(serviceKey: NotificationCounterType.credulon),
  credentials(serviceKey: NotificationCounterType.credulon),
  profile(serviceKey: NotificationCounterType.profile),
  scanShare(serviceKey: NotificationCounterType.credulon);

  const Tabs({required this.serviceKey});

  final NotificationCounterType serviceKey;

  Widget get icon {
    switch (this) {
      // case Tabs.dashboard:
      //   return const Icon(Icons.space_dashboard_outlined);
      case Tabs.credentials:
        return const Icon(Icons.wallet_outlined);
      case Tabs.profile:
        return const Icon(Icons.person_outline);
      case Tabs.scanShare:
        return const Icon(Icons.qr_code_scanner);
    }
  }
}
