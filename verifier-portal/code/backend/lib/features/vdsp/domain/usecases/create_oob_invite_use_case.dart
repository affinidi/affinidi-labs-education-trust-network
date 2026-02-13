import 'dart:async';
import 'package:meeting_place_core/meeting_place_core.dart';

class CreateOobInviteUseCase {
  final MeetingPlaceCoreSDK sdk;

  CreateOobInviteUseCase(this.sdk);

  Future<String> call(ContactCard contactCard, String? permanentDid) async {
    final result = await sdk.createOobFlow(
      did: permanentDid,
      contactCard: contactCard,
    );

    final completer = Completer<void>();

    result.streamSubscription.listen(
      (data) {
        try {
          print('OOB onDone channel id: ${data.channel.id}');
          print('Holder DID: ${data.channel.otherPartyPermanentChannelDid}');
          if (!completer.isCompleted) {
            completer.complete();
          }
        } catch (e, stackTrace) {
          print('ERROR: Exception in OOB stream listener: $e');
          print('Stack trace: $stackTrace');
          if (!completer.isCompleted) {
            completer.completeError(e, stackTrace);
          }
        }
      },
      onError: (error, stackTrace) {
        print('ERROR: OOB stream error: $error');
        print('Stack trace: $stackTrace');
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      },
      onDone: () {
        print('OOB stream completed');
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );

    print('OOB URL: ${result.oobUrl}');
    return result.oobUrl.toString();
  }
}
