import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: MediaQuery.of(context).size.width / 20,
          ),
        ),
        backgroundColor: const Color(0xFF323d4f),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF323d4f).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF323d4f),
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/images/logo1.png',
                          height: 60,
                          width: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Vroom Ride Privacy Policy",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF323d4f),
                      ),
                    ),
                    Text(
                      "Last Updated: June 2023",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Introduction
            _buildSectionTitle("Introduction"),
            _buildParagraph(
              "Welcome to Vroom Ride. We respect your privacy and are committed to protecting your personal data. This Privacy Policy will inform you about how we look after your personal data when you visit our application and tell you about your privacy rights and how the law protects you.",
            ),
            _buildParagraph(
              "This Privacy Policy aims to give you information on how Vroom Ride collects and processes your personal data through your use of this application, including any data you may provide through this application when you sign up for an account, request a ride, or use our services.",
            ),

            const SizedBox(height: 16),

            // Information We Collect
            _buildSectionTitle("Information We Collect"),
            _buildSubsectionTitle("Personal Information"),
            _buildBulletPoints([
              "Identity Data: includes first name, last name, username or similar identifier, date of birth, gender, and profile picture.",
              "Contact Data: includes billing address, email address, and telephone numbers.",
              "Financial Data: includes bank account and payment card details.",
              "Transaction Data: includes details about payments to and from you and other details of services you have purchased from us.",
              "Technical Data: includes internet protocol (IP) address, your login data, browser type and version, time zone setting and location, browser plug-in types and versions, operating system and platform, and other technology on the devices you use to access this application.",
              "Profile Data: includes your username and password, rides requested, preferences, feedback, and survey responses.",
              "Usage Data: includes information about how you use our application and services.",
              "Location Data: includes your current location disclosed by GPS technology."
            ]),

            const SizedBox(height: 16),

            // How We Use Your Information
            _buildSectionTitle("How We Use Your Information"),
            _buildParagraph(
              "We use your information to:",
            ),
            _buildBulletPoints([
              "Provide, operate, and maintain our services",
              "Improve, personalize, and expand our services",
              "Understand and analyze how you use our services",
              "Develop new products, services, features, and functionality",
              "Communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to the service, and for marketing and promotional purposes",
              "Process your transactions",
              "Find and prevent fraud",
              "For compliance with legal obligations"
            ]),

            const SizedBox(height: 16),

            // Sharing Your Information
            _buildSectionTitle("Sharing Your Information"),
            _buildParagraph(
              "We may share your personal information in the following situations:",
            ),
            _buildBulletPoints([
              "With Service Providers: We may share your information with service providers to monitor and analyze the use of our service, for payment processing, to contact you.",
              "For Business Transfers: We may share or transfer your information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.",
              "With Affiliates: We may share your information with our affiliates, in which case we will require those affiliates to honor this Privacy Policy.",
              "With Business Partners: We may share your information with our business partners to offer you certain products, services, or promotions.",
              "With Other Users: When you share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed.",
              "With Your Consent: We may disclose your personal information for any other purpose with your consent."
            ]),

            const SizedBox(height: 16),

            // Data Security
            _buildSectionTitle("Data Security"),
            _buildParagraph(
              "We have implemented appropriate technical and organizational security measures designed to protect the security of any personal information we process. However, despite our safeguards and efforts to secure your information, no electronic transmission over the Internet or information storage technology can be guaranteed to be 100% secure, so we cannot promise or guarantee that hackers, cybercriminals, or other unauthorized third parties will not be able to defeat our security and improperly collect, access, steal, or modify your information.",
            ),

            const SizedBox(height: 16),

            // Your Rights
            _buildSectionTitle("Your Rights"),
            _buildParagraph(
              "You have the following data protection rights:",
            ),
            _buildBulletPoints([
              "The right to access, update or delete the information we have on you.",
              "The right of rectification - You have the right to have your information rectified if that information is inaccurate or incomplete.",
              "The right to object - You have the right to object to our processing of your Personal Data.",
              "The right of restriction - You have the right to request that we restrict the processing of your personal information.",
              "The right to data portability - You have the right to be provided with a copy of the information we have on you in a structured, machine-readable and commonly used format.",
              "The right to withdraw consent - You also have the right to withdraw your consent at any time where we relied on your consent to process your personal information."
            ]),

            const SizedBox(height: 16),

            // Children's Privacy
            _buildSectionTitle("Children's Privacy"),
            _buildParagraph(
              "Our Service does not address anyone under the age of 18. We do not knowingly collect personally identifiable information from anyone under the age of 18. If you are a parent or guardian and you are aware that your child has provided us with Personal Data, please contact us. If we become aware that we have collected Personal Data from anyone under the age of 18 without verification of parental consent, we take steps to remove that information from our servers.",
            ),

            const SizedBox(height: 16),

            // Changes to Privacy Policy
            _buildSectionTitle("Changes to This Privacy Policy"),
            _buildParagraph(
              "We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the 'Last Updated' date at the top of this Privacy Policy. You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.",
            ),

            const SizedBox(height: 16),

            // Contact Us
            _buildSectionTitle("Contact Us"),
            _buildParagraph(
              "If you have any questions about this Privacy Policy, you can contact us:",
            ),
            _buildBulletPoints([
              "By email: privacy@vroomride.com",
              "By phone: +92 300 1234567",
              "By mail: Vroom Ride, 123 Main Street, Karachi, Pakistan"
            ]),

            const SizedBox(height: 24),

            // Accept Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "I Understand",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF323d4f),
        ),
      ),
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF323d4f),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          height: 1.5,
          color: Colors.black87,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildBulletPoints(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.map((point) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "• ",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD4AF37),
                ),
              ),
              Expanded(
                child: Text(
                  point,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
