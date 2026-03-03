import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/app/presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  // Priority: .env.ngrok > .env.local-network > .env
  bool envLoaded = false;

  for (final envFile in ['.env.ngrok', '.env.local-network', '.env']) {
    try {
      await dotenv.load(fileName: envFile);
      debugPrint('✅ Loaded configuration from $envFile');
      envLoaded = true;
      break;
    } catch (e) {
      // Try next file
      continue;
    }
  }

  if (!envLoaded) {
    debugPrint('⚠️  No .env file found, using default configuration');
    // Initialize dotenv with empty map to prevent NotInitializedError
    // when screens access dotenv.env before a file has been loaded.
    dotenv.testLoad(fileInput: '');
  }

  runApp(const ProviderScope(child: NovaCorpApp()));
}
