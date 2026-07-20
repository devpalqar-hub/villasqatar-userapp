import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/modules/chats/models/chat_lsit_model.dart';
import 'package:villas_qatar/modules/chats/service/chat_controller.dart';
import 'package:villas_qatar/modules/chats/widgets/empty_conversation_widget.dart';
import 'package:villas_qatar/modules/chats/widgets/input_bar.dart';
import 'package:villas_qatar/modules/chats/widgets/intrested_propert_card.dart';
import 'package:villas_qatar/modules/chats/widgets/quick_replay_Section.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

class ChatStartScreen extends StatelessWidget {
  final Listing? listing;
  final Property? property;
  final String? initialMessage;
  final bool showPropertyCard;

  const ChatStartScreen({
    super.key,
    this.property,
    this.initialMessage,
    this.listing,
    this.showPropertyCard = true,
  });
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    if (initialMessage != null && controller.messageController.text.isEmpty) {
      controller.messageController.text = initialMessage!;
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12.h),
            if (showPropertyCard && property != null) ...[
              SizedBox(height: 12.h),
              InterestedPropertyCard(property: property!),
            ],

            /// Empty State
            Expanded(
              child: GetBuilder<ChatController>(
                builder: (controller) {
                  if (controller.messages.isEmpty) {
                    return const EmptyConversationWidget();
                  }

                  return ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.all(16.w),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      final isMe = message.sender.id == controller.myUserId;
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!isMe) ...[
                                CircleAvatar(
                                  radius: 16.r,
                                  backgroundColor: AppColors.primarySoft,
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.primary,
                                    size: 16.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                              ],

                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * .72,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? AppColors.primarySoft
                                        : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(18.r),
                                      topRight: Radius.circular(18.r),
                                      bottomLeft: Radius.circular(
                                        isMe ? 18.r : 4.r,
                                      ),
                                      bottomRight: Radius.circular(
                                        isMe ? 4.r : 18.r,
                                      ),
                                    ),
                                    border: isMe
                                        ? null
                                        : Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!isMe &&
                                          (message.sender.name?.isNotEmpty ??
                                              false))
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 4.h),
                                          child: Text(
                                            message.sender.name!,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),

                                      _buildMessageContent(message, isMe),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            /// Suggestions
            QuickReplySection(
              onTap: (text) {
                controller.messageController.text = text;
              },
            ),

            Divider(height: 1.h),

            /// Input
            InputBar(controller: controller),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(dynamic message, bool isMe) {
    final textColor = isMe ? Colors.black : Colors.black87;

    switch (message.type) {
      case "TEXT":
        return Text(
          message.content ?? "",
          style: TextStyle(fontSize: 14.sp, color: textColor),
        );

      case "IMAGE":
        return ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.network(
            message.mediaUrl ?? "",
            width: 220.w,
            fit: BoxFit.cover,
            errorBuilder: (_, error, __) {
              return Text(
                "Image unavailable",
                style: TextStyle(color: textColor),
              );
            },
          ),
        );

      case "LOCATION":
        final lat = message.latitude;
        final lng = message.longitude;

        return InkWell(
          borderRadius: BorderRadius.circular(10.r),
          onTap: () async {
            final url =
                "https://www.google.com/maps/search/?api=1&query=$lat,$lng";

            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
            }
          },
          child: Container(
            width: 230.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  /// Map Preview
                  Stack(
                    children: [
                      Image.asset(
                        "assets/map_placeholder.jpg",
                        width: double.infinity,
                        height: 145.h,
                        fit: BoxFit.cover,
                      ),

                      Container(
                        height: 145.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(.15),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        top: 10.h,
                        left: 10.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppColors.primary,
                                size: 15.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "Location",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        right: 12.w,
                        bottom: 12.h,
                        child: Material(
                          color: AppColors.primary,
                          shape: const CircleBorder(),
                          elevation: 6,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () async {
                              final url =
                                  "https://www.google.com/maps/search/?api=1&query=$lat,$lng";

                              await launchUrl(
                                Uri.parse(url),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10.w),
                              child: Icon(
                                Icons.navigation_rounded,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

      default:
        return Text(
          message.content ?? "",
          style: TextStyle(fontSize: 14.sp, color: textColor),
        );
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: .5,
      shadowColor: AppColors.divider,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back, color: AppColors.primary),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primarySoft,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                property?.createdBy.name.isNotEmpty == true
                    ? property!.createdBy.name
                    : "Seller",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
              Text(
                property?.createdBy.role
                        .replaceAll("_", " ")
                        .split(" ")
                        .map(
                          (e) => e.isEmpty
                              ? e
                              : e[0].toUpperCase() +
                                    e.substring(1).toLowerCase(),
                        )
                        .join(" ") ??
                    "Property Consultant",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () async {
            final phoneNumber = listing?.contactPhone;

            debugPrint("DIAL NUMBER: $phoneNumber");

            if (phoneNumber == null || phoneNumber.trim().isEmpty) return;

            final uri = Uri(scheme: 'tel', path: phoneNumber.trim());

            await launchUrl(uri, mode: LaunchMode.externalApplication);
          },
          icon: const Icon(Icons.call, color: AppColors.primary),
        ),
      ],
    );
  }
}
