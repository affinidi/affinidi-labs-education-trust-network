// ignore_for_file: unreachable_from_main

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'firebase_options.dart';

/// Provides a [FutureProvider] for accessing [FirebaseMessaging].
///
/// Sets up background message handling. Firebase initialization
/// is handled by the native platform code (AppDelegate/MainActivity).
FutureProvider<FirebaseMessaging> firebaseMessagingProvider =
    FutureProvider<FirebaseMessaging>((ref) async {
      // Register background message handler
      final firebaseOptions = DefaultFirebaseOptions.currentPlatform;
      if (firebaseOptions.appId.isNotEmpty) {
        await Firebase.initializeApp(options: firebaseOptions);
        debugPrint('✓ MAIN: Firebase initialized');
      }
      debugPrint('Firebase initialized');

      // Return the singleton instance
      // Firebase should already be initialized by native code
      return FirebaseMessaging.instance;
    });

/// Background handler for Firebase push notifications.
///
/// Called when a message is received while the app is in the background.
/// Logs the message, parses it into a [PushNotification], and updates
/// the app badge count if supported.
