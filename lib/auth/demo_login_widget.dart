import 'package:flutter/material.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:nlytical/utils/size_config.dart';

Widget forDemoField({
  required bool isForEmail,
  required String email,
  required String phone,
  required String pwdOtp,
  required Function() onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Appcolors.appPriSecColor.appPrimblue.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Text(
            'For Demo',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(height: 1, decoration: BoxDecoration(color: Colors.white)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14).copyWith(top: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  isForEmail ? "Email : $email" : 'Mobile Number : $phone',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(onTap: onTap, child: Icon(Icons.copy_rounded, size: 23)),
            ],
          ),
        ),
        sizeBoxHeight(3),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ).copyWith(bottom: 14),
          child: Text(
            isForEmail ? 'Password : $pwdOtp' : 'OTP : $pwdOtp',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
