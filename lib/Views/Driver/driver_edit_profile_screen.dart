import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/theme.dart';

class DriverEditProfileScreen extends StatefulWidget {
  const DriverEditProfileScreen({super.key});

  @override
  State<DriverEditProfileScreen> createState() =>
      _DriverEditProfileScreenState();
}

class _DriverEditProfileScreenState extends State<DriverEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: "Fahim Iqbal");
  final _phoneController = TextEditingController(text: "+92 300 1234567");
  final _emailController = TextEditingController(text: "fahim@gmail.com");
  final _vehicleModelController = TextEditingController(text: "Honda Civic");
  final _vehicleYearController = TextEditingController(text: "2020");
  final _vehicleNumberController = TextEditingController(text: "ABC-123");
  final _licenseNumberController = TextEditingController(text: "DL-123456");

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    _vehicleNumberController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    // Calculate responsive dimensions
    final profileImageSize =
        isSmallScreen ? 100.0 : (isMediumScreen ? 120.0 : 140.0);
    final sectionPadding =
        isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final fieldSpacing = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final titleFontSize = isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 20.0);
    final textFontSize = isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 16.0);
    final iconSize = isSmallScreen ? 18.0 : (isMediumScreen ? 20.0 : 24.0);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isSmallScreen ? 48 : 56),
        child: AppBar(
          title: Text(
            "Edit Profile",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: isSmallScreen ? 18 : (isMediumScreen ? 20 : 22),
            ),
          ),
          backgroundColor: const Color(0xFF323d4f),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(sectionPadding),
                decoration: const BoxDecoration(
                  color: Color(0xFF323d4f),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: profileImageSize,
                          height: profileImageSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            image: const DecorationImage(
                              image: AssetImage(
                                  "assets/images/default_profile.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD4AF37),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: isSmallScreen
                                  ? 16
                                  : (isMediumScreen ? 18 : 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: fieldSpacing),
                    Text(
                      "Tap to change profile picture",
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: textFontSize,
                      ),
                    ),
                  ],
                ),
              ),

              // Personal Information Section
              Padding(
                padding: EdgeInsets.all(sectionPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Personal Information",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF323d4f),
                      ),
                    ),
                    SizedBox(height: fieldSpacing),
                    _buildTextField(
                      controller: _nameController,
                      label: "Full Name",
                      icon: Icons.person_outline,
                      iconSize: iconSize,
                      fontSize: textFontSize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: fieldSpacing),
                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      icon: Icons.phone_outlined,
                      iconSize: iconSize,
                      fontSize: textFontSize,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your phone number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: fieldSpacing),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email Address",
                      icon: Icons.email_outlined,
                      iconSize: iconSize,
                      fontSize: textFontSize,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!value.contains("@")) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              // Vehicle Information Section
              Padding(
                padding: EdgeInsets.all(sectionPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vehicle Information",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF323d4f),
                      ),
                    ),
                    SizedBox(height: fieldSpacing),
                    _buildTextField(
                      controller: _vehicleModelController,
                      label: "Vehicle Model",
                      icon: Icons.directions_car_outlined,
                      iconSize: iconSize,
                      fontSize: textFontSize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter vehicle model";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: fieldSpacing),
                    _buildTextField(
                      controller: _vehicleYearController,
                      label: "Vehicle Year",
                      icon: Icons.calendar_today_outlined,
                      iconSize: iconSize,
                      fontSize: textFontSize,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter vehicle year";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: fieldSpacing),
                    _buildTextField(
                      controller: _vehicleNumberController,
                      label: "Vehicle Number",
                      icon: Icons.numbers_outlined,
                      iconSize: iconSize,
                      fontSize: textFontSize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter vehicle number";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              // Documents Section
              Padding(
                padding: EdgeInsets.all(sectionPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Documents",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF323d4f),
                      ),
                    ),
                    SizedBox(height: fieldSpacing),
                    _buildTextField(
                      controller: _licenseNumberController,
                      label: "Driver's License Number",
                      icon: Icons.card_membership_outlined,
                      iconSize: iconSize,
                      fontSize: textFontSize,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter license number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: fieldSpacing * 1.5),
                    _buildDocumentUploadCard(
                      "Driver's License",
                      "Upload your driver's license",
                      Icons.upload_file,
                      iconSize: iconSize,
                      fontSize: textFontSize,
                      titleFontSize: titleFontSize,
                    ),
                    SizedBox(height: fieldSpacing),
                    _buildDocumentUploadCard(
                      "Vehicle Registration",
                      "Upload vehicle registration document",
                      Icons.upload_file,
                      iconSize: iconSize,
                      fontSize: textFontSize,
                      titleFontSize: titleFontSize,
                    ),
                    SizedBox(height: fieldSpacing),
                    _buildDocumentUploadCard(
                      "Insurance Document",
                      "Upload insurance document",
                      Icons.upload_file,
                      iconSize: iconSize,
                      fontSize: textFontSize,
                      titleFontSize: titleFontSize,
                    ),
                  ],
                ),
              ),

              // Save Button
              Padding(
                padding: EdgeInsets.all(sectionPadding),
                child: SizedBox(
                  width: double.infinity,
                  height: isSmallScreen ? 45 : (isMediumScreen ? 48 : 50),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Save profile changes
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profile updated successfully"),
                            backgroundColor: Color(0xFFD4AF37),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Save Changes",
                      style: GoogleFonts.poppins(
                        fontSize: textFontSize + 2,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required double iconSize,
    required double fontSize,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          color: const Color(0xFF323d4f),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: fontSize,
            color: Colors.grey[600],
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFFD4AF37),
            size: iconSize,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: fontSize * 1.2,
            vertical: fontSize * 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentUploadCard(
    String title,
    String subtitle,
    IconData icon, {
    required double iconSize,
    required double fontSize,
    required double titleFontSize,
  }) {
    return Container(
      padding: EdgeInsets.all(fontSize * 1.2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(fontSize),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFFD4AF37),
              size: iconSize,
            ),
          ),
          SizedBox(width: fontSize * 1.2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF323d4f),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Add document upload functionality
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              size: fontSize,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
