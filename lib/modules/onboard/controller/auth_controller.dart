import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:country_pickers/utils/utils.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:villas_qatar/Core/constants/social_auth_config.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/services/push_notification_service.dart';
import 'package:villas_qatar/Core/services/storage_service.dart';
import 'package:villas_qatar/modules/mainscreen/mainscreen.dart';
import 'package:villas_qatar/modules/onboard/views/login_screen.dart';
import 'package:villas_qatar/modules/onboard/views/welcome_screen.dart';

class AuthController extends GetxController {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = false;
  bool isNewUser = false;
  String selectedCountry = "QA";
  String selectedCountryCode = "+974";
  String phoneNumber = "";
  String? accessToken;
  Map<String, dynamic>? profile;

  @override
  void onInit() {
  super.onInit();

  accessToken = StorageService.getToken();
  profile = StorageService.getProfile();

  phoneController.addListener(() {
    phoneNumber =
        "$selectedCountryCode${phoneController.text.trim()}";
  });


}
 

  @override
  void reset() {
    selectedCountry = "QA";
selectedCountryCode = "+974";
    phoneController.clear();
    otpController.clear();
    nameController.clear();
    emailController.clear();

    isLoading = false;
    isNewUser = false;
    selectedCountryCode = "+974";
    phoneNumber = "";
    accessToken = null;
    profile = null;

    update();
  }

  /// Splash Navigation
  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = StorageService.getToken();

    if (token != null && token.isNotEmpty) {
      Get.to(MainScreen());
    } else {
      Get.to(WelcomeScreen());
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  /// ---------------- SEND OTP ----------------
  Future<bool> sendOtp() async {
  if (!validatePhone()) return false;

  try {
    _setLoading(true);

    await ApiHandler.post(
      ApiEndpoints.sendOtp,
      body: {
        "phone": phoneNumber,
      },
    );

    return true;
  } catch (e) {
    debugPrint("Send OTP Error: $e");

    Fluttertoast.showToast(
      msg: "Failed to send OTP".tr,
    );

    return false;
  } finally {
    _setLoading(false);
  }
}

  /// ---------------- VERIFY OTP ----------------
  Future<bool> verifyOtp() async {
  if (!validatePhone()) return false;
  if (!validateOtp()) return false;

  try {
    _setLoading(true);

    final response = await ApiHandler.post(
      ApiEndpoints.verifyOtp,
      body: {
        "phone": phoneNumber,
        "otp": otpController.text.trim(),
      },
    );

    await _saveUserSession(response);

    return true;
  } catch (e) {
    debugPrint("Verify OTP Error: $e");

    Fluttertoast.showToast(
      msg: "Invalid OTP".tr,
    );

    return false;
  } finally {
    _setLoading(false);
  }
}

  /// ---------------- GOOGLE LOGIN ----------------
  /// Federated auth per
  /// https://firebase.google.com/docs/auth/flutter/federated-auth:
  /// sign in to FirebaseAuth with a GoogleAuthProvider credential built
  /// from the native Google Sign-In SDK tokens, then take the resulting
  /// *Firebase* ID token (not the raw Google SDK token) and send that to
  /// our backend (POST /api/auth/google), which is equivalent to
  /// POST /auth/firebase restricted to the Google provider.
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);

      final GoogleSignInAccount? account = await GoogleSignIn().signIn();
      if (account == null) {
        // User cancelled the picker.
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final String? firebaseIdToken =
          await userCredential.user?.getIdToken();

      if (firebaseIdToken == null) {
        throw Exception("Failed to get Firebase ID token");
      }

      final response = await ApiHandler.post(
        ApiEndpoints.googleAuth,
        body: {"idToken": firebaseIdToken},
      );

      await _saveUserSession(response);

      return true;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");

      Fluttertoast.showToast(
        msg: "Google sign-in failed".tr,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// ---------------- APPLE LOGIN ----------------
  /// Federated auth per
  /// https://firebase.google.com/docs/auth/flutter/federated-auth:
  /// sign in to FirebaseAuth with an OAuthProvider('apple.com')
  /// credential built from the native Sign in with Apple SDK's identity
  /// token + a nonce, then take the resulting *Firebase* ID token (not
  /// the raw Apple SDK token) and send that to our backend
  /// (POST /api/auth/apple), which is equivalent to POST /auth/firebase
  /// restricted to the Apple provider.
  ///
  /// Apple only hands back the user's name and email on the very first
  /// authorization for this app - every sign-in after that returns null
  /// for them, so whatever the native SDK gives us here is forwarded
  /// as-is to the backend on this call only.
  Future<bool> signInWithApple() async {
    try {
      _setLoading(true);

      // A raw nonce is required to link the Apple identity token to this
      // specific Firebase sign-in attempt and prevent replay attacks.
      // Apple gets the SHA-256 hash of it; Firebase gets the raw value.
      final String rawNonce = _generateNonce();
      final String hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
        // Apple has no native SDK on Android - the plugin falls back to
        // a web OAuth flow there, which needs the Services ID/return
        // URL registered in the Apple Developer portal. See
        // SocialAuthConfig for setup steps. Ignored on iOS.
        webAuthenticationOptions: Platform.isAndroid
            ? WebAuthenticationOptions(
                clientId: SocialAuthConfig.appleServiceId,
                redirectUri: Uri.parse(SocialAuthConfig.appleRedirectUri),
              )
            : null,
      );

      final String? identityToken = credential.identityToken;

      if (identityToken == null) {
        throw Exception("Failed to get Apple identity token");
      }

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: identityToken,
        rawNonce: rawNonce,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      final String? firebaseIdToken =
          await userCredential.user?.getIdToken();

      if (firebaseIdToken == null) {
        throw Exception("Failed to get Firebase ID token");
      }

      final body = <String, dynamic>{"idToken": firebaseIdToken};

      if (credential.givenName != null) body["firstName"] = credential.givenName;
      if (credential.familyName != null) body["lastName"] = credential.familyName;
      if (credential.email != null) body["email"] = credential.email;

      final response = await ApiHandler.post(
        ApiEndpoints.appleAuth,
        body: body,
      );

      await _saveUserSession(response);

      return true;
    } catch (e) {
      debugPrint("Apple Sign-In Error: $e");

      Fluttertoast.showToast(
        msg: "Apple sign-in failed".tr,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Generates a cryptographically random nonce for the Apple Sign-In /
  /// FirebaseAuth replay-protection handshake.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  //----------Comlete profile -------------
  /// ---------------- COMPLETE PROFILE ----------------
  Future<bool> completeProfile() async {
    try {
      _setLoading(true);

      final body = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneNumber,
      };

      debugPrint("========== COMPLETE PROFILE ==========");
      debugPrint("URL: ${ApiHandler.baseUrl}${ApiEndpoints.completeProfile}");
      debugPrint("METHOD: POST");
      debugPrint("HEADERS:");
      debugPrint({"Authorization": "Bearer $accessToken"}.toString());
      debugPrint("BODY:");
      debugPrint(body.toString());

      final response = await ApiHandler.post(
        ApiEndpoints.completeProfile,
        headers: {"Authorization": "Bearer $accessToken"},
        body: body,
      );

      debugPrint("========== RESPONSE ==========");
      debugPrint(response.toString());

      if (response["profile"] != null) {
        profile = Map<String, dynamic>.from(response["profile"]);
        await StorageService.saveProfile(profile!);
      }

      return true;
    } catch (e, stackTrace) {
      debugPrint("========== COMPLETE PROFILE ERROR ==========");
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveUserSession(Map<String, dynamic> response) async {
    isNewUser = response["isNew"] ?? false;
    accessToken = response["access_token"];

    if (response["profile"] != null) {
      profile = Map<String, dynamic>.from(response["profile"]);
    }

    if (accessToken != null && accessToken!.isNotEmpty) {
      await StorageService.saveToken(accessToken!);
      await StorageService.setLoggedIn(true);
    }

    if (profile != null) {
      await StorageService.saveProfile(profile!);
    }

    // Register this device's FCM token now that we have an access
    // token - the endpoint requires auth and re-assigns the token to
    // whichever account registers it, so this must run right after
    // login, not before.
    unawaited(PushNotificationService.registerCurrentToken());

    update();
  }

  Future<void> logout() async {
    await StorageService.logout();

    // Sign out of the native Google session too - otherwise the device
    // keeps the account cached and the next "Sign in with Google" tap
    // silently reuses it instead of showing the account picker.
    try {
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (e) {
      debugPrint("Google Sign-Out Error: $e");
    }

    // Also sign out of FirebaseAuth - it's only used as a pass-through to
    // mint the ID token we send our backend, but leaving it signed in
    // would let a later Firebase sign-in silently succeed without the
    // provider prompt.
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint("Firebase Sign-Out Error: $e");
    }

    phoneController.clear();
    otpController.clear();
    nameController.clear();
    emailController.clear();

    accessToken = null;
    profile = null;
    isNewUser = false;
    phoneNumber = "";
     selectedCountry = "QA";
     selectedCountryCode = "+974";
    isLoading = false;

    update();

    Get.offAll(() => WelcomeScreen());
  }


  void changeCountry(String isoCode) {
  selectedCountry = isoCode;

  final country = CountryPickerUtils.getCountryByIsoCode(isoCode);
  selectedCountryCode = "+${country.phoneCode}";

  phoneNumber =
      "$selectedCountryCode${phoneController.text.trim()}";

  update();
}


bool validatePhone() {
  final phone = phoneController.text.trim();

  if (phone.isEmpty) {
    Fluttertoast.showToast(
      msg: "Please enter your WhatsApp number".tr,
    );
    return false;
  }

  if (!RegExp(r'^[0-9]{6,15}$').hasMatch(phone)) {
    Fluttertoast.showToast(
      msg: "Please enter a valid phone number".tr,
    );
    return false;
  }

  phoneNumber = "$selectedCountryCode$phone";
  return true;
}



bool validateOtp() {
  final otp = otpController.text.trim();

  if (otp.isEmpty) {
    Fluttertoast.showToast(
      msg: "Please enter the OTP".tr,
    );
    return false;
  }

  if (otp.length != 6) {
    Fluttertoast.showToast(
      msg: "OTP must be 6 digits".tr,
    );
    return false;
  }

  return true;
}
}
