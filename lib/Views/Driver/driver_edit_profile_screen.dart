import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DriverEditProfileScreen extends StatefulWidget {
  const DriverEditProfileScreen({super.key});

  @override
  State<DriverEditProfileScreen> createState() =>
      _DriverEditProfileScreenState();
}

class _DriverEditProfileScreenState extends State<DriverEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleYearController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  String _profileImageUrl = '';

  // Add Cloudinary instance
  final cloudinary = CloudinaryPublic('dfkwjplv7', 'my_preset', cache: false);

  // Add loading state variables
  bool _isUploadingProfile = false;
  bool _isUploadingLicense = false;
  bool _isUploadingRegistration = false;

  @override
  void initState() {
    super.initState();
    _loadDriverData();
  }

  Future<void> _loadDriverData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final driverDoc =
            await _firestore.collection('drivers').doc(user.uid).get();

        if (driverDoc.exists) {
          final data = driverDoc.data()!;
          setState(() {
            _nameController.text = data['personalInfo']['name'] ?? '';
            _emailController.text = data['personalInfo']['email'] ?? '';
            _phoneController.text = data['personalInfo']['phone'] ?? '';
            _profileImageUrl = data['personalInfo']['profileImage'] ?? '';

            _vehicleModelController.text = data['vehicle']['make'] ?? '';
            _vehicleYearController.text = data['vehicle']['model'] ?? '';
            _vehicleNumberController.text =
                data['vehicle']['plateNumber'] ?? '';
            _licenseNumberController.text = data['license']['number'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error loading driver data: $e');
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('drivers').doc(user.uid).update({
          'personalInfo': {
            'name': _nameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
            'profileImage': _profileImageUrl,
          },
          'vehicle': {
            'make': _vehicleModelController.text,
            'model': _vehicleYearController.text,
            'plateNumber': _vehicleNumberController.text,
          },
          'license': {
            'number': _licenseNumberController.text,
          },
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile updated successfully"),
              backgroundColor: Color(0xFFD4AF37),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating profile: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _uploadImage(String type) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      switch (type) {
        case 'profile':
          setState(() => _isUploadingProfile = true);
          break;
        case 'license':
          setState(() => _isUploadingLicense = true);
          break;
        case 'registration':
          setState(() => _isUploadingRegistration = true);
          break;
      }

      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          folder: 'driver_${type}s',
        ),
      );

      final user = _auth.currentUser;
      if (user != null) {
        switch (type) {
          case 'profile':
            await _firestore.collection('drivers').doc(user.uid).update({
              'personalInfo.profileImage': response.secureUrl,
            });
            setState(() => _profileImageUrl = response.secureUrl);
            break;
          case 'license':
            await _firestore.collection('drivers').doc(user.uid).update({
              'license.image': response.secureUrl,
            });
            break;
          case 'registration':
            await _firestore.collection('drivers').doc(user.uid).update({
              'vehicle.registrationImage': response.secureUrl,
            });
            break;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$type uploaded successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading $type: $e')),
      );
    } finally {
      switch (type) {
        case 'profile':
          setState(() => _isUploadingProfile = false);
          break;
        case 'license':
          setState(() => _isUploadingLicense = false);
          break;
        case 'registration':
          setState(() => _isUploadingRegistration = false);
          break;
      }
    }
  }

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

  String _capitalizeInitials(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
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
                            image: DecorationImage(
                              image: _profileImageUrl.isNotEmpty
                                  ? NetworkImage(_profileImageUrl)
                                  : const AssetImage(
                                          "assets/images/default_profile.png")
                                      as ImageProvider,
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
                            child: _isUploadingProfile
                                ? SizedBox(
                                    width: isSmallScreen ? 16 : 20,
                                    height: isSmallScreen ? 16 : 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: isSmallScreen
                                          ? 16
                                          : (isMediumScreen ? 18 : 20),
                                    ),
                                    onPressed: () => _uploadImage('profile'),
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
                      onChanged: (value) {
                        final capitalizedText = _capitalizeInitials(value);
                        if (value != capitalizedText) {
                          _nameController.value = TextEditingValue(
                            text: capitalizedText,
                            selection: TextSelection.collapsed(
                                offset: capitalizedText.length),
                          );
                        }
                      },
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
                      label: "Vehicle Make", // Changed from "Vehicle Model"
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
                      label: "Vehicle Model", // Changed from "Vehicle Year"
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
                      isLoading: _isUploadingLicense,
                      onUpload: () => _uploadImage('license'),
                    ),
                    SizedBox(height: fieldSpacing),
                    _buildDocumentUploadCard(
                      "Vehicle Registration",
                      "Upload vehicle registration document",
                      Icons.upload_file,
                      iconSize: iconSize,
                      fontSize: textFontSize,
                      titleFontSize: titleFontSize,
                      isLoading: _isUploadingRegistration,
                      onUpload: () => _uploadImage('registration'),
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
                    onPressed: _saveChanges,
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
    void Function(String)? onChanged,
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
        onChanged: onChanged,
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
    bool isLoading = false,
    VoidCallback? onUpload,
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
            onPressed: isLoading ? null : onUpload,
            icon: isLoading
                ? SizedBox(
                    width: fontSize,
                    height: fontSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  )
                : Icon(
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
