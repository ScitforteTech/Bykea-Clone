import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vroom_ride_app/Resources/theme.dart';
import 'package:vroom_ride_app/Views/Driver/driver_dashboard.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  // Add Cloudinary instance
  final cloudinary = CloudinaryPublic('dfkwjplv7', 'my_preset', cache: false);

  final _formKey = GlobalKey<FormState>();
  File? _profileImage;
  File? _licenseImage;
  File? _vehicleImage;
  String _selectedVehicleType = 'Bike';
  bool _isLoading = false;
  int _currentStep = 0;
  final int _totalSteps = 3;

  final List<String> _vehicleTypes = ['Bike', 'Car', 'Auto Rickshaw'];

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Add new controllers
  final _cnicController = TextEditingController();
  final _vehicleMakeController = TextEditingController();
  final _vehicleColorController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Add Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    // Add CNIC formatter
    _cnicController.addListener(() {
      String text = _cnicController.text.replaceAll('-', '');
      if (text.length > 13) {
        text = text.substring(0, 13);
      }

      String formattedText = '';
      for (var i = 0; i < text.length; i++) {
        if (i == 5 || i == 12) {
          formattedText += '-';
        }
        formattedText += text[i];
      }

      if (formattedText != _cnicController.text) {
        _cnicController.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    });

    // Existing phone formatter
    _phoneController.addListener(() {
      String text = _phoneController.text.replaceAll('-', '');
      if (text.length > 11) {
        text = text.substring(0, 11);
      }

      String formattedText = '';
      for (var i = 0; i < text.length; i++) {
        if (i == 4) {
          formattedText += '-';
        }
        formattedText += text[i];
      }

      if (formattedText != _phoneController.text) {
        _phoneController.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    });
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image == null) return;

      setState(() {
        switch (type) {
          case 'profile':
            _profileImage = File(image.path);
            break;
          case 'license':
            _licenseImage = File(image.path);
            break;
          case 'vehicle':
            _vehicleImage = File(image.path);
            break;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to pick image: $e',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog(String type, String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  label: "Gallery",
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery, type);
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera, type);
                  },
                ),
                if ((type == 'profile' && _profileImage != null) ||
                    (type == 'license' && _licenseImage != null) ||
                    (type == 'vehicle' && _vehicleImage != null))
                  _buildImageSourceOption(
                    icon: Icons.delete,
                    label: "Remove",
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        switch (type) {
                          case 'profile':
                            _profileImage = null;
                            break;
                          case 'license':
                            _licenseImage = null;
                            break;
                          case 'vehicle':
                            _vehicleImage = null;
                            break;
                        }
                      });
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
            child: Icon(
              icon,
              size: 30,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  List<Step> get registrationSteps => [
        Step(
          title: Text(
            'Personal Info',
            style: GoogleFonts.poppins(color: AppTheme.primaryBlue),
          ),
          content: _buildPersonalInfoStep(),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: Text(
            'Vehicle Details',
            style: GoogleFonts.poppins(color: AppTheme.primaryBlue),
          ),
          content: _buildVehicleDetailsStep(),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: Text(
            'Documents',
            style: GoogleFonts.poppins(color: AppTheme.primaryBlue),
          ),
          content: _buildDocumentsStep(),
          isActive: _currentStep >= 2,
        ),
      ];

  Widget _buildPersonalInfoStep() {
    return Column(
      children: [
        // Profile Image
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: AppTheme.primaryBlue,
                  radius: 18,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 18),
                    color: Colors.white,
                    onPressed: () => _showImageSourceDialog(
                        'profile', 'Select Profile Photo'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Personal Information Fields
        _buildSection(
          'Personal Information',
          Column(
            children: [
              _buildTextField(
                label: 'Full Name',
                icon: Icons.person_outline,
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'CNIC',
                icon: Icons.credit_card,
                controller: _cnicController,
                keyboardType: TextInputType.number,
                maxLength: 15, // 13 digits + 2 hyphens
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your CNIC';
                  }
                  String digitsOnly = value!.replaceAll('-', '');
                  if (digitsOnly.length != 13) {
                    return 'CNIC must be 13 digits';
                  }
                  if (!RegExp(r'^\d{5}-\d{7}-\d{1}$').hasMatch(value)) {
                    return 'CNIC format should be: 42000-9072425-9';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Email',
                icon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 12, // 11 digits + 1 hyphen
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your phone number';
                  }
                  String digitsOnly = value!.replaceAll('-', '');
                  if (digitsOnly.length != 11) {
                    return 'Phone number must be 11 digits';
                  }
                  if (!RegExp(r'^[0-9-]+$').hasMatch(value)) {
                    return 'Phone number can only contain numbers';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),

        // Password Section
        _buildSection(
          'Security',
          Column(
            children: [
              _buildTextField(
                label: 'Password',
                icon: Icons.lock_outline,
                controller: _passwordController,
                isPassword: true,
                obscureText: _obscurePassword,
                onVisibilityToggle: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a password' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Confirm Password',
                icon: Icons.lock_outline,
                controller: _confirmPasswordController,
                isPassword: true,
                obscureText: _obscureConfirmPassword,
                onVisibilityToggle: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword),
                validator: (value) {
                  if (value?.isEmpty ?? true)
                    return 'Please confirm your password';
                  if (value != _passwordController.text)
                    return 'Passwords do not match';
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Vehicle Type',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
          children: _vehicleTypes.map((type) {
            bool isSelected = type == _selectedVehicleType;
            return InkWell(
              onTap: () => setState(() => _selectedVehicleType = type),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryBlue.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isSelected ? AppTheme.primaryBlue : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      height: 65, // Fixed container height for all icons
                      alignment:
                          Alignment.center, // Center the icons vertically
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: type == 'Bike'
                          ? Image.asset(
                              'assets/images/70.png',
                              height: 32,
                              width: 32,
                            )
                          : type == 'Car'
                              ? Image.asset(
                                  'assets/images/sedan.png',
                                  height: 45,
                                  width: 45,
                                )
                              : Image.asset(
                                  'assets/images/rickshaw.png',
                                  height: 40,
                                  width: 40,
                                ),
                    ),
                    const SizedBox(
                        height: 8), // Consistent spacing for all types
                    Text(
                      type,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Vehicle Make',
          icon: Icons.business,
          controller: _vehicleMakeController,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter vehicle make' : null,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Vehicle Model',
          icon: Icons.directions_car_outlined,
          controller: _vehicleModelController,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter vehicle model' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Vehicle Color',
          icon: Icons.color_lens_outlined,
          controller: _vehicleColorController,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter vehicle color' : null,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Vehicle Number',
          icon: Icons.numbers_outlined,
          controller: _vehicleNumberController,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter vehicle number' : null,
          textCapitalization: TextCapitalization.characters,
        ),
        const SizedBox(height: 16),
        _buildImagePicker(
          'Vehicle Photo',
          _vehicleImage,
          () => _showImageSourceDialog('vehicle', 'Vehicle Photo'),
        ),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    return Column(
      children: [
        _buildTextField(
          label: 'License Number',
          icon: Icons.badge_outlined,
          controller: _licenseController,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter license number' : null,
        ),
        const SizedBox(height: 16),
        _buildImageUploadSection(
          'Upload License Photo',
          _licenseImage,
          () => _showImageSourceDialog('license', 'Select License Photo'),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection(
      String title, File? image, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file,
                      color: AppTheme.primaryBlue.withOpacity(0.5), size: 40),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: AppTheme.primaryBlue.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Add upload method
  Future<String> _uploadImageToCloudinary(File image, String folder) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          folder: folder,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> registerDriver() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      // Validate all required fields and images
      if (_profileImage == null ||
          _licenseImage == null ||
          _vehicleImage == null ||
          _nameController.text.isEmpty) {
        throw Exception(
            'Please fill in all required fields and upload all images');
      }

      // Upload images to Cloudinary first
      final String profileImageUrl =
          await _uploadImageToCloudinary(_profileImage!, 'driver_profiles');
      final String licenseImageUrl =
          await _uploadImageToCloudinary(_licenseImage!, 'driver_licenses');
      final String vehicleImageUrl =
          await _uploadImageToCloudinary(_vehicleImage!, 'driver_vehicles');

      // Create user account
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Update display name
      await userCredential.user!.updateDisplayName(_nameController.text.trim());

      // Save driver data to Firestore with image URLs
      await _firestore.collection('drivers').doc(userCredential.user!.uid).set({
        'personalInfo': {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'cnic': _cnicController.text.trim(),
          'profileImage': profileImageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        },
        'vehicle': {
          'type': _selectedVehicleType,
          'make': _vehicleMakeController.text.trim(),
          'model': _vehicleModelController.text.trim(),
          'color': _vehicleColorController.text.trim(),
          'plateNumber': _vehicleNumberController.text.trim().toUpperCase(),
          'vehicleImage': vehicleImageUrl,
        },
        'license': {
          'number': _licenseController.text.trim(),
          'image': licenseImageUrl,
        },
        'status': {
          'isVerified': false,
          'isOnline': false,
          'rating': 0.0,
          'earnings': 0.0,
          'trips': 0,
        }
      });

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DriverDashboard()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      _showErrorSnackBar('Registration failed: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'weak-password':
        return 'Please enter a stronger password';
      default:
        return 'An error occurred during registration';
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define responsive dimensions
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

    // Responsive dimensions
    final sectionPadding =
        isSmallScreen ? 16.0 : (isMediumScreen ? 20.0 : 24.0);
    final fieldSpacing = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final titleFontSize = isSmallScreen ? 18.0 : (isMediumScreen ? 20.0 : 22.0);
    final labelFontSize = isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 16.0);
    final inputFontSize = isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 16.0);
    final iconSize = isSmallScreen ? 20.0 : (isMediumScreen ? 24.0 : 24.0);
    final profileImageSize =
        isSmallScreen ? 60.0 : (isMediumScreen ? 70.0 : 80.0);
    final cameraIconSize =
        isSmallScreen ? 20.0 : (isMediumScreen ? 24.0 : 24.0);
    final buttonHeight = isSmallScreen ? 48.0 : (isMediumScreen ? 56.0 : 56.0);
    final buttonFontSize =
        isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 16.0);
    final imageUploadHeight =
        isSmallScreen ? 120.0 : (isMediumScreen ? 150.0 : 150.0);
    final imageUploadIconSize =
        isSmallScreen ? 40.0 : (isMediumScreen ? 48.0 : 48.0);
    final imageUploadFontSize =
        isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 16.0);
    final cardRadius = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 16.0);
    final borderWidth = isSmallScreen ? 1.5 : (isMediumScreen ? 2.0 : 2.0);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Driver Registration',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: titleFontSize,
          ),
        ),
        backgroundColor: AppTheme.primaryBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: fieldSpacing),
                // Profile Photo Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: profileImageSize,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(Icons.person,
                                size: profileImageSize, color: Colors.grey[400])
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(fieldSpacing / 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white, width: borderWidth),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, size: cameraIconSize),
                            color: Colors.white,
                            onPressed: () => _showImageSourceDialog(
                                'profile', 'Profile Photo'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: fieldSpacing * 1.5),

                // Personal Information Section
                _buildSection(
                  'Personal Information',
                  Column(
                    children: [
                      _buildTextField(
                        label: 'Full Name',
                        icon: Icons.person_outline,
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Please enter your name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'CNIC',
                        icon: Icons.credit_card,
                        controller: _cnicController,
                        keyboardType: TextInputType.number,
                        maxLength: 15,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your CNIC';
                          }
                          String digitsOnly = value!.replaceAll('-', '');
                          if (digitsOnly.length != 13) {
                            return 'CNIC must be 13 digits';
                          }
                          if (!RegExp(r'^\d{5}-\d{7}-\d{1}$').hasMatch(value)) {
                            return 'CNIC format should be: 42000-9072425-9';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Email',
                        icon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Please enter your email'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Phone Number',
                        icon: Icons.phone_outlined,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 12, // 11 digits + 1 hyphen
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your phone number';
                          }
                          String digitsOnly = value!.replaceAll('-', '');
                          if (digitsOnly.length != 11) {
                            return 'Phone number must be 11 digits';
                          }
                          if (!RegExp(r'^[0-9-]+$').hasMatch(value)) {
                            return 'Phone number can only contain numbers';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                // Password Section
                _buildSection(
                  'Security',
                  Column(
                    children: [
                      _buildTextField(
                        label: 'Password',
                        icon: Icons.lock_outline,
                        controller: _passwordController,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onVisibilityToggle: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Please enter a password'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Confirm Password',
                        icon: Icons.lock_outline,
                        controller: _confirmPasswordController,
                        isPassword: true,
                        obscureText: _obscureConfirmPassword,
                        onVisibilityToggle: () => setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword),
                        validator: (value) {
                          if (value?.isEmpty ?? true)
                            return 'Please confirm your password';
                          if (value != _passwordController.text)
                            return 'Passwords do not match';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                // Vehicle Information Section
                _buildSection(
                  'Vehicle Information',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Vehicle Type',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.85,
                        children: _vehicleTypes.map((type) {
                          bool isSelected = type == _selectedVehicleType;
                          return InkWell(
                            onTap: () =>
                                setState(() => _selectedVehicleType = type),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryBlue.withOpacity(0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryBlue
                                      : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color:
                                          AppTheme.primaryBlue.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    height:
                                        65, // Fixed container height for all icons
                                    alignment: Alignment
                                        .center, // Center the icons vertically
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: type == 'Bike'
                                        ? Image.asset(
                                            'assets/images/70.png',
                                            height: 32,
                                            width: 32,
                                          )
                                        : type == 'Car'
                                            ? Image.asset(
                                                'assets/images/sedan.png',
                                                height: 45,
                                                width: 45,
                                              )
                                            : Image.asset(
                                                'assets/images/rickshaw.png',
                                                height: 40,
                                                width: 40,
                                              ),
                                  ),
                                  const SizedBox(
                                      height:
                                          8), // Consistent spacing for all types
                                  Text(
                                    type,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.5,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? AppTheme.primaryBlue
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        label: 'Vehicle Make',
                        icon: Icons.business,
                        controller: _vehicleMakeController,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Please enter vehicle make'
                            : null,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Vehicle Model',
                        icon: Icons.directions_car_outlined,
                        controller: _vehicleModelController,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Please enter vehicle model'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Vehicle Color',
                        icon: Icons.color_lens_outlined,
                        controller: _vehicleColorController,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Please enter vehicle color'
                            : null,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Vehicle Number',
                        icon: Icons.numbers_outlined,
                        controller: _vehicleNumberController,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Please enter vehicle number'
                            : null,
                        textCapitalization: TextCapitalization.characters,
                      ),
                      const SizedBox(height: 16),
                      _buildImagePicker(
                        'Vehicle Photo',
                        _vehicleImage,
                        () =>
                            _showImageSourceDialog('vehicle', 'Vehicle Photo'),
                      ),
                    ],
                  ),
                ),

                // License Information Section
                _buildSection(
                  'License Information',
                  Column(
                    children: [
                      _buildTextField(
                        label: 'License Number',
                        icon: Icons.badge_outlined,
                        controller: _licenseController,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Please enter license number'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildImageUploadSection(
                        'Upload License Photo',
                        _licenseImage,
                        () =>
                            _showImageSourceDialog('license', 'License Photo'),
                      ),
                    ],
                  ),
                ),

                // Register Button
                Container(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              try {
                                await registerDriver();
                              } catch (e, stackTrace) {
                                print('Error: $e');
                                print('StackTrace: $stackTrace');
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF323d4f),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_add,
                            size: 24,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Register',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _vehicleNumberController.dispose();
    _vehicleModelController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cnicController.dispose();
    _vehicleMakeController.dispose();
    _vehicleColorController.dispose();
    super.dispose();
  }

  Widget _buildSection(String title, Widget content) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

    // Responsive dimensions
    final sectionPadding =
        isSmallScreen ? 16.0 : (isMediumScreen ? 20.0 : 24.0);
    final titleFontSize = isSmallScreen ? 18.0 : (isMediumScreen ? 20.0 : 22.0);
    final cardRadius = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 16.0);

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: sectionPadding, vertical: sectionPadding / 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(sectionPadding),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(sectionPadding),
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    VoidCallback? onVisibilityToggle,
    int? maxLength,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool? enabled,
    VoidCallback? onTap,
  }) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

    // Responsive dimensions
    final labelFontSize = isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 16.0);
    final inputFontSize = isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 16.0);
    final iconSize = isSmallScreen ? 20.0 : (isMediumScreen ? 24.0 : 24.0);
    final fieldRadius = isSmallScreen ? 12.0 : (isMediumScreen ? 12.0 : 12.0);
    final borderWidth = isSmallScreen ? 1.5 : (isMediumScreen ? 2.0 : 2.0);
    final contentPadding = isSmallScreen
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
        : (isMediumScreen
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 16));

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      enabled: enabled,
      onTap: onTap,
      style: GoogleFonts.poppins(
        fontSize: inputFontSize,
        color: enabled == false ? Colors.grey[600] : null,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: labelFontSize),
        prefixIcon: Icon(icon, color: const Color(0xFF323d4f), size: iconSize),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF323d4f),
                  size: iconSize,
                ),
                onPressed: onVisibilityToggle,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide(
            color: const Color(0xFF323d4f),
            width: borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide(
            color: const Color(0xFF323d4f),
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide(
            color: const Color(0xFFD4AF37),
            width: borderWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        errorStyle: GoogleFonts.poppins(
          color: Colors.red,
          fontSize: isSmallScreen ? 11 : 12,
        ),
        contentPadding: contentPadding,
        counterText: maxLength != null ? '' : null,
      ),
      validator: validator,
    );
  }

  Widget _buildImagePicker(String title, File? image, VoidCallback onTap) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

    // Responsive dimensions
    final imageUploadHeight =
        isSmallScreen ? 120.0 : (isMediumScreen ? 150.0 : 150.0);
    final imageUploadIconSize =
        isSmallScreen ? 40.0 : (isMediumScreen ? 48.0 : 48.0);
    final imageUploadFontSize =
        isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 16.0);
    final cardRadius = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 16.0);
    final editIconSize = isSmallScreen ? 20.0 : (isMediumScreen ? 24.0 : 24.0);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: imageUploadHeight,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(cardRadius),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: image != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(cardRadius),
                    child: Image.file(
                      image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit,
                            color: Colors.white, size: editIconSize),
                        onPressed: onTap,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: imageUploadIconSize,
                    color: AppTheme.primaryBlue.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: imageUploadFontSize,
                      color: AppTheme.primaryBlue.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    'Tap to upload',
                    style: GoogleFonts.poppins(
                      fontSize: imageUploadFontSize - 2,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
