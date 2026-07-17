import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/modules/chats/models/chat_lsit_model.dart';
import 'package:villas_qatar/modules/chats/service/chat_list_controller.dart';
import 'package:villas_qatar/modules/chats/views/chat_startscreen.dart';

import '../service/chat_controller.dart';
import 'chatscreen.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});

  final ChatListController controller = Get.put(ChatListController());

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatListController());
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              _buildTopBar(),

              SizedBox(height: 6.h),

              Container(
                height: 38.h,
                decoration: BoxDecoration(
                  color: AppColors.fieldBg,
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(color: AppColors.fieldBorder),
                ),
                child: TextField(
                  onChanged: controller.searchConversation,
                  decoration: const InputDecoration(
                    hintText: "Search by property or seller",
                    prefixIcon: Icon(Icons.search, color: AppColors.hintGrey),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),

              SizedBox(height: 6.h),

              Expanded(
                child: GetBuilder<ChatListController>(
                  builder: (controller) {
                    if (controller.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.filteredConversations.isEmpty) {
                      return const Center(child: Text("No Conversations"));
                    }

                    return RefreshIndicator(
                      onRefresh: controller.refreshList,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        itemCount: controller.filteredConversations.length,
                        itemBuilder: (_, index) {
                          final conversation =
                              controller.filteredConversations[index];

                          final seller = conversation.participants.firstWhere(
                            (e) => e.user.id != conversation.user.id,
                          );

                          return _ConversationTile(
                            conversation: conversation,
                            participant: seller,
                            onTap: () {
                              if (Get.isRegistered<ChatController>()) {
                                Get.delete<ChatController>(force: true);
                              }

                              Get.put(
                                ChatController(
                                  listingId: conversation.listing.id,
                                  initialConversationId: conversation.id,
                                ),
                              );

                              Get.to(() => const ChatStartScreen());
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              'My Chats',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.tune, color: AppColors.primary),
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ChatListModel conversation;
  final Participant participant;
  final VoidCallback onTap;

  const _ConversationTile({
    super.key,
    required this.conversation,
    required this.participant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final message = conversation.lastMessage;
    final bool unread = false;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.fieldBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: conversation.listing.image.isNotEmpty
                  ? Image.network(
                      conversation.listing.image,
                      width: 52.w,
                      height: 52.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, error, stackTrace) {
                        debugPrint("Image Error: $error");
                        debugPrint("Image URL: ${conversation.listing.image}");
                        return _placeholder();
                      },
                    )
                  : _placeholder(),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.otherParticipant?.user.name ?? "Seller",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      SizedBox(width: 8.w),

                      Text(
                        _formatTime(conversation.updatedAt),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: unread
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  /// Property Type
                  Text(
                    "${conversation.listing.type} • ${conversation.listing.purpose}",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  /// Last Message
                  Text(
                    message?.content ?? "No Message",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  /// Property Name
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.08),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      conversation.listing.propertyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 52.w,
      height: 52.w,
      color: AppColors.primarySoft,
      child: Icon(Icons.home, color: AppColors.primary, size: 24.sp),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();

    if (now.year == date.year &&
        now.month == date.month &&
        now.day == date.day) {
      return DateFormat("hh:mm a").format(date);
    }

    if (now.difference(date).inDays == 1) {
      return "Yesterday";
    }

    if (now.difference(date).inDays < 7) {
      return DateFormat("EEE").format(date);
    }

    return DateFormat("dd MMM").format(date);
  }
}
