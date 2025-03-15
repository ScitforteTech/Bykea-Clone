import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';
import 'package:vroom_ride_app/Resources/customComponents.dart';
import 'package:vroom_ride_app/Views/auth_screen/verificationCode.dart';
import 'package:vroom_ride_app/components/customButton.dart';
import 'package:vroom_ride_app/welcomePage.dart';

class PhoneRegistration extends StatelessWidget {
  final TextEditingController phoneNumberController = TextEditingController();

  PhoneRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(CustomSize().customWidth(context) / 20),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        // Get.back();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyWelcomeView()));
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
                SizedBox(height: CustomSize().customHeight(context) / 18),
                Text(
                  'Registration',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: CustomSize().customWidth(context) / 16,
                  ),
                ),
                constant.mySizedBox(context, 0, 0.03),
                Text(
                  'Enter your phone number to verify your account',
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
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      prefixIcon: const Icon(Icons.phone),
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
                Center(
                  child: SizedBox(
                    // width: CustomSize().customWidth(context) * 0.8, // Adjust width to avoid overflow
                    child: CustomButton(
                      textColor: Colors.black,
                      radius: CustomSize().customWidth(context) / 40,
                      height: CustomSize().customHeight(context) / 12,
                      width: CustomSize().customWidth(context),
                      title: "SEND",
                      color: const Color.fromARGB(255, 31, 164, 100),
                      loading: false,
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VerficationCode()));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
