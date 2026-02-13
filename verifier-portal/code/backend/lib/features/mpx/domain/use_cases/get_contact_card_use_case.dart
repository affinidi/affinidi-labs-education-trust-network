import 'package:meeting_place_core/meeting_place_core.dart';

class GetContactCardUseCase {
  ContactCard call(String name) {
    final contactCard = ContactCard(
      did: 'did:example:$name',
      type: 'individual',
      contactInfo: {
        'n': {'given': name, 'surname': 'Verifier'},
      },
    );
    return contactCard;
  }
}
