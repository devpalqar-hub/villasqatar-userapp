import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/modules/PlansandFeatures/model/myfeatured_property.dart';
import 'package:villas_qatar/modules/PlansandFeatures/services/featured_properties_controller.dart';

class MyFeaturedPropertiesScreen extends StatefulWidget {
  const MyFeaturedPropertiesScreen({
    super.key,
  });

  @override
  State<MyFeaturedPropertiesScreen> createState() =>
      _MyFeaturedPropertiesScreenState();
}

class _MyFeaturedPropertiesScreenState
    extends State<MyFeaturedPropertiesScreen> {
  late final FeaturedPropertiesController controller;

  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    controller =
        Get.isRegistered<FeaturedPropertiesController>()
            ? Get.find<FeaturedPropertiesController>()
            : Get.put(
                FeaturedPropertiesController(),
              );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.getMyFeaturedProperties();
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
        ),
        title: Text(
          'My Featured Properties'.tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF202020),
          ),
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: GetBuilder<FeaturedPropertiesController>(
        builder: (controller) {
          final List<MyFeaturedProperty> properties =
              controller.filteredMyFeaturedProperties;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh:
                controller.refreshMyFeaturedProperties,
            child: CustomScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ==================================================
                // SEARCH + HEADER
                // ==================================================

                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(
                      16.w,
                      10.h,
                      16.w,
                      18.h,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // ==========================================
                        // SEARCH
                        // ==========================================

                        TextField(
                          controller: searchController,
                          onChanged: controller
                              .searchMyFeaturedProperties,
                          textInputAction:
                              TextInputAction.search,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color:
                                const Color(0xFF222222),
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Search featured properties'
                                    .tr,
                            hintStyle: TextStyle(
                              fontSize: 13.sp,
                              color:
                                  Colors.grey.shade500,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 21.sp,
                              color:
                                  Colors.grey.shade500,
                            ),

                            suffixIcon: controller
                                    .myFeaturedPropertiesSearch
                                    .isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      searchController
                                          .clear();

                                      controller
                                          .clearMyFeaturedPropertiesSearch();
                                    },
                                    icon: Icon(
                                      Icons.close_rounded,
                                      size: 19.sp,
                                      color: Colors
                                          .grey.shade600,
                                    ),
                                  )
                                : null,

                            filled: true,
                            fillColor:
                                const Color(0xFFF7F7F9),

                            contentPadding:
                                EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),

                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                10.r,
                              ),
                              borderSide:
                                  BorderSide.none,
                            ),

                            enabledBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                10.r,
                              ),
                              borderSide: BorderSide(
                                color:
                                    Colors.grey.shade200,
                              ),
                            ),

                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                12.r,
                              ),
                              borderSide:
                                  const BorderSide(
                                color:
                                    AppColors.primary,
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 18.h),

                        // ==========================================
                        // TITLE + COUNT
                        // ==========================================

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    'Featured Properties'
                                        .tr,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight:
                                          FontWeight.w700,
                                      color:
                                          const Color(
                                        0xFF202020,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 3.h),

                                  Text(
                                    'Manage your currently featured properties'
                                        .tr,
                                    style: TextStyle(
                                      fontSize: 11.5.sp,
                                      color: Colors
                                          .grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (!controller
                                .isMyFeaturedPropertiesLoading)
                              Container(
                                padding:
                                    EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 6.h,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: AppColors
                                      .primary
                                      .withOpacity(.07),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    20.r,
                                  ),
                                ),
                                child: Text(
                                  '${properties.length} '
                                  '${properties.length == 1 ? 'Property' : 'Properties'}',
                                  style: TextStyle(
                                    fontSize: 10.5.sp,
                                    fontWeight:
                                        FontWeight.w600,
                                    color:
                                        AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // LOADING
                // ==================================================

                if (controller
                        .isMyFeaturedPropertiesLoading &&
                    controller
                        .myFeaturedProperties.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildLoading(),
                  )

                // ==================================================
                // ERROR
                // ==================================================

                else if (controller
                        .myFeaturedPropertiesError
                        .isNotEmpty &&
                    controller
                        .myFeaturedProperties.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child:
                        _buildError(controller),
                  )

                // ==================================================
                // EMPTY
                // ==================================================

                else if (properties.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child:
                        _buildEmpty(controller),
                  )

                // ==================================================
                // LIST
                // ==================================================

                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      16.w,
                      16.h,
                      16.w,
                      30.h,
                    ),
                    sliver: SliverList(
                      delegate:
                          SliverChildBuilderDelegate(
                        (
                          context,
                          index,
                        ) {
                          final MyFeaturedProperty
                              property =
                              properties[index];

                          return Padding(
                            padding:
                                EdgeInsets.only(
                              bottom: 14.h,
                            ),
                            child:
                                _FeaturedPropertyCard(
                              property: property,
                            ),
                          );
                        },
                        childCount:
                            properties.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: AppColors.primary,
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(
    FeaturedPropertiesController controller,
  ) {
    return Center(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                color:
                    AppColors.primary.withOpacity(.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 32.sp,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: 18.h),

            Text(
              'Unable to load featured properties'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF222222),
              ),
            ),

            SizedBox(height: 7.h),

            Text(
              controller.myFeaturedPropertiesError,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            SizedBox(height: 18.h),

            ElevatedButton(
              onPressed:
                  controller.refreshMyFeaturedProperties,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor:
                    AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                'Try Again'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty(
    FeaturedPropertiesController controller,
  ) {
    final bool searching = controller
        .myFeaturedPropertiesSearch.isNotEmpty;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(30.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76.w,
              height: 76.w,
              decoration: BoxDecoration(
                color:
                    AppColors.primary.withOpacity(.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                searching
                    ? Icons.search_off_rounded
                    : Icons
                        .workspace_premium_outlined,
                size: 34.sp,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: 17.h),

            Text(
              searching
                  ? 'No matching properties found'.tr
                  : 'No featured properties available'
                      .tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF222222),
              ),
            ),

            SizedBox(height: 7.h),

            Text(
              searching
                  ? 'Try searching with another property name'
                      .tr
                  : 'Your featured properties will appear here'
                      .tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            if (searching) ...[
              SizedBox(height: 14.h),

              TextButton(
                onPressed: () {
                  searchController.clear();

                  controller
                      .clearMyFeaturedPropertiesSearch();
                },
                child: Text(
                  'Clear Search'.tr,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// MY FEATURED PROPERTY CARD
// ============================================================

// class _FeaturedPropertyCard
//     extends StatelessWidget {
//   final MyFeaturedProperty property;

//   const _FeaturedPropertyCard({
//     required this.property,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final listing = property.listing;
//     final plan = property.plan;

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius:
//             BorderRadius.circular(14.r),
//         onTap: () {
//           // Use listing.id if you want to open
//           // property details.
//           //
//           // Example:
//           //
//           // Get.to(
//           //   () => PropertyDetailScreen(
//           //     propertyId: listing.id,
//           //   ),
//           // );
//         },
//         child: Container(
//           padding: EdgeInsets.all(15.w),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius:
//                 BorderRadius.circular(14.r),
//             border: Border.all(
//               color: const Color(0xFFEBEBEF),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color:
//                     Colors.black.withOpacity(.035),
//                 blurRadius: 10,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,
//             children: [
//               // ==================================================
//               // HEADER
//               // ==================================================

//               Row(
//                 crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                 children: [
//                   // Property icon
//                   Container(
//                     width: 48.w,
//                     height: 48.w,
//                     decoration: BoxDecoration(
//                       color: AppColors.primary
//                           .withOpacity(.07),
//                       borderRadius:
//                           BorderRadius.circular(
//                         11.r,
//                       ),
//                     ),
//                     alignment: Alignment.center,
//                     child: Icon(
//                       Icons.home_work_outlined,
//                       size: 25.sp,
//                       color: AppColors.primary,
//                     ),
//                   ),

//                   SizedBox(width: 12.w),

//                   // Property name/status
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           listing.propertyName
//                                   .trim()
//                                   .isNotEmpty
//                               ? listing.propertyName
//                               : 'Property',
//                           maxLines: 2,
//                           overflow:
//                               TextOverflow.ellipsis,
//                           style: TextStyle(
//                             fontSize: 15.sp,
//                             height: 1.25,
//                             fontWeight:
//                                 FontWeight.w700,
//                             color: const Color(
//                               0xFF202020,
//                             ),
//                           ),
//                         ),

//                         SizedBox(height: 5.h),

//                         Row(
//                           children: [
//                             Icon(
//                               Icons
//                                   .verified_outlined,
//                               size: 13.sp,
//                               color: Colors
//                                   .grey.shade500,
//                             ),

//                             SizedBox(width: 4.w),

//                             Flexible(
//                               child: Text(
//                                 listing.statusLabel
//                                         .isNotEmpty
//                                     ? listing
//                                         .statusLabel
//                                     : 'Property',
//                                 maxLines: 1,
//                                 overflow: TextOverflow
//                                     .ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 10.5.sp,
//                                   color: Colors
//                                       .grey.shade600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   SizedBox(width: 8.w),

//                   _buildStatusBadge(),
//                 ],
//               ),

//               SizedBox(height: 15.h),

//               Divider(
//                 height: 1,
//                 color: Colors.grey.shade200,
//               ),

//               SizedBox(height: 14.h),

//               // ==================================================
//               // PLAN NAME
//               // ==================================================

//               _buildInfoRow(
//                 icon: Icons
//                     .workspace_premium_outlined,
//                 title: 'Plan',
//                 value: plan.name.trim().isNotEmpty
//                     ? plan.name
//                     : '-',
//               ),

//               SizedBox(height: 12.h),

//               // ==================================================
//               // FEATURED LOCATION
//               // ==================================================

//               _buildInfoRow(
//                 icon: Icons
//                     .location_on_outlined,
//                 title: 'Featured On',
//                 value: property
//                         .locationLabel.isNotEmpty
//                     ? property.locationLabel
//                     : '-',
//               ),

//               SizedBox(height: 12.h),

//               // ==================================================
//               // DURATION
//               // ==================================================

//               _buildInfoRow(
//                 icon: Icons.timelapse_rounded,
//                 title: 'Duration',
//                 value: plan.durationDays > 0
//                     ? '${plan.durationDays} Days'
//                     : plan.durationLabel.isNotEmpty
//                         ? plan.durationLabel
//                         : '-',
//               ),

//               SizedBox(height: 12.h),

//               // ==================================================
//               // AMOUNT
//               // ==================================================

//               _buildInfoRow(
//                 icon: Icons.payments_outlined,
//                 title: 'Paid Amount',
//                 value:
//                     property.formattedPaidAmount,
//               ),

//               SizedBox(height: 12.h),

//               // ==================================================
//               // PAYMENT STATUS
//               // ==================================================

//               _buildInfoRow(
//                 icon:
//                     Icons.receipt_long_outlined,
//                 title: 'Payment Status',
//                 value: property
//                         .paymentStatusLabel
//                         .isNotEmpty
//                     ? property
//                         .paymentStatusLabel
//                     : '-',
//               ),

//               // ==================================================
//               // DATES
//               // ==================================================

//               if (property.startDate != null ||
//                   property.endDate != null) ...[
//                 SizedBox(height: 15.h),

//                 Divider(
//                   height: 1,
//                   color: Colors.grey.shade200,
//                 ),

//                 SizedBox(height: 14.h),

//                 Row(
//                   children: [
//                     if (property.startDate !=
//                         null)
//                       Expanded(
//                         child: _buildDateBox(
//                           icon: Icons
//                               .play_circle_outline_rounded,
//                           title: 'Started',
//                           date:
//                               property.startDate!,
//                         ),
//                       ),

//                     if (property.startDate !=
//                             null &&
//                         property.endDate !=
//                             null)
//                       SizedBox(width: 10.w),

//                     if (property.endDate !=
//                         null)
//                       Expanded(
//                         child: _buildDateBox(
//                           icon: Icons
//                               .event_outlined,
//                           title: 'Ends',
//                           date:
//                               property.endDate!,
//                         ),
//                       ),
//                   ],
//                 ),
//               ],

//               // ==================================================
//               // ACTIVE / EXPIRED INFORMATION
//               // ==================================================

//               if (property.isCurrentlyActive) ...[
//                 SizedBox(height: 13.h),

//                 Container(
//                   width: double.infinity,
//                   padding:
//                       EdgeInsets.symmetric(
//                     horizontal: 11.w,
//                     vertical: 10.h,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary
//                         .withOpacity(.045),
//                     borderRadius:
//                         BorderRadius.circular(
//                       8.r,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.schedule_outlined,
//                         size: 15.sp,
//                         color:
//                             AppColors.primary,
//                       ),

//                       SizedBox(width: 7.w),

//                       Expanded(
//                         child: Text(
//                           property.remainingDays >
//                                   0
//                               ? '${property.remainingDays} days remaining'
//                               : 'Ends today',
//                           style: TextStyle(
//                             fontSize: 10.5.sp,
//                             fontWeight:
//                                 FontWeight.w600,
//                             color: AppColors
//                                 .primary,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],

//               if (property.isExpired) ...[
//                 SizedBox(height: 13.h),

//                 Container(
//                   width: double.infinity,
//                   padding:
//                       EdgeInsets.symmetric(
//                     horizontal: 11.w,
//                     vertical: 10.h,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.grey
//                         .withOpacity(.08),
//                     borderRadius:
//                         BorderRadius.circular(
//                       8.r,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons
//                             .history_toggle_off_rounded,
//                         size: 15.sp,
//                         color:
//                             Colors.grey.shade600,
//                       ),

//                       SizedBox(width: 7.w),

//                       Text(
//                         'This featured plan has expired',
//                         style: TextStyle(
//                           fontSize: 10.5.sp,
//                           fontWeight:
//                               FontWeight.w600,
//                           color: Colors
//                               .grey.shade700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // STATUS BADGE
//   // ============================================================

//   Widget _buildStatusBadge() {
//     String text;
//     Color color;

//     if (property.isExpired) {
//       text = 'Expired';
//       color = Colors.grey.shade600;
//     } else if (property.isCurrentlyActive) {
//       text = 'Active';
//       color = const Color(0xFF258A57);
//     } else if (property.isFailed) {
//       text = 'Failed';
//       color = Colors.red.shade600;
//     } else if (property.isPaid) {
//       text = 'Paid';
//       color = const Color(0xFF258A57);
//     } else {
//       text = property
//               .paymentStatusLabel.isNotEmpty
//           ? property.paymentStatusLabel
//           : 'Pending';

//       color = Colors.orange.shade700;
//     }

//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 9.w,
//         vertical: 5.h,
//       ),
//       decoration: BoxDecoration(
//         color: color.withOpacity(.10),
//         borderRadius:
//             BorderRadius.circular(20.r),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 9.sp,
//           fontWeight: FontWeight.w700,
//           color: color,
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // INFO ROW
//   // ============================================================

//   Widget _buildInfoRow({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return Row(
//       crossAxisAlignment:
//           CrossAxisAlignment.center,
//       children: [
//         Container(
//           width: 34.w,
//           height: 34.w,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: AppColors.primary
//                 .withOpacity(.055),
//             borderRadius:
//                 BorderRadius.circular(8.r),
//           ),
//           child: Icon(
//             icon,
//             size: 17.sp,
//             color: AppColors.primary,
//           ),
//         ),

//         SizedBox(width: 10.w),

//         Expanded(
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 9.5.sp,
//                   color: Colors.grey.shade500,
//                 ),
//               ),

//               SizedBox(height: 2.h),

//               Text(
//                 value,
//                 maxLines: 2,
//                 overflow:
//                     TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontSize: 11.5.sp,
//                   height: 1.25,
//                   fontWeight:
//                       FontWeight.w600,
//                   color: const Color(
//                     0xFF333333,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ============================================================
//   // DATE BOX
//   // ============================================================

//   Widget _buildDateBox({
//     required IconData icon,
//     required String title,
//     required DateTime date,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(10.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8F8FA),
//         borderRadius:
//             BorderRadius.circular(8.r),
//         border: Border.all(
//           color: const Color(0xFFEEEEF2),
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             size: 16.sp,
//             color: AppColors.primary,
//           ),

//           SizedBox(width: 7.w),

//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 8.5.sp,
//                     color:
//                         Colors.grey.shade500,
//                   ),
//                 ),

//                 SizedBox(height: 3.h),

//                 Text(
//                   _formatDate(date),
//                   maxLines: 1,
//                   overflow:
//                       TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 10.sp,
//                     fontWeight:
//                         FontWeight.w700,
//                     color: const Color(
//                       0xFF333333,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // FORMAT DATE
//   // ============================================================

//   String _formatDate(
//     DateTime date,
//   ) {
//     const List<String> months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];

//     final DateTime localDate =
//         date.toLocal();

//     return '${localDate.day} '
//         '${months[localDate.month - 1]} '
//         '${localDate.year}';
//   }
// }
class _FeaturedPropertyCard extends StatelessWidget {
  final MyFeaturedProperty property;

  const _FeaturedPropertyCard({
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    final listing = property.listing;
    final plan = property.plan;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFEBEBEF),
        ),
      ),
      child: Row(
        children: [
          // ICON
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.07),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.home_work_outlined,
              size: 21.sp,
              color: AppColors.primary,
            ),
          ),

          SizedBox(width: 11.w),

          // DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.propertyName.isNotEmpty
                      ? listing.propertyName
                      : 'Property',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF202020),
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  plan.name.isNotEmpty
                      ? plan.name
                      : '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: 5.h),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 12.sp,
                      color: AppColors.primary,
                    ),

                    SizedBox(width: 3.w),

                    Flexible(
                      child: Text(
                        property.locationLabel.isNotEmpty
                            ? property.locationLabel
                            : '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9.5.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                    SizedBox(width: 8.w),

                    if (property.isCurrentlyActive)
                      Text(
                        property.remainingDays > 0
                            ? '${property.remainingDays} days left'
                            : 'Ends today',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // STATUS
          _statusBadge(),
        ],
      ),
    );
  }

  Widget _statusBadge() {
    String text;
    Color color;

    if (property.isExpired) {
      text = 'Expired';
      color = Colors.grey;
    } else if (property.isCurrentlyActive) {
      text = 'Active';
      color = const Color(0xFF258A57);
    } else if (property.isFailed) {
      text = 'Failed';
      color = Colors.red;
    } else if (property.isPaid) {
      text = 'Paid';
      color = const Color(0xFF258A57);
    } else {
      text = property.paymentStatusLabel.isNotEmpty
          ? property.paymentStatusLabel
          : 'Pending';

      color = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 8.5.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}