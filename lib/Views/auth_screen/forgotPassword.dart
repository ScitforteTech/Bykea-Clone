import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';
import 'package:vroom_ride_app/Resources/customComponents.dart';
import 'package:vroom_ride_app/components/customButton.dart';

class ResetPassword extends StatelessWidget {
  TextEditingController resPassword = TextEditingController();

  ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(CustomSize().customWidth(context) / 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: myBackButton(context),
                    ),
                  ],
                ),
                Center(
                  child: Image.asset(
                    "assets/images/logo.jpeg",
                    scale: CustomSize().customWidth(context) / 30,
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 12),
                Text(
                  'Reset Password',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: CustomSize().customWidth(context) / 16,
                  ),
                ),
                constant.mySizedBox(context, 0, 0.03),
                Text(
                  'Please enter your email address to request a password reset',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: CustomSize().customWidth(context) / 20,
                  ),
                ),
                constant.mySizedBox(context, 0, 0.03),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: TextField(
                    cursorColor: Colors.black,
                    obscureText: false,
                    enableSuggestions: true,
                    controller: resPassword,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customWidth(context) / 30),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 31, 164, 100),
                          width: CustomSize().customWidth(context) / 200,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customWidth(context) / 30),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 31, 164, 100),
                          width: CustomSize().customWidth(context) / 200,
                        ),
                      ),
                    ),
                  ),
                ),
                constant.mySizedBox(context, 0, 0.05),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the button
                  children: [
                    Expanded(
                      // Prevents overflow
                      child: CustomButton(
                        textColor: Colors.black,
                        radius: CustomSize().customWidth(context) / 40,
                        height: CustomSize().customHeight(context) / 12,
                        width: CustomSize().customWidth(context) *
                            0.8, // Adjust width
                        title: "SEND NEW PASSWORD",
                        color: const Color.fromARGB(255, 31, 164, 100),
                        loading: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
