import 'package:meeting_place_core/meeting_place_core.dart';
import 'package:meeting_place_mediator/meeting_place_mediator.dart';

class RegisterForNotificationsUseCase {
  final MeetingPlaceCoreSDK sdk;

  RegisterForNotificationsUseCase(this.sdk);

  Future<MediatorStreamSubscription> call(
    String permanentDid,
    void Function(PlainTextMessage) onData,
  ) async {
    final registerResult = await sdk.registerForDIDCommNotifications(
      recipientDid: permanentDid,
    );

    final notificationChannel = await sdk.mediator.subscribeToMessages(
      registerResult.recipientDid,
    );

    final recipientDoc = await registerResult.recipientDid.getDidDocument();
    print('Listening for DIDComm notifications on ${recipientDoc.id}');

    notificationChannel.listen(onData);
    return notificationChannel;
  }
}
