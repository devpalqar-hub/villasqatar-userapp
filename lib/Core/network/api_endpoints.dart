
class ApiEndpoints {
  ApiEndpoints._();

  // OTP
  static const String sendOtp = "/api/auth/otp/send";
  static const String verifyOtp = "/api/auth/otp/verify";

  // Social Login
  static const String googleLogin = "/api/auth/google";
  static const String appleLogin = "/api/auth/apple";

  // Profile
  static const String completeProfile = "/api/auth/complete-profile";
}