import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';

import '../Resources/CustomSize.dart';

class CustomButton extends StatelessWidget {
  String title;
  final VoidCallback? onTap;
  final VoidCallback? onButtonPressed;
  final VoidCallback? onButtonReleased;
  bool loading;
  double height;
  Color textColor;
  double width;
  Color? color;
  double radius;
  double? fontSize;
  bool? enableMarquee;
  IconData? icon;

  CustomButton(
      {super.key,
      required this.textColor,
      required this.radius,
      this.color,
      required this.height,
      required this.width,
      required this.title,
      this.onTap,
      this.onButtonReleased,
      this.onButtonPressed,
      required this.loading,
      this.enableMarquee,
      this.fontSize,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: (_) {
        // Trigger the onButtonPressed when long press starts
        onButtonPressed?.call();
      },
      // onLongPressStart: (_) {
      //   // Trigger the onButtonPressed when long press starts
      //   onButtonPressed?.call();
      // },
      // onLongPressEnd: (_) {
      //   // Trigger the onButtonReleased when long press ends
      //   onButtonReleased?.call();
      // },
      onTapUp: (_) {
        // Trigger the onButtonReleased when long press ends
        onButtonReleased?.call();
      },
      // onTapCancel: onButtonReleased,
      onTapCancel: () {
        onButtonReleased?.call();
      },
      child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          child: Center(
            child: loading
                ? CircularProgressIndicator(
                    strokeWidth: CustomSize().customWidth(context) / 200,
                    color: textColor,
                  )
                : (enableMarquee == true && title != 'Select Ch.')
                    ? Marquee(
                        text: title,
                        velocity: 20.0,
                        blankSpace: 20.0,
                      )
                    : icon != null
                        ? Icon(
                            icon,
                            color: Colors.white,
                            size: CustomSize().customWidth(context) / 12,
                          )
                        : FittedBox(
                          fit: BoxFit.scaleDown, 
                          child: Text(
                              title,
                              style: GoogleFonts.poppins(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: fontSize ??
                                    CustomSize().customWidth(context) / 22,
                              ),
                            ),
                        ),
          )),
    );
  }
}
