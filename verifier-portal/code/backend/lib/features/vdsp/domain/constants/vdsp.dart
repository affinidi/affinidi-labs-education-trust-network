import 'package:dcql/dcql.dart';
import 'package:uuid/uuid.dart';
import 'package:vdsp_verifier_server/features/vdsp/domain/entities/verifier_client.dart';

final defaultVerifierClient = VerifierClient(
  id: "novacorpverifier",
  name: 'Nova Corp Careers',
  type: 'internal',
  description: 'Nova corp verifier',
  purpose: 'Share your credentials to apply for job',
);

final dcqlCertizen = DcqlCredentialQuery(
  credentials: [
    DcqlCredential(
      id: const Uuid().v4(),
      format: CredentialFormat.ldpVc,
      requireCryptographicHolderBinding: true,
      meta: DcqlMeta.forW3C(
        typeValues: [
          ['EducationCredential'],
        ],
      ),
      // No claims specified = entire credential is returned
    ),
  ],
);
