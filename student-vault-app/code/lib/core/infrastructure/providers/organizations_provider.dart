import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../config/organizations_config.dart';

part 'organizations_provider.g.dart';

@Riverpod(keepAlive: true)
Future<OrganizationsConfig> organizations(OrganizationsRef ref) async {
  return OrganizationsConfig.load();
}
