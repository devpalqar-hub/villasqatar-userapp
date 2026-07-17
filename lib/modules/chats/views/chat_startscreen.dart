import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/modules/chats/service/chat_controller.dart';
import 'package:villas_qatar/modules/chats/widgets/empty_conversation_widget.dart';
import 'package:villas_qatar/modules/chats/widgets/input_bar.dart';
import 'package:villas_qatar/modules/chats/widgets/intrested_propert_card.dart';
import 'package:villas_qatar/modules/chats/widgets/quick_replay_Section.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

class ChatStartScreen extends StatelessWidget {
  final Property? property;
  final String? initialMessage;
  final bool showPropertyCard;

  const ChatStartScreen({
    super.key,
    this.property,
    this.initialMessage,
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
            const SizedBox(height: 12),
            if (showPropertyCard && property != null) ...[
              const SizedBox(height: 12),
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
                                const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColors.primarySoft,
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.primary,
                                    size: 16,
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
                                        ? AppColors.primary
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

                                      Text(
                                        message.content ?? "",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: isMe
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
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

            const Divider(height: 1),

            /// Input
            InputBar(controller: controller),
          ],
        ),
      ),
    );
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
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primarySoft,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
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
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
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
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.call, color: AppColors.primary),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }
}
