import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';
import 'package:vroom_ride_app/Resources/customComponents.dart';
import 'package:vroom_ride_app/Views/Driver/driver_dashboard.dart';
import 'package:vroom_ride_app/Views/auth_screen/forgotPassword.dart';
import 'package:vroom_ride_app/Views/auth_screen/signUp_screen.dart';
import 'package:vroom_ride_app/Views/Driver/driver_registration.dart';
import 'package:vroom_ride_app/components/customButton.dart';
import 'package:vroom_ride_app/welcomePage.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        // Check credentials
        if (emailController.text == "fahim@gmail.com" &&
            passwordController.text == "1234") {
          // Navigate to dashboard
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const DriverDashboard(),
            ),
            (route) => false,
          );
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = "Invalid email or password";
          });
        }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Login",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
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
                    scale: CustomSize().customWidth(context) / 100,
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 18),

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
                        return "Please enter your password";
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPassword()));
                      },
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF323d4f),
                            fontWeight: FontWeight.w500,
                            fontSize: CustomSize().customWidth(context) / 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: CustomSize().customHeight(context) / 12),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF323d4f),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                        : Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.login,
                                    size: 24, color: Colors.white),
                                const SizedBox(width: 10),
                                Text(
                                  "Login",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF323d4f),
                        fontSize: CustomSize().customWidth(context) / 25,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DriverRegistrationScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFD4AF37),
                          fontWeight: FontWeight.w600,
                          fontSize: CustomSize().customWidth(context) / 25,
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
