import 'package:ssi/ssi.dart';

Future<void> main() async {
  // Get Trust Registry URL from environment variable
  final resolver = UniversalDIDResolver();
  final didWebDocument = await resolver.resolveDid(
    'did:web:63c46f323538.ngrok-free.app:hongkong-education-ministry',
  );
  print('DID Document: $didWebDocument');
}
