import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';

class AgentContactButtons extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onEmail;

  const AgentContactButtons({
    super.key,
     required this.onCall,
    required this.onWhatsApp,
    required this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: _contactButton(
  FaIcon(
    FontAwesomeIcons.phone,
    size: 20,
  ),
  "Call",
  () {
    // WhatsApp action
  },
)
        ),

        SizedBox(width: 12.w),

       Expanded(
  child: _contactButton(
  FaIcon(
    FontAwesomeIcons.whatsapp,
    size: 20,
  ),
  "WhatsApp",
  () {
    // WhatsApp action
  },
)
),
        SizedBox(width: 12.w),

        Expanded(
          child:_contactButton(
  FaIcon(
    FontAwesomeIcons.mailchimp,
    size: 20,
  ),
  "Email",
  () {
    // WhatsApp action
  },
)
        ),
      ],
    );
  }

Widget _contactButton(
  Widget icon,
  String text,
  VoidCallback onTap,
) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: [
        icon,
        const SizedBox(width: 8),
        Text(text),
      ],
    ),
  );
}
 
}