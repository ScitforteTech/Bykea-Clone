import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';
import 'package:vroom_ride_app/Resources/customComponents.dart';
import 'package:vroom_ride_app/Views/auth_screen/login_screen.dart';
import 'package:vroom_ride_app/components/customButton.dart';
import 'package:vroom_ride_app/welcomePage.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(CustomSize().customWidth(context) / 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            // Get.back();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MyWelcomeView()));
                          },
                          child: myBackButton(context),
                        ),
                      ],
                    ),
                  ],
                ),
                Center(
                  child: Image.asset(
                    "assets/images/logo.jpeg",
                    scale: CustomSize().customWidth(context) / 30,
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 40),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  // height:  MediaQuery.sizeOf(context).width*,
                  // margin: EdgeInsets.only(left: MediaQuery.sizeOf(context).width*marginwidth,top: MediaQuery.sizeOf(context).height*marginHeight ),
                  child: TextField(
                    cursorColor: Colors.black,
                    obscureText: true,
                    enableSuggestions: true,
                    controller: firstNameController,
                    decoration: InputDecoration(
                        hintText: "First Name",
                        prefixIcon: const Icon(Icons.alternate_email),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 31, 164, 100),
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 31, 164, 100),
                              width: 2.0,
                            ))),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 30),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  // height:  MediaQuery.sizeOf(context).width*,
                  // margin: EdgeInsets.only(left: MediaQuery.sizeOf(context).width*marginwidth,top: MediaQuery.sizeOf(context).height*marginHeight ),
                  child: TextField(
                    cursorColor: Colors.black,
                    obscureText: true,
                    enableSuggestions: true,
                    controller: lastNameController,
                    decoration: InputDecoration(
                        hintText: "Last Name",
                        prefixIcon: const Icon(Icons.alternate_email),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 31, 164, 100),
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 31, 164, 100),
                              width: 2.0,
                            ))),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 30),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  // height:  MediaQuery.sizeOf(context).width*,
                  // margin: EdgeInsets.only(left: MediaQuery.sizeOf(context).width*marginwidth,top: MediaQuery.sizeOf(context).height*marginHeight ),
                  child: TextField(
                    cursorColor: Colors.black,
                    obscureText: true,
                    enableSuggestions: true,
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 31, 164, 100),
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 31, 164, 100),
                              width: 2.0,
                            ))),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 30),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  // height:  MediaQuery.sizeOf(context).width*,
                  // margin: EdgeInsets.only(left: MediaQuery.sizeOf(context).width*marginwidth,top: MediaQuery.sizeOf(context).height*marginHeight ),
                  child: TextField(
                    cursorColor: Colors.black,
                    obscureText: true,
                    enableSuggestions: true,
                    controller: phoneController,
                    decoration: InputDecoration(
                        hintText: "Phone Number",
                        prefixIcon: const Icon(Icons.phone),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 31, 164, 100),
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 31, 164, 100),
                              width: 2.0,
                            ))),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 30),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  // height:  MediaQuery.sizeOf(context).width*,
                  // margin: EdgeInsets.only(left: MediaQuery.sizeOf(context).width*marginwidth,top: MediaQuery.sizeOf(context).height*marginHeight ),
                  child: TextField(
                    cursorColor: Colors.black,
                    obscureText: true,
                    enableSuggestions: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                        hintText: "password",
                        prefixIcon: const Icon(Icons.password),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 31, 164, 100),
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 31, 164, 100),
                              width: 2.0,
                            ))),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 22),
                CustomButton(
                  textColor: Colors.black,
                  radius: CustomSize().customWidth(context) / 40,
                  height: CustomSize().customHeight(context) / 12,
                  width: CustomSize().customWidth(context),
                  title: "Register",
                  color: const Color.fromARGB(255, 31, 164, 100),
                  loading: false,
                ),
                SizedBox(height: CustomSize().customHeight(context) / 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // margin: EdgeInsets.only(left:  CustomSize().customWidth(context) / 40),
                      child: Text(
                        "Already have an account?",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: CustomSize().customWidth(context) / 20),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const loginScreen()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: CustomSize().customWidth(context) / 40),
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: CustomSize().customWidth(context) / 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
