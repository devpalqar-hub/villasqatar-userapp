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

  static const String mypropertyList = "/api/listings/my";

  static const String propertyList = "/api/listings";

  static const String propertyAdd = "/api/listings";

  static const String listingOptions = "/api/listings/options";

  static const String chatConversations = "/api/chat/conversations";

  static const String wishlists = "/api/wishlists";

  static String wishlistByProperty(String propertyId) {
    return "/api/wishlists/$propertyId";
  }

  static String scheduleVisit(String propertyId) {
    return "/api/visits/$propertyId";
  }

  static String acceptVisit(String visitId) {
    return "/api/visits/$visitId/accept";
  }

  static const String visitsAsOwner = "/api/visits/as-owner";

  static const String visitsAsVisitor = "/api/visits/as-visitor";

  static String propertyBySlug(String slug) {
    return "/api/listings/slug/"
        "${Uri.encodeComponent(slug)}";
  }

  static const String featuredPlans = "/api/featured-plans";
  static const String featuredProperties = "/api/featured";
  static const String myfeaturedProperties = "/api/featured/my";
  static String markPropertyAsSold(String propertyId) {
    return "/api/listings/$propertyId/sold";
  }

  static String closeVisit(String visitId) => "/api/visits/$visitId/close";
  static const String myfeaturedPlans = '/api/featured-plans';

  static const String supportTickets = "/api/support/tickets";
  static const String estimatePrice = "/api/listings/estimate-price";

  static const String banners = "/api/banners";

  static String featuredBanners({bool isFeatured = true}) {
    return "/api/banners?isFeatured=$isFeatured";
  }

  static const String geocode = "/api/listings/geocode";
  static const String reverseGeocode = "/api/listings/reverse-geocode";
}
