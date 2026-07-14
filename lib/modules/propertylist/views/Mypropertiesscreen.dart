import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';

import 'listyourproperty_screen..dart';

enum PropertyStatus { active, draft, sold }

enum PropertyFor { sale, rent }

class PropertyListing {
  final String name;
  final String type;
  final String location;
  final int rooms;
  final int bathrooms;
  final int areaSqft;
  final double price;
  final String currency;
  final PropertyFor listedFor;
  final PropertyStatus status;
  final Color thumbColor;
  final IconData thumbIcon;
  final int photoCount;

  const PropertyListing({
    required this.name,
    required this.type,
    required this.location,
    required this.rooms,
    required this.bathrooms,
    required this.areaSqft,
    required this.price,
    required this.currency,
    required this.listedFor,
    required this.status,
    required this.thumbColor,
    required this.thumbIcon,
    required this.photoCount,
  });
}

// Demo data — replace with your real listings (e.g. from the form on submit)
final List<PropertyListing> demoListings = [
  PropertyListing(
    name: 'Marina View Apartment',
    type: 'Apartment',
    location: 'West Bay, Doha',
    rooms: 3,
    bathrooms: 2,
    areaSqft: 1450,
    price: 850000,
    currency: 'QAR',
    listedFor: PropertyFor.sale,
    status: PropertyStatus.active,
    thumbColor: Color(0xFFEFE3D8),
    thumbIcon: Icons.apartment,
    photoCount: 12,
  ),
  PropertyListing(
    name: 'Cozy Studio near Corniche',
    type: 'Studio',
    location: 'Al Sadd, Doha',
    rooms: 1,
    bathrooms: 1,
    areaSqft: 520,
    price: 4500,
    currency: 'QAR',
    listedFor: PropertyFor.rent,
    status: PropertyStatus.active,
    thumbColor: Color(0xFFE7DED6),
    thumbIcon: Icons.other_houses_outlined,
    photoCount: 8,
  ),
  const PropertyListing(
    name: 'Family Villa with Garden',
    type: 'Villa',
    location: 'The Pearl, Doha',
    rooms: 5,
    bathrooms: 4,
    areaSqft: 3800,
    price: 3200000,
    currency: 'QAR',
    listedFor: PropertyFor.sale,
    status: PropertyStatus.draft,
    thumbColor: Color(0xFFDCE4E8),
    thumbIcon: Icons.house_outlined,
    photoCount: 3,
  ),
  const PropertyListing(
    name: 'Downtown Office Space',
    type: 'Office',
    location: 'Lusail, Doha',
    rooms: 0,
    bathrooms: 2,
    areaSqft: 2100,
    price: 12000,
    currency: 'QAR',
    listedFor: PropertyFor.rent,
    status: PropertyStatus.sold,
    thumbColor: Color(0xFFEDEAE4),
    thumbIcon: Icons.business_outlined,
    photoCount: 15,
  ),
];

// =================================================================
// SCREEN
// =================================================================
class MyPropertiesScreen extends StatefulWidget {
  MyPropertiesScreen({super.key, List<PropertyListing>? listings})
    : listings = listings ?? demoListings;

  final List<PropertyListing> listings;

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  String activeFilter = 'All';
  final searchCtrl = TextEditingController();

  final List<String> filters = const ['All', 'Active', 'Draft', 'Sold'];

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  List<PropertyListing> get _filtered {
    Iterable<PropertyListing> list = widget.listings;
    if (activeFilter != 'All') {
      final status = PropertyStatus.values.firstWhere(
        (s) => s.name.toLowerCase() == activeFilter.toLowerCase(),
      );
      list = list.where((p) => p.status == status);
    }
    if (searchCtrl.text.trim().isNotEmpty) {
      final q = searchCtrl.text.trim().toLowerCase();
      list = list.where(
        (p) =>
            p.name.toLowerCase().contains(q) ||
            p.location.toLowerCase().contains(q),
      );
    }
    return list.toList();
  }

  @override
  Widget build(BuildContext context) {
    final listings = _filtered;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildSearchBar(),
            _buildFilterChips(),
            const SizedBox(height: 4),
            Expanded(
              child: listings.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
                      itemCount: listings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, i) =>
                          _PropertyCard(listing: listings[i]),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(
            () => const ListYourPropertyScreen(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 850),
            curve: Curves.easeOutCubic,
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'List Property',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // TOP BAR — matches the form screens (back arrow, centered
  // title, maroon accent action on the right)
  // ---------------------------------------------------------
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () {},
          ),
          const Expanded(
            child: Text(
              'My Properties',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // SEARCH BAR — same field styling as the form's text fields
  // ---------------------------------------------------------
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Container(
        height: 42, // Reduce height (try 40-44)
        decoration: BoxDecoration(
          color: AppColors.fieldBg,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: TextField(
          controller: searchCtrl,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          decoration: const InputDecoration(
            hintText: 'Search by property name or location',
            hintStyle: TextStyle(color: AppColors.hintGrey, fontSize: 12),
            prefixIcon: Icon(Icons.search, color: AppColors.hintGrey, size: 18),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // FILTER CHIPS — same pill/toggle language as Sale/Rent
  // ---------------------------------------------------------
  Widget _buildFilterChips() {
    return SizedBox(
      height: 25.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final label = filters[i];
          final selected = activeFilter == label;
          return GestureDetector(
            onTap: () => setState(() => activeFilter = label),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.pinkBg : AppColors.fieldBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.fieldBorder,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: selected ? AppColors.primary : AppColors.hintGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.pinkBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.home_work_outlined,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No properties found',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try a different search or filter, or list a new property',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.hintGrey, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// PROPERTY CARD
// =================================================================
class _PropertyCard extends StatelessWidget {
  final PropertyListing listing;
  const _PropertyCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThumbnail(),
              const SizedBox(width: 12),
              Expanded(child: _buildInfo()),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(height: 1, color: AppColors.fieldBorder),
          SizedBox(height: 5.h),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    return Stack(
      children: [
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: listing.thumbColor,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(listing.thumbIcon, color: Colors.white, size: 30),
        ),
        Positioned(
          left: 6,
          bottom: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.photo_camera, size: 10, color: Colors.white),
                const SizedBox(width: 3),
                Text(
                  '${listing.photoCount}',
                  style: TextStyle(color: Colors.white, fontSize: 8.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                listing.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  color: Colors.black87,
                ),
              ),
            ),
            _StatusBadge(status: listing.status),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 13,
              color: AppColors.hintGrey,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                listing.location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.hintGrey, fontSize: 10),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),
        Text(
          '${listing.currency} ${_formatPrice(listing.price)}'
          '${listing.listedFor == PropertyFor.rent ? " / month" : ""}',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        if (listing.rooms > 0) ...[
          _statIcon(Icons.bed_outlined, '${listing.rooms} Beds'),
          const SizedBox(width: 16),
        ],
        _statIcon(Icons.bathtub_outlined, '${listing.bathrooms} Baths'),
        const SizedBox(width: 16),
        _statIcon(Icons.square_foot_outlined, '${listing.areaSqft} sqft'),
        const Spacer(),
      ],
    );
  }

  Widget _statIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.labelGrey),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: AppColors.labelGrey),
        ),
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.pinkChipBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 15, color: AppColors.primary),
    );
  }

  String _formatPrice(double price) {
    final s = price.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buffer.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }
}

// =================================================================
// STATUS BADGE (Active / Draft / Sold) — same pill language as
// the WhatsApp Verified banner (colored bg + colored text)
// =================================================================
class _StatusBadge extends StatelessWidget {
  final PropertyStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    late String label;
    switch (status) {
      case PropertyStatus.active:
        bg = AppColors.greenBg;
        fg = AppColors.greenText;
        label = 'Active';
        break;
      case PropertyStatus.draft:
        bg = Colors.grey.shade100;
        fg = Colors.grey;
        label = 'Draft';
        break;
      case PropertyStatus.sold:
        bg = AppColors.pinkChipBg;
        fg = AppColors.primary;
        label = 'Sold';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}

// =================================================================
// FOR SALE / FOR RENT TAG
// =================================================================
class _ForTag extends StatelessWidget {
  final PropertyFor listedFor;
  const _ForTag({required this.listedFor});

  @override
  Widget build(BuildContext context) {
    final isSale = listedFor == PropertyFor.sale;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.pinkBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSale ? Icons.sell_outlined : Icons.vpn_key_outlined,
            size: 11,
            color: AppColors.primary,
          ),
          const SizedBox(width: 3),
          Text(
            isSale ? 'For Sale' : 'For Rent',
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
