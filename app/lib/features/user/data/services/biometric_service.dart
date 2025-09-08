import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:local_auth_android/local_auth_android.dart';
import 'package:mal/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  // Check if biometric authentication is available
  static Future<bool> isBiometricAvailable() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      logger.e('Error checking biometric availability: $e');
      return false;
    }
  }

  // Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      // ignore: avoid_print
      logger.e('Error getting available biometrics: $e');
      return [];
    }
  }

  // Authenticate with biometrics
  static Future<BiometricAuthResult> authenticate({
    bool stickyAuth = true,
  }) async {
    try {
      final bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Use PIN instead',
        authMessages: [
          const AndroidAuthMessages(
            signInTitle: 'Biometric Authentication',
            cancelButton: 'Cancel',
            biometricHint: 'Touch sensor',
            biometricNotRecognized: 'Not recognized, try again',
            biometricRequiredTitle: 'Biometric required',
            biometricSuccess: 'Biometric authentication successful',
            deviceCredentialsRequiredTitle: 'Device credentials required',
            deviceCredentialsSetupDescription:
                'Please set up device credentials',
            goToSettingsButton: 'Go to settings',
            goToSettingsDescription: 'Set up biometric authentication',
          ),
          // IOSAuthMessages(
          //   cancelButton: 'Cancel',
          //   goToSettingsButton: 'Go to settings',
          //   goToSettingsDescription: 'Set up biometric authentication',
          //   lockOut: 'Please re-enable biometric authentication',
          // ),
        ],
        options: const AuthenticationOptions(stickyAuth: true),
      );

      return isAuthenticated
          ? BiometricAuthResult.success
          : BiometricAuthResult.failed;
    } on PlatformException catch (e) {
      // ignore: avoid_print
      logger.e('Biometric authentication error: $e');

      switch (e.code) {
        case 'NotAvailable':
        case 'BiometricNotAvailable':
          return BiometricAuthResult.notAvailable;
        case 'NotEnrolled':
        case 'BiometricNotEnrolled':
          return BiometricAuthResult.notEnrolled;
        case 'LockedOut':
        case 'PermanentlyLockedOut':
        case 'BiometricLockedOut':
          return BiometricAuthResult.lockedOut;
        case 'UserCancel':
        case 'UserFallback':
          return BiometricAuthResult.cancelled;
        case 'SystemCancel':
          return BiometricAuthResult.systemCancelled;
        case 'InvalidContext':
          return BiometricAuthResult.invalidContext;
        case 'BiometricBindingNotSet':
          return BiometricAuthResult.notSetUp;
        default:
          return BiometricAuthResult.failed;
      }
    } catch (e) {
      logger.e('Unexpected biometric error: $e');
      return BiometricAuthResult.failed;
    }
  }

  // Check if device supports biometric authentication
  static Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      // ignore: avoid_print
      logger.e('Error checking device support: $e');
      return false;
    }
  }

  // Stop biometric authentication (if in progress)
  static Future<bool> stopAuthentication() async {
    try {
      return await _localAuth.stopAuthentication();
    } catch (e) {
      // ignore: avoid_print
      logger.e('Error stopping authentication: $e');
      return false;
    }
  }

  // Store biometric preference for user
  static Future<void> setBiometricPreference(String name, bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('biometric_$name', enabled);
    } catch (e) {
      // ignore: avoid_print
      logger.e('Error setting biometric preference: $e');
    }
  }

  // Store biometric preference for user
  static Future<void> removeBiometricPreference(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('biometric_$name');
    } catch (e) {
      // ignore: avoid_print
      logger.e('Error removing biometric preference: $e');
    }
  }

  // Get biometric preference for user
  static Future<bool> getBiometricPreference(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('biometric_$name') ?? false;
    } catch (e) {
      logger.e('Error getting biometric preference: $e');
      return false;
    }
  }

  // Store last authenticated user for biometric login
  static Future<void> setLastAuthenticatedUser(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_auth_user', uid);
    } catch (e) {
      logger.e('Error setting last authenticated user: $e');
    }
  }

  // Get last authenticated user
  static Future<String?> getLastAuthenticatedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // TODO: get user info from db
      return prefs.getString('last_auth_user');
    } catch (e) {
      logger.e('Error getting last authenticated user: $e');
      return null;
    }
  }

  // Clear all stored preferences
  static Future<void> clearAllPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs
          .getKeys()
          .where(
            (key) => key.startsWith('biometric_') || key == 'last_auth_user',
          )
          .toList();

      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      logger.e('Error clearing preferences: $e');
    }
  }

  // Get biometric type description for UI
  static String getBiometricTypeDescription(List<BiometricType> types) {
    if (types.isEmpty) return 'Biometric';

    if (types.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (types.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (types.contains(BiometricType.iris)) {
      return 'Iris';
    } else if (types.contains(BiometricType.strong)) {
      return 'Biometric';
    } else if (types.contains(BiometricType.weak)) {
      return 'Biometric';
    }

    return 'Biometric';
  }

  // Check if specific biometric type is available
  static Future<bool> isBiometricTypeAvailable(BiometricType type) async {
    try {
      final availableTypes = await getAvailableBiometrics();
      return availableTypes.contains(type);
    } catch (e) {
      logger.e('Error checking biometric type availability: $e');
      return false;
    }
  }
}

enum BiometricAuthResult {
  success,
  failed,
  notAvailable,
  notEnrolled,
  lockedOut,
  cancelled,
  systemCancelled,
  invalidContext,
  notSetUp,
}
