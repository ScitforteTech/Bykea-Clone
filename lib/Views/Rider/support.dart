import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Support",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500, // Responsive
          ),
        ),
        backgroundColor: const Color(0xFF323d4f),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset('assets/images/logo.jpeg', height: 160),
              ),
              const SizedBox(height: 20),
              Text(
                "How can we help you?",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500, // Responsive
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "If you have any issues, feel free to contact us.",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w500, // Responsive
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.phone, color: Color(0xFF323d4f)),
                title: const Text(
                  "Call Support",
                  style: TextStyle(color: Color(0xFF323d4f)),
                ),
                subtitle: const Text(
                  "+92 315 2198240",
                  style: TextStyle(color: Color(0xFF323d4f)),
                ),
                onTap: () {
                  // Call functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.email, color: Color(0xFF323d4f)),
                title: const Text("Email Support",
                    style: TextStyle(color: Color(0xFF323d4f))),
                subtitle: const Text("hsabdullah2000@gmail.com",
                    style: TextStyle(color: Color(0xFF323d4f))),
                onTap: () {
                  // Email functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: Color(0xFF323d4f)),
                title: const Text("Live Chat",
                    style: TextStyle(color: Color(0xFF323d4f))),
                subtitle: const Text("Chat with a support agent",
                    style: TextStyle(color: Color(0xFF323d4f))),
                onTap: () {
                  // Chat functionality here
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "We are here to help 24/7",
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500, // Responsive
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
