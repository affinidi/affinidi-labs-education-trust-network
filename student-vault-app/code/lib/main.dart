// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app/app.dart';
import 'core/infrastructure/database/setup_sql_cipher.dart';
// import 'core/infrastructure/firebase_messaging/firebase_options.dart';
import 'core/infrastructure/loggers/app_logger/app_logger.dart';
import 'core/infrastructure/loggers/error_logger/error_logger.dart';
import 'core/infrastructure/loggers/riverpod_provider_logger/provider_debug_logger.dart';
import 'core/infrastructure/plugins/camera_attachments_plugin/camera_attachments_plugin.dart';
import 'core/infrastructure/plugins/gallery_attachments_plugin/gallery_attachments_plugin.dart';
import 'core/infrastructure/providers/available_attachment_plugins_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorLoggingHandler.instance.ensureInitialized();

  final logger = AppLogger.instance;
  const logKey = 'Main';

  logger.info('Application starting up', name: logKey);

  logger.info(
    'Flutter version: ${const String.fromEnvironment('FLUTTER_VERSION', defaultValue: 'unknown')}',
    name: logKey,
  );
  logger.info('Build mode: ${kDebugMode ? 'debug' : 'release'}', name: logKey);

  await setupSqlCipher();

  logger.info('Launching Flutter app with ProviderScope', name: logKey);

  runApp(
    ProviderScope(
      overrides: [
        availableAttachmentPluginsProvider.overrideWith(
          (ref) => [CameraAttachmentsPlugin(), GalleryAttachmentsPlugin()],
        ),
      ],
      observers: [ProviderDebugLogger()],
      child: const App(),
    ),
  );

  logger.info('Application launch completed', name: logKey);
}
