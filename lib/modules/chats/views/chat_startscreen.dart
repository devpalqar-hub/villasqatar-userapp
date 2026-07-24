import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:villas_qatar/modules/support/service/support_ticket_controller.dart';

class ChatStartScreen extends StatelessWidget {
  final Listing? listing;
  final Property? property;
  final String? initialMessage;
  final bool showPropertyCard;
  final String? otherUserId;

  const ChatStartScreen({
    super.key,
    this.property,
    this.initialMessage,
    this.listing,
    this.showPropertyCard = true,
    this.otherUserId,
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

            /// QUICK REPLIES
            /// Show only when conversation has NOT started yet
            GetBuilder<ChatController>(
              builder: (chatController) {
                if (chatController.messages.isNotEmpty) {
                  return const SizedBox.shrink();
                }

                return QuickReplySection(
                  onTap: (text) {
                    chatController.messageController.text = text;

                    /// Move cursor to end
                    chatController.messageController.selection =
                        TextSelection.collapsed(offset: text.length);
                  },
                );
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
        /// CALL
        IconButton(
          onPressed: () async {
            final phoneNumber = listing?.contactPhone ?? property?.contactPhone;

            debugPrint("DIAL NUMBER: $phoneNumber");

            if (phoneNumber == null || phoneNumber.trim().isEmpty) {
              return;
            }

            final uri = Uri(scheme: 'tel', path: phoneNumber.trim());

            await launchUrl(uri, mode: LaunchMode.externalApplication);
          },
          icon: const Icon(Icons.call, color: AppColors.primary),
        ),

        /// MORE OPTIONS
        PopupMenuButton<String>(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          icon: const Icon(Icons.more_vert_rounded, color: AppColors.primary),
          onSelected: (value) {
            if (value == "report") {
              _showReportUserSheet();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: "report",
              child: Row(
                children: [
                  Icon(
                    Icons.flag_outlined,
                    color: Colors.red.shade600,
                    size: 20.sp,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "Report User",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(width: 4.w),
      ],
    );
  }

  Future<void> _showReportUserSheet() async {
    final ChatController chatController = Get.find<ChatController>();

    /// 1. Explicitly passed other user
    final String passedUserId = otherUserId?.trim() ?? "";

    /// 2. Property owner if property exists
    final String propertyOwnerId =
        property?.createdBy.id.toString().trim() ?? "";

    /// 3. Other participant from active conversation
    final String conversationOtherUserId = chatController.otherUserId.trim();

    /// Select best available ID
    final String reportedUserId = passedUserId.isNotEmpty
        ? passedUserId
        : propertyOwnerId.isNotEmpty
        ? propertyOwnerId
        : conversationOtherUserId;

    debugPrint("========== REPORT USER ==========");

    debugPrint("MY USER ID: ${chatController.myUserId}");

    debugPrint("PASSED OTHER USER ID: $passedUserId");

    debugPrint("PROPERTY OWNER ID: $propertyOwnerId");

    debugPrint(
      "CONVERSATION OTHER USER ID: "
      "$conversationOtherUserId",
    );

    debugPrint("FINAL REPORTED USER ID: $reportedUserId");

     if (reportedUserId.isEmpty) {
    Fluttertoast.showToast(
      msg: "Unable to identify the user",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    return;
  }
  await Get.bottomSheet(
    ReportUserBottomSheet(
      reportedUserId: reportedUserId,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,

    /// Important:
    /// prevents swipe-dismiss/focus conflicts while
    /// TextField is active.
    enableDrag: false,
    isDismissible: true,
  );
  }

    // Keep the remaining bottom-sheet code exactly as it is...
}
class ReportUserBottomSheet extends StatefulWidget {
  final String reportedUserId;

  const ReportUserBottomSheet({
    super.key,
    required this.reportedUserId,
  });

  @override
  State<ReportUserBottomSheet> createState() =>
      _ReportUserBottomSheetState();
}

class _ReportUserBottomSheetState
    extends State<ReportUserBottomSheet> {
  late final TextEditingController _detailsController;
  late final FocusNode _detailsFocusNode;

  String? _selectedReason;
  bool _isSubmitting = false;

  final List<String> _reasons = const [
    "Fake profile",
    "Fraud or scam",
    "Inappropriate behavior",
    "Spam or unwanted messages",
    "Misleading information",
    "Other",
  ];

  @override
  void initState() {
    super.initState();

    _detailsController = TextEditingController();
    _detailsFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _detailsFocusNode.dispose();
    _detailsController.dispose();

    super.dispose();
  }

  Future<void> _closeSheet() async {
    /// Remove focus without using a deactivated BuildContext.
    _detailsFocusNode.unfocus();

    if (!mounted) return;

    Navigator.of(context).pop();
  }

  Future<void> _submitReport() async {
    if (_selectedReason == null) {
      Fluttertoast.showToast(
        msg: "Please select a reason",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (_isSubmitting) return;

    /// Remove keyboard before starting async work.
    _detailsFocusNode.unfocus();

    setState(() {
      _isSubmitting = true;
    });

    final String details =
        _detailsController.text.trim();

    final String message =
        details.isNotEmpty
            ? details
            : _selectedReason!;

    final SupportTicketController support =
        Get.isRegistered<SupportTicketController>()
            ? Get.find<SupportTicketController>()
            : Get.put(
                SupportTicketController(),
              );

    debugPrint(
      "========== SUBMIT REPORT USER ==========",
    );
    debugPrint(
      "REPORTED USER ID: ${widget.reportedUserId}",
    );

    final result = await support.createTicket(
      category: SupportCategory.reportUser,
      subject: _selectedReason!,
      message: message,
      reportedUserId: widget.reportedUserId,
    );

    /// VERY IMPORTANT:
    /// Async operation may finish after widget is removed.
    if (!mounted) return;

    if (result != null) {
      /// Close using this sheet's own valid context.
      Navigator.of(context).pop();

      /// Show toast after this frame.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Fluttertoast.showToast(
            msg: "Report submitted successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        },
      );

      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    Fluttertoast.showToast(
      msg: support.createError.isNotEmpty
          ? support.createError
          : "Unable to submit report",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  @override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
    child: Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: EdgeInsets.fromLTRB(
        20.w,
        18.h,
        20.w,
        MediaQuery.of(context).padding.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // DRAG HANDLE
            // ==================================================

            Center(
              child: Container(
                width: 45.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),

            SizedBox(height: 18.h),

            // ==================================================
            // HEADER
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: Text(
                    "Report User",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),

                InkWell(
                  borderRadius: BorderRadius.circular(50.r),
                  onTap: _isSubmitting ? null : _closeSheet,
                  child: Container(
                    width: 34.w,
                    height: 34.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 19.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 6.h),

            Text(
              "Tell us why you're reporting this user.",
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.4,
                color: Colors.grey.shade600,
              ),
            ),

            SizedBox(height: 22.h),

            // ==================================================
            // REASON TITLE
            // ==================================================

            Text(
              "Reason for Report",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 12.h),

            // ==================================================
            // REASON OPTIONS
            // ==================================================
              // ==================================================
// REASON OPTIONS - COLUMN LIST
// ==================================================

Column(
  children: _reasons.map((reason) {
    final bool selected = _selectedReason == reason;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: _isSubmitting
            ? null
            : () {
                _detailsFocusNode.unfocus();

                setState(() {
                  _selectedReason = reason;
                });
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withOpacity(.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.fieldBorder,
              width: selected ? 1.2 : 1,
            ),
          ),
          child: Row(
            children: [
              // =====================================
              // REASON TEXT
              // =====================================

              Expanded(
                child: Text(
                  reason,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: selected
                        ? AppColors.primary
                        : Colors.black87,
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // =====================================
              // RADIO ICON
              // =====================================

              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 150,
                ),
                child: Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  key: ValueKey(selected),
                  size: 21.sp,
                  color: selected
                      ? AppColors.primary
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }).toList(),
),
            // ==================================================
            // ADDITIONAL DETAILS
            // ==================================================

            Row(
              children: [
                Text(
                  "Additional Details",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(width: 5.w),

                Text(
                  "(Optional)",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            TextField(
              controller: _detailsController,
              focusNode: _detailsFocusNode,
              maxLines: 4,
              maxLength: 500,
              enabled: !_isSubmitting,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: "Describe the issue",
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade500,
                ),

                filled: true,
                fillColor: Colors.white,

                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.fieldBorder,
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.fieldBorder,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // ==================================================
            // INFO BOX
            // ==================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(.12),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18.sp,
                    color: AppColors.primary,
                  ),

                  SizedBox(width: 9.w),

                  Expanded(
                    child: Text(
                      "Your report will be reviewed by our support team.",
                      style: TextStyle(
                        fontSize: 11.sp,
                        height: 1.4,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // ==================================================
            // SUBMIT BUTTON
            // Same style as Book Visit
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed:
                    _isSubmitting ? null : _submitReport,

                style: ElevatedButton.styleFrom(
                  elevation: 0,

                  backgroundColor: AppColors.primary,

                  disabledBackgroundColor:
                      AppColors.primary.withOpacity(.6),

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),

                child: _isSubmitting
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child:
                            const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        "Submit Report",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}}