import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/modules/chat/model/chatmessage_model.dart';
import 'package:villas_qatar/modules/chat/views/chatscreen.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});

  final List<Conversation> _conversations = const [
    Conversation(
      name: 'Ahmed Al-Mansoori',
      role: 'Property Consultant',
      lastMessage: 'Thank you! I will discuss this with the seller...',
      time: '10:36 AM',
      online: true,
      unreadCount: 0,
      propertyPrice: 'QAR 5,250,000',
    ),
    Conversation(
      name: 'Fatima Al-Sayed',
      role: 'Leasing Agent',
      lastMessage: 'The apartment is available for viewing tomorrow.',
      time: '9:12 AM',
      online: true,
      unreadCount: 2,
      propertyPrice: 'QAR 1,850,000',
    ),
    Conversation(
      name: 'Omar Khalid',
      role: 'Property Consultant',
      lastMessage: 'I have sent the updated payment plan document.',
      time: 'Yesterday',
      online: false,
      unreadCount: 0,
    ),
    Conversation(
      name: 'Layla Hassan',
      role: 'Sales Manager',
      lastMessage: 'Sure, let\'s schedule the visit for Friday afternoon.',
      time: 'Yesterday',
      online: false,
      unreadCount: 1,
      propertyPrice: 'QAR 3,400,000',
    ),
    Conversation(
      name: 'Yousef Al-Rashid',
      role: 'Property Consultant',
      lastMessage: 'Your offer has been forwarded to the seller.',
      time: 'Mon',
      online: true,
      unreadCount: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            spacing: 12.h,
            children: [
              _buildTopBar(),
              Container(
                height: 38, // Reduce height (try 40-44)
                decoration: BoxDecoration(
                  color: AppColors.fieldBg,
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(color: AppColors.fieldBorder),
                ),
                child: TextField(
                  // controller: searchCtrl,
                  // onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                  decoration: const InputDecoration(
                    hintText: 'Search by property name or location',
                    hintStyle: TextStyle(
                      color: AppColors.hintGrey,
                      fontSize: 12,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.hintGrey,
                      size: 18,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),

              _buildFilterChips(),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: _conversations.length,
                  itemBuilder: (context, i) {
                    final c = _conversations[i];
                    return _ConversationTile(
                      conversation: c,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 800,
                            ),
                            reverseTransitionDuration: const Duration(
                              milliseconds: 350,
                            ),
                            pageBuilder: (_, animation, __) =>
                                const ChatScreen(),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(1.0, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
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
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  String activeFilter = "All";

  final List<String> filters = ["All", "Unread", "Offers", "Archived"];

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
            // onTap: () => setState(() => activeFilter = label),
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
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const _ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final unread = conversation.unreadCount > 0;

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
            /// Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: AppColors.primarySoft,
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 22.sp,
                  ),
                ),
                if (conversation.online)
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(width: 12.w),

            /// Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name & Time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.name,
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
                        conversation.time,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: unread
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: unread
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  /// Role
                  Text(
                    conversation.role,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  /// Message & Badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),

                      if (unread) ...[
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            '${conversation.unreadCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  if (conversation.propertyPrice != null) ...[
                    SizedBox(height: 6.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(.08),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          conversation.propertyPrice!,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
