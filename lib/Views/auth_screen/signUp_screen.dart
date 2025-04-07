import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  void _register() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF323d4f),
        elevation: 0,
        title: Text(
          "Sign Up",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(CustomSize().customWidth(context) / 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/logo1.png",
                    height: 100,
                    width: 100,
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 40),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // First Name field
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: TextFormField(
                    cursorColor: const Color(0xFF323d4f),
                    obscureText: false,
                    enableSuggestions: true,
                    controller: firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your first name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "First Name",
                        prefixIcon:
                            const Icon(Icons.person, color: Color(0xFF323d4f)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color(0xFF323d4f),
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color(0xFFD4AF37),
                              width: 2.0,
                            ))),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 30),

                // Last Name field
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: TextFormField(
                    cursorColor: const Color(0xFF323d4f),
                    obscureText: false,
                    enableSuggestions: true,
                    controller: lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your last name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Last Name",
                        prefixIcon:
                            const Icon(Icons.person, color: Color(0xFF323d4f)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color(0xFF323d4f),
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color(0xFFD4AF37),
                              width: 2.0,
                            ))),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 30),

                // Email field
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: TextFormField(
                    cursorColor: const Color(0xFF323d4f),
                    obscureText: false,
                    enableSuggestions: true,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon:
                            const Icon(Icons.email, color: Color(0xFF323d4f)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color(0xFF323d4f),
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color(0xFFD4AF37),
                              width: 2.0,
                            ))),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 30),

                // Phone Number field
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: TextFormField(
                    cursorColor: const Color(0xFF323d4f),
                    obscureText: false,
                    enableSuggestions: true,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your phone number";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Phone Number",
                        prefixIcon:
                            const Icon(Icons.phone, color: Color(0xFF323d4f)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color(0xFF323d4f),
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color(0xFFD4AF37),
                              width: 2.0,
                            ))),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 30),

                // CNIC field
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: TextFormField(
                    cursorColor: const Color(0xFF323d4f),
                    obscureText: false,
                    enableSuggestions: true,
                    controller: cnicController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(13),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your CNIC number";
                      }
                      if (value.length != 13) {
                        return "CNIC must be 13 digits";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "CNIC Number (13 digits)",
                        prefixIcon: const Icon(Icons.credit_card,
                            color: Color(0xFF323d4f)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color(0xFF323d4f),
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color(0xFFD4AF37),
                              width: 2.0,
                            ))),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 30),

                // Password field
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: TextFormField(
                    cursorColor: const Color(0xFF323d4f),
                    obscureText: _obscurePassword,
                    enableSuggestions: false,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon:
                            const Icon(Icons.lock, color: Color(0xFF323d4f)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF323d4f),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color(0xFF323d4f),
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            borderSide: const BorderSide(
                              color: Color(0xFFD4AF37),
                              width: 2.0,
                            ))),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 22),

                // Register button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF323d4f),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person_add, size: 24),
                              const SizedBox(width: 10),
                              Text(
                                "Register",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 30),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                          fontSize: CustomSize().customWidth(context) / 25),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const loginScreen()));
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                            color: const Color(0xFFD4AF37),
                            fontWeight: FontWeight.w600,
                            fontSize: CustomSize().customWidth(context) / 25),
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
