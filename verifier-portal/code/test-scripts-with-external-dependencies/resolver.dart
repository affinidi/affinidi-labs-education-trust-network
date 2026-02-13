import 'package:ssi/ssi.dart';

Future<void> main() async {
  // Get Trust Registry URL from environment variable
  final resolver = UniversalDIDResolver();
  final didWebDocument = await resolver.resolveDid(
    'did:web:2e683fea4089.ngrok-free.app:hongkong-university',
  );
  print('DID Document: $didWebDocument');
}
