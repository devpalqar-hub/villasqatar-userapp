import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/services/storage_service.dart';
import 'package:villas_qatar/modules/mainscreen/mainscreen.dart';
import 'package:villas_qatar/modules/onboard/views/login_screen.dart';
import 'package:villas_qatar/modules/onboard/views/welcome_screen.dart';

class AuthController extends GetxController {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool isLoading = false;
  bool isNewUser = false;
  String selectedCountryCode = "+974";
  String phoneNumber = "";
  String? accessToken;
  Map<String, dynamic>? profile;

  @override
  void onInit() {
    super.onInit();
    accessToken = StorageService.getToken();
    profile = StorageService.getProfile();
    _initializeGoogle();
  }

  Future<void> _initializeGoogle() async {
    await _googleSignIn.initialize(
      serverClientId:
          "1091977941143-5lrna9int1uevplanjgt6kmmq8mq4q75.apps.googleusercontent.com",
    );

    _googleSignIn.authenticationEvents
        .listen((event) {
          debugPrint("Google auth event: $event");
        })
        .onError((error) {
          debugPrint("Google auth error: $error");
        });

    await _googleSignIn.attemptLightweightAuthentication();
  }

  @override
  void reset() {
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
    try {
      _setLoading(true);

      await ApiHandler.post(ApiEndpoints.sendOtp, body: {"phone": phoneNumber});

      return true;
    } catch (e) {
      debugPrint("Send OTP Error: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// ---------------- VERIFY OTP ----------------
  Future<bool> verifyOtp() async {
    try {
      _setLoading(true);

      final response = await ApiHandler.post(
        ApiEndpoints.verifyOtp,
        body: {"phone": phoneNumber, "otp": otpController.text.trim()},
      );

      await _saveUserSession(response);

      return true;
    } catch (e) {
      debugPrint("Verify OTP Error: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// ---------------- GOOGLE LOGIN ----------------
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);

      final GoogleSignInAccount account = await _googleSignIn.authenticate();

      final authentication = account.authentication;

      final idToken = authentication.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception("Google ID Token is null");
      }

      final response = await ApiHandler.post(
        ApiEndpoints.googleLogin,
        body: {"idToken": idToken},
      );

      await _saveUserSession(response);

      return true;
    } on GoogleSignInException catch (e) {
      debugPrint("Google Sign-In Error: ${e.code}");
      debugPrint("Google Sign-In Message: ${e.description}");
      return false;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// ---------------- APPLE LOGIN ----------------
  Future<bool> signInWithApple() async {
    try {
      _setLoading(true);

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;

      if (idToken == null) {
        throw Exception("Apple Identity Token not found.");
      }

      final response = await ApiHandler.post(
        ApiEndpoints.appleLogin,
        body: {
          "idToken": idToken,
          "firstName": credential.givenName,
          "lastName": credential.familyName,
          "email": credential.email,
        },
      );

      await _saveUserSession(response);

      return true;
    } catch (e) {
      debugPrint("Apple Login Error: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //----------Comlete profile -------------
  /// ---------------- COMPLETE PROFILE ----------------
  Future<bool> completeProfile() async {
    try {
      _setLoading(true);

      final response = await ApiHandler.post(
        ApiEndpoints.completeProfile,
        headers: {"Authorization": "Bearer $accessToken"},
        body: {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneNumber,
        },
      );

      if (response["profile"] != null) {
        profile = Map<String, dynamic>.from(response["profile"]);
        await StorageService.saveProfile(profile!);
      }

      return true;
    } catch (e) {
      debugPrint("Complete Profile Error: $e");
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

    update();
  }

  Future<void> logout() async {
    await StorageService.logout();

    phoneController.clear();
    otpController.clear();
    nameController.clear();
    emailController.clear();

    accessToken = null;
    profile = null;
    isNewUser = false;
    phoneNumber = "";
    selectedCountryCode = "+974";
    isLoading = false;

    // Optional: Sign out from Google
    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    update();

    Get.offAll(() => WelcomeScreen());
  }
}
