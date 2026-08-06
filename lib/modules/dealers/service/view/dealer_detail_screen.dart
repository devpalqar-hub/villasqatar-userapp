import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/modules/dealers/service/dealer_controller.dart';
import 'package:villas_qatar/modules/dealers/service/model/dealer_details_model.dart';

class DealerDetailsScreen extends StatefulWidget {
  const DealerDetailsScreen({super.key});

  @override
  State<DealerDetailsScreen> createState() => _DealerDetailsScreenState();
}

class _DealerDetailsScreenState extends State<DealerDetailsScreen> {
 final _controller = Get.find<DealerController>();
  bool _expandAbout = false;
  bool _favorite = false;

 @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _controller.fetchDealerDetails(
      Get.arguments as String,
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DealerController>(
      builder: (c) {
        final d = c.dealer;
        if (c.isLoading || d == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final p = d.dealerProfile;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Header(
                          p,
                          d,
                          favorite: _favorite,
                          onFavorite: () =>
                              setState(() => _favorite = !_favorite),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 60.h),
                              _Identity(p, d),
                              SizedBox(height: 20.h),
                              _ContactCard(p, d),
                              SizedBox(height: 16.h),
                              _SubscriptionAndStats(d),
                              SizedBox(height: 16.h),
                              // _AboutCard(
                              //   p.description ?? "No description available",
                              //   expanded: _expandAbout,
                              //   onToggle: () =>
                              //       setState(() => _expandAbout = !_expandAbout),
                              // ),
                              SizedBox(height: 20.h),
                              _SectionTitle(
                                title: "Properties",
                                onViewAll: () {},
                              ),
                              SizedBox(height: 12.h),
                            ],
                          ),
                        ),
                        _PropertiesRow(d.listings),
                      ],
                    ),
                  ),
                ),
                _BottomActions(d),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ------------------------------------------------------------------ Header
class _Header extends StatelessWidget {
  final DealerProfile p;
  final DealerDetailsModel d;
  final bool favorite;
  final VoidCallback onFavorite;

  const _Header(
    this.p,
    this.d, {
    required this.favorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 220.h,
          width: double.infinity,
          child: Image.network(
            p.coverImage ?? "",
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: AppColors.primarySoft),
          ),
        ),
        Positioned(
          top: 50.h,
          left: 16.w,
          child: _RoundIcon(
            icon: Icons.arrow_back_ios_new,
            onTap: () => Get.back(),
          ),
        ),
       
        Positioned(
          left: 16.w,
          bottom: -50.h,
          child: Container(
            width: 100.w,
            height: 100.w,
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 12),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Image.network(
                p.coverImage ?? "",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.apartment,
                  color: AppColors.primary,
                  size: 36.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const _RoundIcon({
    required this.icon,
    this.iconColor = Colors.black87,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 8),
          ],
        ),
        child: Icon(icon, size: 18.sp, color: iconColor),
      ),
    );
  }
}

// ---------------------------------------------------------------- Identity
class _Identity extends StatelessWidget {
  final DealerProfile p;
  final DealerDetailsModel d;

  const _Identity(this.p, this.d);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                p.dealerName,
                style: AppTextStyles.title18,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.verified, size: 18.sp, color: AppColors.primary),
          ],
        ),
        if (p.tagline != null) ...[
          SizedBox(height: 4.h),
          Text(
            p.tagline!,
            style: AppTextStyles.body13.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
        SizedBox(height: 8.h),
        Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: d.isActive ? AppColors.success : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              d.isActive ? "Active" : "Inactive",
              style: AppTextStyles.body13.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 15.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 4.w),
            Text(
              "${p.city}, ${p.country}",
              style: AppTextStyles.body13.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(width: 16.w),
            Icon(
              Icons.calendar_today_outlined,
              size: 13.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 4.w),
            Text(
              "Active Since ${d.createdAt.year}",
              style: AppTextStyles.body13.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ------------------------------------------------------------- ContactCard
class _ContactCard extends StatelessWidget {
  final DealerProfile p;
  final DealerDetailsModel d;

  const _ContactCard(this.p, this.d);

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Contact Information",
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ContactTile(Icons.call_outlined, d.phone, "Phone"),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ContactTile(
                  Icons.call_outlined,
                  p.whatsapp ?? d.phone,
                  "WhatsApp",
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _ContactTile(Icons.email_outlined, d.email, "Email"),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ContactTile(
                  Icons.location_on_outlined,
                  p.address ?? "",
                  p.city ?? "",
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _ContactTile(Icons.language, p.website ?? "", "Website"),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ContactTile(
                  Icons.confirmation_number_outlined,
                  p.tradeNumber ?? "",
                  "Trade No.",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _ContactTile(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 16.sp, color: AppColors.primary),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bold12,
              ),
              Text(
                label,
                style: AppTextStyles.body12.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------- Subscription + Stats
class _SubscriptionAndStats extends StatelessWidget {
  final DealerDetailsModel d;

  const _SubscriptionAndStats(this.d);

  @override
  Widget build(BuildContext context) {
    final sub = d.activeSubscription;
    final total = d.listings.length;
    final active = d.listings
        .where((e) => e.status.toLowerCase() == "active")
        .length;
    final sold = d.listings
        .where((e) => e.status.toLowerCase() == "sold")
        .length;
    final rent = d.listings
        .where((e) => e.purpose.toLowerCase() == "rent")
        .length;

    return Column(
      children: [
        if (sub != null)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subscription Plan",
                      style: AppTextStyles.body13.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const Icon(Icons.workspace_premium, color: Colors.amber),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      sub.plan.name ?? "",
                      style: AppTextStyles.title18.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        sub.paymentStatus ?? "",
                        style: AppTextStyles.body12.copyWith(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  "Valid Till",
                  style: AppTextStyles.body12.copyWith(color: Colors.white70),
                ),
                Text(
                  _fmtDate(sub.endDate),
                  style: AppTextStyles.bold16.copyWith(color: Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Divider(color: Colors.white24, height: 1),
                ),
                ..._planFeatures(sub.plan).map(
                  (f) => Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 15,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          f,
                          style: AppTextStyles.body12.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: 16.h),
        _Card(
          title: "Statistics",
          child: Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: [
              _StatTile(
                Icons.home_outlined,
                "$total",
                "Total Properties",
                AppColors.primary,
              ),
              _StatTile(
                Icons.check_circle_outline,
                "$active",
                "Active Listings",
                AppColors.success,
              ),
              _StatTile(
                Icons.sell_outlined,
                "$sold",
                "Sold Properties",
                Colors.orange,
              ),
              _StatTile(Icons.key_outlined, "$rent", "For Rent", Colors.indigo),
            ],
          ),
        ),
      ],
    );
  }

  List<String> _planFeatures(SubscriptionPlan plan) => [
    if (plan.maxListings != null) "${plan.maxListings} Listings",

    if (plan.validityDays != null) "Valid for ${plan.validityDays} Days",

    if ((plan.boostDiscountPercent ?? 0) > 0)
      "${plan.boostDiscountPercent}% Boost Discount",

    "Priority Support",
  ];

  String _fmtDate(DateTime dt) =>
      "${dt.day.toString().padLeft(2, '0')} ${_months[dt.month - 1]} ${dt.year}";

  static const _months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatTile(this.icon, this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 16.sp, color: color),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: AppTextStyles.bold16),
                Text(
                  label,
                  style: AppTextStyles.body12.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------- About Card
class _AboutCard extends StatelessWidget {
  final String description;
  final bool expanded;
  final VoidCallback onToggle;

  const _AboutCard(
    this.description, {
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "About Company",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            maxLines: expanded ? null : 2,
            overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: AppTextStyles.body13.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onToggle,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    expanded ? "Show Less" : "Read More",
                    style: AppTextStyles.body13.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    size: 18.sp,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------- Section
class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const _SectionTitle({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.title18),
        // InkWell(
        //   onTap: onViewAll,
        //   child: Row(
        //     children: [
        //       Text(
        //         "View All",
        //         style: AppTextStyles.body13.copyWith(color: AppColors.primary),
        //       ),
        //       Icon(Icons.chevron_right, size: 18.sp, color: AppColors.primary),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

// -------------------------------------------------------- Properties Row
class _PropertiesRow extends StatelessWidget {
  final List<DealerListing> listings;

  const _PropertiesRow(this.listings);

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Text(
          "No properties yet",
          style: AppTextStyles.body13.copyWith(color: AppColors.textSecondary),
        ),
      );
    }
    return SizedBox(
      height: 260.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: listings.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, i) => _PropertyCard(listings[i]),
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final DealerListing listing;

  const _PropertyCard(this.listing);

  @override
  Widget build(BuildContext context) {
    final photo = listing.sortedPhotos.isNotEmpty
        ? listing.sortedPhotos.first.url
        : "";
    final forSale = listing.purpose.toLowerCase() != "rent";

    return Container(
      width: 210.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: SizedBox(
                  height: 120.h,
                  width: double.infinity,
                  child: (photo?.isNotEmpty ?? false)
                      ? Image.network(
                          photo!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: AppColors.primarySoft),
                        )
                      : Container(
                          color: AppColors.primarySoft,
                          child: Icon(
                            Icons.home_work_outlined,
                            size: 40.sp,
                            color: AppColors.primary,
                          ),
                        ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: _RoundIcon(icon: Icons.favorite_border, onTap: () {}),
              ),
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    forSale ? "FOR SALE" : "FOR RENT",
                    style: AppTextStyles.bold12.copyWith(
                      color: Colors.white,
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.propertyName ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bold12,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        "${listing.areaName}, ${listing.municipality.name}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body12.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    _feature(Icons.bed_outlined, "${listing.bedrooms} Beds"),
                    SizedBox(width: 8.w),
                    _feature(
                      Icons.bathtub_outlined,
                      "${listing.bathrooms} Baths",
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  "QAR ${listing.price.toStringAsFixed(0)}${forSale ? '' : '/month'}",
                  style: AppTextStyles.bold16.copyWith(
                    color: AppColors.primary,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _feature(IconData icon, String text) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 12.sp, color: AppColors.textSecondary),
      SizedBox(width: 3.w),
      Text(
        text,
        style: AppTextStyles.body12.copyWith(
          color: AppColors.textSecondary,
          fontSize: 10.sp,
        ),
      ),
    ],
  );
}

// -------------------------------------------------------------- Generic
class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.bold16),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}
class _BottomActions extends StatelessWidget {
  final DealerDetailsModel d;

  const _BottomActions(this.d);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: _actionButton(
                icon: Icons.call_outlined,
                label: "Call",
                onTap: () {},
              ),
            ),

            SizedBox(width: 8.w),

            Expanded(
              child: _actionButton(
                icon: Icons.chat_bubble_outline,
                label: "WhatsApp",
                onTap: () {},
              ),
            ),

            SizedBox(width: 8.w),

          

            Expanded(
              child: _actionButton(
                icon: Icons.chat,
                label: "Chat",
                filled: true,
                onTap: () => Get.toNamed(
                  '/chat',
                  arguments: d.id,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return SizedBox(
      height: 46.h,
      child: filled
          ? ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(
                icon,
                size: 12.sp,
                color: Colors.white,
              ),
              label: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body12.copyWith(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onTap,
              icon: Icon(
                icon,
                size: 12.sp,
                color: AppColors.primary,
              ),
              label: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body12.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
    );
  }
}
