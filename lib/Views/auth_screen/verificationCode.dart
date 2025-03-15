import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';
import 'package:vroom_ride_app/Resources/customComponents.dart';
import 'package:vroom_ride_app/Views/auth_screen/phoneRegistration.dart';

class VerficationCode extends StatefulWidget {
  const VerficationCode({super.key});

  @override
  State<VerficationCode> createState() => _VerficationCodeState();
}

class _VerficationCodeState extends State<VerficationCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(CustomSize().customWidth(context) / 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.pop(context);
                        // Get.back();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneRegistration()));
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
                  'Verification Code',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: CustomSize().customWidth(context) / 16,
                  ),
                ),
                Text(
                  'Please type the verification code sent to your phone',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: CustomSize().customWidth(context) / 22,
                  ),
                ),
                constant.mySizedBox(context, 0, 0.08),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Pinput(
                    length: 6,
                    onChanged: (value) {
                      if (value.length == 6) {
                        // Only trigger function when all fields are filled
                      }
                    },
                    defaultPinTheme: PinTheme(
                      width: CustomSize().customWidth(context) / 5,
                      height: CustomSize().customHeight(context) / 10,
                      textStyle: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 31, 164, 100),
                          fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: CustomSize().customWidth(context) / 150,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(
                            CustomSize().customWidth(context) / 30),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: CustomSize().customWidth(context) / 5,
                      height: CustomSize().customHeight(context) / 10,
                      textStyle: const TextStyle(
                          fontSize: 25,
                          color: Color.fromARGB(255, 31, 164, 100),
                          fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: CustomSize().customWidth(context) / 200,
                            color: const Color.fromARGB(255, 31, 164, 100)),
                        borderRadius: BorderRadius.circular(
                            CustomSize().customWidth(context) / 30),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "I don't receive a code!",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: CustomSize().customWidth(context) / 22,
                      ),
                    ),
                    SizedBox(width: CustomSize().customWidth(context) / 40),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "Please resend",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 31, 164, 100),
                          fontWeight: FontWeight.w600,
                          fontSize: CustomSize().customWidth(context) / 22,
                        ),
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
