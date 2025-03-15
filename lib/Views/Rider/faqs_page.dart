import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Views/Rider/support_page.dart';

class FAQsPage extends StatefulWidget {
  const FAQsPage({super.key});

  @override
  State<FAQsPage> createState() => _FAQsPageState();
}

class _FAQsPageState extends State<FAQsPage> {
  // Track which categories are expanded
  final Map<String, bool> _expandedCategories = {};

  // Track which questions are expanded within each category
  final Map<String, Set<int>> _expandedQuestions = {
    'Account': {},
    'Booking': {},
    'Payment': {},
    'Ride': {},
    'Safety': {},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Frequently Asked Questions",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: MediaQuery.of(context).size.width / 22,
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
                  color: const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
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
                      "How can we help you?",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Find answers to common questions",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search FAQs',
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF323d4f)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // FAQ Categories
            _buildFAQCategory(
              'Account',
              [
                {
                  'question': 'How do I create an account?',
                  'answer':
                      'To create an account, download the Vroom Ride app from the App Store or Google Play Store. Open the app and tap "Sign Up". Enter your phone number, verify it with the OTP sent to you, and then fill in your personal details to complete the registration.'
                },
                {
                  'question': 'How do I reset my password?',
                  'answer':
                      'If you forgot your password, go to the login screen and tap "Forgot Password". Enter your registered phone number, verify it with the OTP, and then set a new password.'
                },
                {
                  'question': 'How do I update my profile information?',
                  'answer':
                      'To update your profile, go to the hamburger menu and tap on your profile picture or name. Then tap "Edit Profile" to update your information such as name, email, or profile picture.'
                },
                {
                  'question': 'Can I delete my account?',
                  'answer':
                      'Yes, you can delete your account. Go to Settings in the app, scroll down to "Account", and select "Delete Account". Please note that this action is irreversible and all your data will be permanently deleted.'
                },
              ],
            ),

            _buildFAQCategory(
              'Booking',
              [
                {
                  'question': 'How do I book a ride?',
                  'answer':
                      'To book a ride, open the app and enter your pickup and drop-off locations. Select your preferred vehicle type, enter your fare offer, and tap "Find a driver". Once a driver accepts your offer, you\'ll be notified and can track their arrival.'
                },
                {
                  'question': 'Can I schedule a ride in advance?',
                  'answer':
                      'Currently, Vroom Ride doesn\'t support scheduling rides in advance. All rides are booked for immediate pickup. We\'re working on adding this feature in future updates.'
                },
                {
                  'question': 'How do I cancel a ride?',
                  'answer':
                      'To cancel a ride, go to your active ride screen and tap the "Cancel" button. Please note that cancellations made after a driver has accepted your ride may incur a cancellation fee depending on how much time has passed.'
                },
                {
                  'question': 'Can I book a ride for someone else?',
                  'answer':
                      'Yes, you can book a ride for someone else. Just enter their pickup and drop-off locations. You can also add a note for the driver mentioning that the ride is for someone else and provide their contact information.'
                },
              ],
            ),

            _buildFAQCategory(
              'Payment',
              [
                {
                  'question': 'What payment methods are accepted?',
                  'answer':
                      'Vroom Ride accepts cash payments directly to the driver. We also support digital payments through the app wallet, which can be loaded using credit/debit cards, bank transfers, or mobile payment services.'
                },
                {
                  'question': 'How do I add money to my wallet?',
                  'answer':
                      'To add money to your wallet, go to the "Wallet" section from the hamburger menu. Tap "Add Money", enter the amount, and select your preferred payment method. Follow the instructions to complete the transaction.'
                },
                {
                  'question': 'Are there any booking fees?',
                  'answer':
                      'Vroom Ride charges a small service fee on each ride, which is included in the fare estimate. The exact fee depends on the ride distance and type of vehicle selected.'
                },
                {
                  'question': 'How do refunds work?',
                  'answer':
                      'If you\'re eligible for a refund (e.g., due to service issues or overcharges), the amount will be credited back to your Vroom Ride wallet within 3-5 business days. For cash refunds, please contact our customer support.'
                },
              ],
            ),

            _buildFAQCategory(
              'Ride',
              [
                {
                  'question': 'What if the driver takes a longer route?',
                  'answer':
                      'Vroom Ride allows you to set your own fare, so the route taken shouldn\'t affect your payment. However, if you believe a driver intentionally took a longer route to waste your time, you can report this through the app after your ride is completed.'
                },
                {
                  'question': 'Can I change my destination during a ride?',
                  'answer':
                      'Yes, you can change your destination during a ride. Simply inform your driver about the change. Keep in mind that significant changes to the destination may require renegotiation of the fare with the driver.'
                },
                {
                  'question': 'What if I leave something in the vehicle?',
                  'answer':
                      'If you leave something in the vehicle, you can contact the driver directly through the app. Go to your ride history, select the ride, and tap "Lost Item". If you can\'t reach the driver, contact our customer support for assistance.'
                },
                {
                  'question': 'How do I rate my driver?',
                  'answer':
                      'After each ride is completed, you\'ll be prompted to rate your driver on a scale of 1-5 stars and provide feedback. Your ratings help maintain service quality and improve the experience for all users.'
                },
              ],
            ),

            _buildFAQCategory(
              'Safety',
              [
                {
                  'question': 'How does Vroom Ride ensure rider safety?',
                  'answer':
                      'Vroom Ride prioritizes safety by verifying all drivers, tracking rides in real-time, and providing an emergency button in the app. We also have a 24/7 support team to assist with any safety concerns.'
                },
                {
                  'question': 'Can I share my ride details with others?',
                  'answer':
                      'Yes, you can share your ride details with friends or family for added safety. During an active ride, tap the "Share" button to send your real-time location, driver details, and estimated arrival time to your trusted contacts.'
                },
                {
                  'question':
                      'What should I do in case of an emergency during a ride?',
                  'answer':
                      'In case of an emergency, use the SOS button in the app, which is available during active rides. This will alert our emergency response team and share your location. For immediate assistance, you should also contact local emergency services.'
                },
                {
                  'question': 'How are drivers vetted?',
                  'answer':
                      'All Vroom Ride drivers undergo a thorough verification process including background checks, vehicle inspections, and document verification. We also continuously monitor driver ratings and feedback to ensure quality service.'
                },
              ],
            ),

            const SizedBox(height: 24),

            // Still have questions section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Still have questions?",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF323d4f),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "If you couldn't find the answer to your question, our support team is here to help.",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to support page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SupportPage()),
                            );
                          },
                          icon: const Icon(Icons.support_agent),
                          label: Text(
                            "Contact Support",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCategory(String category, List<Map<String, String>> faqs) {
    bool isCategoryExpanded = _expandedCategories[category] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header
        InkWell(
          onTap: () {
            setState(() {
              _expandedCategories[category] = !isCategoryExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF323d4f),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getCategoryIcon(category),
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "$category Questions",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  isCategoryExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),

        // Questions in this category
        if (isCategoryExpanded)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              final isExpanded =
                  _expandedQuestions[category]?.contains(index) ?? false;

              return Card(
                margin: const EdgeInsets.only(top: 8),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: Colors.white,
                child: ExpansionTile(
                  initiallyExpanded: isExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      if (expanded) {
                        _expandedQuestions[category]?.add(index);
                      } else {
                        _expandedQuestions[category]?.remove(index);
                      }
                    });
                  },
                  collapsedBackgroundColor: Colors.white,
                  backgroundColor: Colors.grey[50],
                  title: Text(
                    faqs[index]['question'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF323d4f),
                    ),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: isExpanded
                        ? const Color(0xFF323d4f).withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    radius: 14,
                    child: Icon(
                      isExpanded ? Icons.remove : Icons.add,
                      size: 16,
                      color: isExpanded
                          ? const Color(0xFF323d4f)
                          : const Color(0xFF323d4f),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        faqs[index]['answer'] ?? '',
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
            },
          ),

        const SizedBox(height: 16),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Account':
        return Icons.person;
      case 'Booking':
        return Icons.book_online;
      case 'Payment':
        return Icons.payment;
      case 'Ride':
        return Icons.directions_car;
      case 'Safety':
        return Icons.shield;
      default:
        return Icons.help;
    }
  }
}
