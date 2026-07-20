import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';
import 'package:villas_qatar/modules/wishlist/service/wishlist_controller.dart';

class HeroImageCard extends StatefulWidget {
  final Property property;

  const HeroImageCard({super.key, required this.property});

  @override
  State<HeroImageCard> createState() => _HeroImageCardState();
}

class _HeroImageCardState extends State<HeroImageCard> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  late final WishlistController wishlistController;

  @override
  void initState() {
    super.initState();

    /// Make sure controller exists before GetBuilder uses it
    if (Get.isRegistered<WishlistController>()) {
      wishlistController = Get.find<WishlistController>();
    } else {
      wishlistController = Get.put(WishlistController());
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.property.photos;

    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: Stack(
            children: [
              /// PROPERTY IMAGE SLIDER
              Positioned.fill(
                child: ClipRRect(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: images.isEmpty ? 1 : images.length,
                    onPageChanged: (index) {
                      if (!mounted) return;

                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (_, index) {
                      String? imageUrl;

                      if (images.isNotEmpty &&
                          index >= 0 &&
                          index < images.length) {
                        imageUrl = images[index].url;
                      }

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          if (imageUrl != null && imageUrl.trim().isNotEmpty)
                            Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return Image.asset(
                                  "assets/villa.jpg",
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          else
                            Image.asset("assets/villa.jpg", fit: BoxFit.cover),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(.35),
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withOpacity(.45),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              /// TOP BUTTONS
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _circleButton(Icons.arrow_back_ios_new_rounded, () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      }),

                      Row(
                        children: [
                          _circleButton(Icons.share_outlined, () {
                            final String? slug = widget.property.slug;

                            if (slug == null || slug.trim().isEmpty) {
                              Get.snackbar(
                                "Unable to share",
                                "Property link is not available",
                              );
                              return;
                            }

                            final String propertyLink =
                                "https://villas.palqar.cloud/property/"
                                "${Uri.encodeComponent(slug)}";

                            final String message =
                                "Check out ${widget.property.propertyName}\n\n"
                                "$propertyLink";

                            debugPrint("Property Share Link: $propertyLink");

                            Get.bottomSheet(
                              SafeArea(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 20.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24.r),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Handle
                                      Container(
                                        width: 40.w,
                                        height: 4.h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 20.h),

                                      Text(
                                        "Share Property",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),

                                      SizedBox(height: 20.h),

                                      // WhatsApp
                                      ListTile(
                                        leading: Container(
                                          width: 44.w,
                                          height: 44.w,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF25D366),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.chat,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: const Text(
                                          "Share on WhatsApp",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onTap: () async {
                                          Get.back();

                                          final Uri whatsappUri = Uri.parse(
                                            "https://wa.me/?text="
                                            "${Uri.encodeComponent(message)}",
                                          );

                                          try {
                                            final bool opened = await launchUrl(
                                              whatsappUri,
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );

                                            if (!opened) {
                                              Get.snackbar(
                                                "WhatsApp unavailable",
                                                "Unable to open WhatsApp",
                                              );
                                            }
                                          } catch (e) {
                                            debugPrint(
                                              "WhatsApp Share Error: $e",
                                            );

                                            Get.snackbar(
                                              "Unable to share",
                                              "Could not open WhatsApp",
                                            );
                                          }
                                        },
                                      ),

                                      Divider(color: Colors.grey.shade200),

                                      // Copy Link
                                      ListTile(
                                        leading: Container(
                                          width: 44.w,
                                          height: 44.w,
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xff8E123E,
                                            ).withOpacity(.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.link_rounded,
                                            color: Color(0xff8E123E),
                                          ),
                                        ),
                                        title: const Text(
                                          "Copy Link",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onTap: () async {
                                          await Clipboard.setData(
                                            ClipboardData(text: propertyLink),
                                          );

                                          Get.back();

                                          Get.snackbar(
                                            "Link copied",
                                            "Property link copied to clipboard",
                                            snackPosition: SnackPosition.BOTTOM,
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                          );

                                          debugPrint(
                                            "Copied Property Link: $propertyLink",
                                          );
                                        },
                                      ),

                                      SizedBox(height: 10.h),
                                    ],
                                  ),
                                ),
                              ),
                              isScrollControlled: true,
                            );
                          }),
                          SizedBox(width: 10.w),

                          GetBuilder<WishlistController>(
                            init: wishlistController,
                            builder: (controller) {
                              final propertyId = widget.property.id;

                              final isWishlisted = controller.isWishlisted(
                                propertyId,
                              );

                              final isLoading = controller.isPropertyLoading(
                                propertyId,
                              );

                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: isLoading
                                    ? null
                                    : () async {
                                        await controller.toggleWishlist(
                                          propertyId,
                                        );
                                      },
                                child: Container(
                                  width: 30.w,
                                  height: 30.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(.20),
                                    ),
                                  ),
                                  child: isLoading
                                      ? SizedBox(
                                          width: 14.w,
                                          height: 14.w,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 1.5,
                                                color: Color(0xff8E123E),
                                              ),
                                        )
                                      : Icon(
                                          isWishlisted
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: const Color(0xff8E123E),
                                          size: 16.sp,
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// FEATURED BADGE
              // Positioned(
              //   left: 15.w,
              //   top: 50.h,
              //   child: Container(
              //     padding: EdgeInsets.symmetric(
              //       horizontal: 14.w,
              //       vertical: 6.h,
              //     ),
              //     decoration: BoxDecoration(
              //       color: const Color(0xff8E123E),
              //       borderRadius: BorderRadius.circular(30.r),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(.15),
              //           blurRadius: 12,
              //           offset: const Offset(0, 5),
              //         ),
              //       ],
              //     ),
              //     child: Row(
              //       children: [
              //         Icon(
              //           Icons.workspace_premium_rounded,
              //           color: Colors.white,
              //           size: 14.sp,
              //         ),
              //         SizedBox(width: 6.w),
              //         Text(
              //           "Featured",
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 12.sp,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              /// IMAGE COUNTER
              Positioned(
                right: 20.w,
                bottom: 10.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.55),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "${currentPage + 1}/"
                        "${images.isEmpty ? 1 : images.length}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleButton(
    IconData icon,
    VoidCallback onTap, {
    Color color = Colors.black,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.r),
      onTap: onTap,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(.20)),
        ),
        child: Icon(icon, color: color, size: 15.sp),
      ),
    );
  }
}
