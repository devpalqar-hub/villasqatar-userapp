import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/modules/dealers/view/dealer_detail_screen.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/pd_tokens.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';
import 'package:villas_qatar/modules/sellerpropertyscreen/views/seller_property_screen.dart';

/// "Listed by" card: avatar, role/verified badges, a link to all of the
/// lister's properties and - for other people's listings - Call / WhatsApp.
class PdListedByCard extends StatelessWidget {
  final Property property;
  final bool isMyProperty;

  const PdListedByCard({
    super.key,
    required this.property,
    required this.isMyProperty,
  });

  bool get _isDealer => property.createdBy.role.toUpperCase() == 'DEALER';

  void _openLister() {
    if (_isDealer) {
      Get.to(
        () => const DealerDetailsScreen(),
        arguments: property.createdBy.id,
      );
    } else {
      Get.to(
        () => SellerPropertiesScreen(
          sellerId: property.createdBy.id,
          sellerName: property.createdBy.name,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String dealerName =
        property.createdBy.dealerProfile?.dealerName.trim() ?? '';
    final String name = dealerName.isNotEmpty
        ? dealerName
        : property.createdBy.name.trim().isNotEmpty
        ? property.createdBy.name
        : 'Property Owner'.tr;

    final String phone = property.contactPhone.trim();
    final String whatsapp = property.contactWhatsapp.trim();
    final bool showContact =
        !isMyProperty && (phone.isNotEmpty || whatsapp.isNotEmpty);

    return PdCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PdSectionHeader(title: 'Listed By'.tr),
          SizedBox(height: 14.h),

          // Who listed it.
          Row(
            children: [
              _avatar(),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: [
                        _Badge(
                          icon: _isDealer
                              ? Icons.business_rounded
                              : Icons.person_rounded,
                          label: _isDealer ? 'Dealer'.tr : 'Property Owner'.tr,
                          foreground: AppColors.primary,
                          background: AppColors.maroonTint,
                        ),
                        if (property.contactVerified)
                          _Badge(
                            icon: Icons.verified_rounded,
                            label: 'Verified Contact'.tr,
                            foreground: AppColors.trendText,
                            background: AppColors.trendBg,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),
          Container(height: 1, color: PD.line),
          SizedBox(height: 10.h),

          // One tidy footer row: link on the start, compact actions at the end.
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _openLister,
                  borderRadius: BorderRadius.circular(10.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            'View all listings'.tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 15.sp,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (showContact) ...[
                SizedBox(width: 12.w),
                if (phone.isNotEmpty)
                  _IconAction(
                    tooltip: 'Call'.tr,
                    icon: Icon(
                      Icons.call_rounded,
                      size: 19.sp,
                      color: AppColors.primary,
                    ),
                    background: AppColors.maroonTint,
                    border: AppColors.primary.withValues(alpha: .18),
                    onTap: () => _makeCall(phone),
                  ),
                if (phone.isNotEmpty && whatsapp.isNotEmpty)
                  SizedBox(width: 8.w),
                if (whatsapp.isNotEmpty)
                  _IconAction(
                    tooltip: 'WhatsApp'.tr,
                    icon: FaIcon(
                      FontAwesomeIcons.whatsapp,
                      size: 19.sp,
                      color: const Color(0xFF1FA855),
                    ),
                    background: const Color(0xFFEAF8F0),
                    border: const Color(0xFF1FA855).withValues(alpha: .22),
                    onTap: () {
                      _trackWhatsappClick(property.id);
                      _openWhatsApp(whatsapp);
                    },
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatar() {
    final String cover = property.createdBy.dealerProfile?.coverImage ?? '';

    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.accentLine,
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: CircleAvatar(
          radius: 27.r,
          backgroundColor: const Color(0xFFF3F4F6),
          foregroundImage: cover.isEmpty ? null : NetworkImage(cover),
          // If the network image fails the icon underneath stays visible.
          onForegroundImageError: cover.isEmpty ? null : (_, _) {},
          child: Icon(
            Icons.person_rounded,
            size: 28.sp,
            color: AppColors.inkFaint,
          ),
        ),
      ),
    );
  }

  Future<void> _makeCall(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    final Uri uri = Uri.parse('https://wa.me/${phone.replaceAll("+", "")}');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// POST /api/listings/:listingId/track/whatsapp-click
  ///
  /// Fire-and-forget analytics ping - must never block or break the
  /// WhatsApp launch if it fails.
  Future<void> _trackWhatsappClick(String listingId) async {
    try {
      await ApiHandler.post(ApiEndpoints.listingWhatsappClick(listingId));
    } catch (_) {}
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color foreground;
  final Color background;

  const _Badge({
    required this.icon,
    required this.label,
    required this.foreground,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: foreground),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact soft-tinted square icon button (Call / WhatsApp).
class _IconAction extends StatelessWidget {
  final String tooltip;
  final Widget icon;
  final Color background;
  final Color border;
  final VoidCallback onTap;

  const _IconAction({
    required this.tooltip,
    required this.icon,
    required this.background,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            width: 42.w,
            height: 42.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: border),
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}
