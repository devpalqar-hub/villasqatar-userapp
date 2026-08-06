import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/modules/dealers/service/dealer_controller.dart';
import 'package:villas_qatar/modules/dealers/service/model/dealer_list_model.dart';
import 'package:villas_qatar/modules/dealers/service/view/dealer_detail_screen.dart';

class DealerListScreen extends StatefulWidget {
  const DealerListScreen({super.key});

  @override
  State<DealerListScreen> createState() => _DealerListScreenState();
}

class _DealerListScreenState extends State<DealerListScreen> {
  final _scrollCtrl = ScrollController();
  final _controller = Get.put(DealerController());

  @override
  void initState() {
    super.initState();
    _controller.fetchDealers();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >=
          _scrollCtrl.position.maxScrollExtent - 200) {
        _controller.fetchDealers(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DealerController>(
      builder: (c) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text("Featured Dealers", style: AppTextStyles.title18),
        ),
        body: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: c.refreshDealers,
          child: Column(
            children: [
              const _SearchBar(),
              SizedBox(height: 12.h),
              Expanded(
                child: c.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : c.dealers.isEmpty
                    ? const _EmptyState()
                    : ListView.separated(
                        controller: _scrollCtrl,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        itemCount: c.dealers.length + (c.hasMore ? 1 : 0),
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (_, i) => i == c.dealers.length
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : DealerCard(dealer: c.dealers[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: TextField(
        onChanged: (q) => Get.find<DealerController>(),
        decoration: InputDecoration(
          hintText: "Search dealers",
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 20.sp,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 13.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.storefront_outlined,
            size: 44,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 10.h),
          Text("No dealers found", style: AppTextStyles.body13),
        ],
      ),
    );
  }
}

class DealerCard extends StatelessWidget {
  final Dealer dealer;

  const DealerCard({super.key, required this.dealer});

  @override
  Widget build(BuildContext context) {
    final profile = dealer.dealerProfile;

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
     onTap: () {
  Get.to(
    () => const DealerDetailsScreen(),
    arguments: dealer.id,
  );
},
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///========================
            /// TOP
            ///========================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Avatar(profile.coverImage?? "", size: 82.w),

                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              profile.dealerName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bold16,
                            ),
                          ),

                          SizedBox(width: 8.w),

                          _StatusBadge(dealer.isActive),
                        ],
                      ),

                      SizedBox(height: 5.h),

                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.textSecondary,
                            size: 14.sp,
                          ),

                          SizedBox(width: 4.w),

                          Expanded(
                            child: Text(
                              "${profile.city}, ${profile.country}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body12.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 6.h),

                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: AppColors.textSecondary,
                            size: 14.sp,
                          ),

                          SizedBox(width: 4.w),

                          Expanded(
                            child: Text(
                              dealer.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body12.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 6.h),

                      Row(
                        children: [
                          Icon(
                            Icons.call_outlined,
                            color: AppColors.textSecondary,
                            size: 14.sp,
                          ),

                          SizedBox(width: 4.w),

                          Expanded(
                            child: Text(
                              dealer.phone,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body12.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Divider(height: 1, color: AppColors.fieldBorder),

            SizedBox(height: 10.h),

            _DealerActions(dealer),
          ],
        ),
      ),
    );
  }
}

class _DealerActions extends StatelessWidget {
  final Dealer dealer;

  const _DealerActions(this.dealer);

  @override
  Widget build(BuildContext context) {
    final profile = dealer.dealerProfile;

    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            title: "Call",
            onTap: () => launchPhone(dealer.phone),
          ),
        ),

        SizedBox(width: 8.w),

        Expanded(
          child: _ActionButton(
            title: "WhatsApp",
            onTap: () {
              launchWhatsapp(
                (profile.whatsapp != null && profile.whatsapp!.isNotEmpty)
                    ? profile.whatsapp!
                    : dealer.phone,
              );
            },
          ),
        ),

        SizedBox(width: 8.w),

        Expanded(
          child: _ActionButton(
            title: "Website",
            onTap: () => launchWebsite(profile.website),
          ),
        ),

        SizedBox(width: 8.w),

        Expanded(
          child: _ActionButton(
            title: "Chat",
            onTap: () {
              Get.toNamed("/chat", arguments: dealer.id);
            },
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _ActionButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: onTap,
      child: Container(
        height: 36.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body12.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            fontSize: 11.sp,
          ),
        ),
      ),
    );
  }
}
//=====================================================
// DEALER AVATAR
//=====================================================

class _Avatar extends StatelessWidget {
  final String logo;
  final double size;

  const _Avatar(this.logo, {required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: logo.isNotEmpty
            ? Image.network(
                logo,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return _placeholder();
                },
                errorBuilder: (_, __, ___) {
                  return _placeholder();
                },
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.primary.withOpacity(.08),
      child: Icon(
        Icons.business_rounded,
        color: AppColors.primary,
        size: size * .45,
      ),
    );
  }
}

//=====================================================
// STATUS BADGE
//=====================================================

class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge(this.isActive, {super.key});

  @override
  Widget build(BuildContext context) {
    final bg = isActive ? const Color(0xffECFDF3) : const Color(0xffFEF3F2);

    final text = isActive ? const Color(0xff027A48) : const Color(0xffB42318);

    final icon = isActive ? Icons.check_circle : Icons.cancel;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: bg.withOpacity(.8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: text),

          SizedBox(width: 4.w),

          Text(
            isActive ? "Active" : "Inactive",
            style: AppTextStyles.body12.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> launchPhone(String phone) async {
  final uri = Uri.parse("tel:$phone");

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

Future<void> launchWhatsapp(String phone) async {
  final uri = Uri.parse(
    "https://wa.me/${phone.replaceAll("+", "").replaceAll(" ", "")}",
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

Future<void> launchWebsite(String website) async {
  String url = website;

  if (!url.startsWith("http")) {
    url = "https://$url";
  }

  final uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
