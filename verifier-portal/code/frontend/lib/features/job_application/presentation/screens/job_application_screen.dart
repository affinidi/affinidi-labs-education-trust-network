import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nova_corp_verifier/features/verification/data/providers/verification_repository_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/design_system/components/top_navigation_bar.dart';
import '../../../../core/infrastructure/websocket/websocket_service.dart';
import '../../../jobs/presentation/providers/jobs_providers.dart';
import '../../../verification/domain/models/verification_response.dart';

class JobApplicationScreen extends HookConsumerWidget {
  final String jobId;

  const JobApplicationScreen({super.key, required this.jobId});

  Widget _buildStatusCheck(BuildContext context, String label, bool isChecked) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_circle : Icons.error,
          color: isChecked ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildCredentialField(
    BuildContext context,
    String label,
    String? value,
  ) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 640;
    const double maxFormWidth = 1200;

    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Read values from environment variables
    final firstName = dotenv.env['STUDENT_FIRST_NAME'] ?? '';
    final lastName = dotenv.env['STUDENT_LAST_NAME'] ?? '';
    final fullName = '$firstName $lastName'.trim();
    final email = dotenv.env['STUDENT_EMAIL'] ?? '';

    final nameController = useTextEditingController(text: fullName);
    final emailController = useTextEditingController(text: email);
    final phoneController = useTextEditingController(text: '+65 9123 4567');
    final credentialVerified = useState(false);
    final verificationMessages = useState<List<String>>([]);
    final verifiableCredentialsWithTrustRegistry =
        useState<List<VerifiableCredentialWithTrustRegistry>>([]);
    final presentationVerified = useState(false);
    final hasReceivedCredentials = useState(false);

    final jobAsync = ref.watch(selectedJobProvider(jobId));

    // WebSocket listener
    useEffect(() {
      final subscription = WebSocketService.instance.messageStream.listen((
        String message,
      ) {
        try {
          debugPrint("received websocket message: $message");

          // Parse JSON - message is already a JSON string
          final Map<String, dynamic> data;
          try {
            data = jsonDecode(message) as Map<String, dynamic>;
          } catch (e) {
            debugPrint("Failed to parse WebSocket message: $e");
            return;
          }

          // Handle pong messages
          if (data['type'] == 'pong') {
            return;
          }

          // Parse into model
          final response = VerificationResponse.fromJson(data);

          // Handle progress messages (not completed)
          if (!response.completed) {
            verificationMessages.value = [
              ...verificationMessages.value,
              response.message,
            ];
            hasReceivedCredentials.value = true;
            return;
          }

          // Handle completion with full VC data
          if (response.completed &&
              response.verifiableCredentials != null &&
              response.verifiableCredentials!.isNotEmpty) {
            verifiableCredentialsWithTrustRegistry.value =
                response.verifiableCredentials!;

            // Update presentation-level verification status
            presentationVerified.value =
                response.presentationAndCredentialsAreValid ?? false;

            // Check if all VCs passed verification
            final allVCsValid = response.verifiableCredentials!.every((
              vcWithTr,
            ) {
              return vcWithTr
                      .trustRegistryResult
                      .governanceRecognitionCheck
                      .valid &&
                  vcWithTr.trustRegistryResult.issuerAuthorizationCheck.valid;
            });

            credentialVerified.value =
                response.status == 'success' &&
                presentationVerified.value &&
                allVCsValid;

            // Add completion message
            verificationMessages.value = [
              ...verificationMessages.value,
              'Credentials shared',
            ];

            // Mark as received
            hasReceivedCredentials.value = true;
          }
        } catch (e, stackTrace) {
          debugPrint('[WebSocket] Error handling message: $e');
          debugPrint('Stack trace: $stackTrace');
        }
      });

      return subscription.cancel;
    }, []);

    // Connect to WebSocket on mount
    useEffect(() {
      WebSocketService.instance.connect();
      return null;
    }, []);

    Widget buildVerificationStatusChecks() {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Verification Status',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildStatusCheck(
                context,
                'Presentation cryptographically verified',
                presentationVerified.value,
              ),
              // Show latest progress message if available
              if (verificationMessages.value.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    // const SizedBox(
                    //   width: 16,
                    //   height: 16,
                    //   child: CircularProgressIndicator(strokeWidth: 2),
                    // ),
                    // const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        verificationMessages.value.last,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    }

    Widget buildCredentialDisplay() {
      if (verifiableCredentialsWithTrustRegistry.value.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Received Credentials',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...verifiableCredentialsWithTrustRegistry.value.map((vcWithTr) {
              final vc = vcWithTr.vc;
              final trustRegistryResult = vcWithTr.trustRegistryResult;

              final credentialSubject = vc['credentialSubject'] is List
                  ? (vc['credentialSubject'] as List).first
                  : vc['credentialSubject'];

              final studentInfo =
                  credentialSubject['student'] as Map<String, dynamic>?;
              final programNCoursInfo =
                  credentialSubject['programNCourse'] as Map<String, dynamic>?;
              final instituteInfo =
                  credentialSubject['institute'] as Map<String, dynamic>?;

              // Extract trust registry check results
              final govValid =
                  trustRegistryResult.governanceRecognitionCheck.valid;
              final govMessage =
                  trustRegistryResult.governanceRecognitionCheck.message;
              final issuerValid =
                  trustRegistryResult.issuerAuthorizationCheck.valid;
              final issuerMessage =
                  trustRegistryResult.issuerAuthorizationCheck.message;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.school, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              programNCoursInfo?['program'] ??
                                  'Education Credential',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // Remove this VC from the list
                              final currentVCs =
                                  verifiableCredentialsWithTrustRegistry.value;
                              verifiableCredentialsWithTrustRegistry.value =
                                  currentVCs
                                      .where((vc) => vc != vcWithTr)
                                      .toList();

                              // Update credential verification status
                              if (verifiableCredentialsWithTrustRegistry
                                  .value
                                  .isEmpty) {
                                credentialVerified.value = false;
                                hasReceivedCredentials.value = false;
                              } else {
                                final allVCsValid =
                                    verifiableCredentialsWithTrustRegistry.value
                                        .every((vc) {
                                          return vc
                                                  .trustRegistryResult
                                                  .governanceRecognitionCheck
                                                  .valid &&
                                              vc
                                                  .trustRegistryResult
                                                  .issuerAuthorizationCheck
                                                  .valid;
                                        });
                                credentialVerified.value =
                                    presentationVerified.value && allVCsValid;
                              }
                            },
                            tooltip: 'Remove credential',
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildCredentialField(
                        context,
                        'Student',
                        '${studentInfo?['givenName']} ${studentInfo?['familyName']}',
                      ),
                      _buildCredentialField(
                        context,
                        'University',
                        instituteInfo?['legalName'],
                      ),
                      _buildCredentialField(
                        context,
                        'Accredited By',
                        instituteInfo?['accreditedBy'],
                      ),

                      // Verification Status within VC card
                      const Divider(height: 24),
                      Text(
                        'Verification Status',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildStatusCheck(
                        context,
                        issuerMessage.isEmpty
                            ? 'Issuer authorized to issue this credential'
                            : issuerMessage,
                        issuerValid,
                      ),
                      const SizedBox(height: 8),
                      _buildStatusCheck(
                        context,
                        govMessage.isEmpty
                            ? 'Ecosystem recognized by Certizen Trust Registry'
                            : govMessage,
                        govValid,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      );
    }

    Widget buildQRCodeSection(BuildContext context) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ref
              .watch(oobClientProvider)
              .when(
                data: (oobClientData) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: QrImageView(
                          data: jsonEncode(oobClientData),
                          version: QrVersions.auto,
                          size: 200,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Scan with Student Vault App',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load QR code.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ExpansionTile(
                        title: Text(
                          'Technical Details',
                          style: TextStyle(fontSize: 13),
                        ),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Error: ${error.toString()}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Check browser console for detailed logs',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        ),
      );
    }

    // Widget buildVerificationStatus(
    //   BuildContext context,
    //   AsyncValue<VerificationStatus> statusAsync,
    //   AsyncValue<CredentialVerificationResult> resultAsync,
    // ) {
    //   return statusAsync.when(
    //     data: (status) {
    //       Color statusColor;
    //       IconData statusIcon;
    //       String statusText;

    //       switch (status) {
    //         case VerificationStatus.idle:
    //           return const SizedBox.shrink();
    //         case VerificationStatus.waitingForCredential:
    //           statusColor = Colors.orange;
    //           statusIcon = Icons.qr_code_scanner;
    //           statusText = 'Waiting for credential...';
    //           break;
    //         case VerificationStatus.receivedCredential:
    //           statusColor = Colors.blue;
    //           statusIcon = Icons.download_done;
    //           statusText = 'Credential received';
    //           break;
    //         case VerificationStatus.verifying:
    //           statusColor = Colors.blue;
    //           statusIcon = Icons.verified_user;
    //           statusText = 'Verifying credential...';
    //           break;
    //         case VerificationStatus.verified:
    //           statusColor = Colors.green;
    //           statusIcon = Icons.check_circle;
    //           statusText = 'Credential verified successfully!';
    //           // credentialVerified is now updated via ref.listen
    //           break;
    //         case VerificationStatus.failed:
    //           statusColor = Colors.red;
    //           statusIcon = Icons.error;
    //           statusText = 'Verification failed';
    //           break;
    //       }

    //       return Card(
    //         color: statusColor.withOpacity(0.1),
    //         child: Padding(
    //           padding: const EdgeInsets.all(16),
    //           child: Row(
    //             children: [
    //               Icon(statusIcon, color: statusColor),
    //               const SizedBox(width: 12),
    //               Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       statusText,
    //                       style: TextStyle(
    //                         color: statusColor,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                     // Show credential details if verified
    //                     if (status == VerificationStatus.verified)
    //                       resultAsync.whenData((result) {
    //                             return Column(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                                 const SizedBox(height: 8),
    //                                 Text(
    //                                   'Degree: ${result.credentialData?['credentialSubject']?['degree'] ?? 'N/A'}',
    //                                   style: TextStyle(color: Colors.grey[700]),
    //                                 ),
    //                                 Text(
    //                                   'University: ${result.credentialData?['credentialSubject']?['university'] ?? 'N/A'}',
    //                                   style: TextStyle(color: Colors.grey[700]),
    //                                 ),
    //                               ],
    //                             );
    //                           }).value ??
    //                           const SizedBox.shrink(),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //     loading: () => const SizedBox.shrink(),
    //     error: (error, stack) => const SizedBox.shrink(),
    //   );
    // }

    Widget _buildUserDetailsColumn(
      BuildContext context,
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController phoneController,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Application Details',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Resume Upload (Dummy)
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Resume upload - Coming soon')),
              );
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Resume'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 16),

          // Cover Letter (Dummy)
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cover letter upload - Coming soon'),
                ),
              );
            },
            icon: const Icon(Icons.description),
            label: const Text('Upload Cover Letter (Optional)'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),

          const Divider(height: 40),

          Text(
            'User Details',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
        ],
      );
    }

    Widget _buildVerificationColumn(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Credentials',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Share your credentials to apply for this position.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),

          // QR Code
          Text(
            'Scan the QR code with your Student Vault app',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          buildQRCodeSection(context),

          // Show status only when received
          if (hasReceivedCredentials.value) ...[
            const SizedBox(height: 16),
            buildVerificationStatusChecks(),
          ],
        ],
      );
    }

    void submitApplication(GlobalKey<FormState> formKey, String jobTitle) {
      if (formKey.currentState!.validate()) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Application Submitted!'),
            content: Text(
              'Your application for $jobTitle has been submitted successfully. We will review your credentials and get back to you soon.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      body: Column(
        children: [
          TopNavigationBar(onLogoTap: () => context.go('/jobs')),
          Expanded(
            child: jobAsync.when(
              data: (job) {
                return SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: maxFormWidth),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 32,
                          vertical: 20,
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Job Title
                              Text(
                                job.title,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${job.department} • ${job.location}',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              const Divider(height: 32),

                              // Application Form

                              // 2-Column Layout for Verification
                              if (isMobile) ...[
                                // Mobile: Stack vertically
                                _buildUserDetailsColumn(
                                  context,
                                  nameController,
                                  emailController,
                                  phoneController,
                                ),
                                const SizedBox(height: 24),
                                _buildVerificationColumn(context),
                              ] else ...[
                                // Desktop: 2 columns
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildUserDetailsColumn(
                                        context,
                                        nameController,
                                        emailController,
                                        phoneController,
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Expanded(
                                      child: _buildVerificationColumn(context),
                                    ),
                                  ],
                                ),
                              ],

                              // Credentials section at bottom (spanning both columns)
                              if (verifiableCredentialsWithTrustRegistry
                                  .value
                                  .isNotEmpty) ...[
                                const SizedBox(height: 32),
                                buildCredentialDisplay(),
                              ],

                              const SizedBox(height: 32),

                              // Submit Button
                              ElevatedButton(
                                onPressed:
                                    (verifiableCredentialsWithTrustRegistry
                                            .value
                                            .isNotEmpty &&
                                        credentialVerified.value)
                                    ? () =>
                                          submitApplication(formKey, job.title)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  verifiableCredentialsWithTrustRegistry
                                          .value
                                          .isEmpty
                                      ? 'Please share at least one credential'
                                      : 'Submit Application',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
