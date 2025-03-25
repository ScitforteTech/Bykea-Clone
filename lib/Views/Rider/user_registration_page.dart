import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vroom_ride_app/Views/Rider/rider_dashboard.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({super.key});

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Only keep required controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _profileImageUrl; // Replace File? _profileImage
  final ImagePicker _picker = ImagePicker();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true; // Add this line
  bool _isLoading = false;

  final String cloudinaryUrl =
      'https://api.cloudinary.com/v1_1/dfkwjplv7/image/upload';
  final String uploadPreset = 'my_preset';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Simplified image picking
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() => _isLoading = true);

        // Upload to Cloudinary
        final url = await _uploadToCloudinary(File(pickedFile.path));

        setState(() {
          _profileImageUrl = url;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Replace the existing _uploadToCloudinary method with this one
  Future<String> _uploadToCloudinary(File imageFile) async {
    try {
      final url = Uri.parse(cloudinaryUrl);
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ));

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);

      if (response.statusCode != 200) {
        throw 'Failed to upload image';
      }

      final jsonResponse = json.decode(responseString);
      return jsonResponse['secure_url'];
    } catch (e) {
      throw 'Failed to upload image: $e';
    }
  }

  // Show image source selection dialog
  void _showImageSourceDialog() {
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
              "Select Profile Photo",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF323d4f),
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
                    _pickImage(ImageSource.gallery);
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                if (_profileImageUrl != null)
                  _buildImageSourceOption(
                    icon: Icons.delete,
                    label: "Remove",
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _profileImageUrl = null;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Build image source option
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
            backgroundColor: const Color(0xFF323d4f).withOpacity(0.1),
            child: Icon(
              icon,
              size: 30,
              color: const Color(0xFF323d4f),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF323d4f),
            ),
          ),
        ],
      ),
    );
  }

  // Generate unique referral code
  String _generateReferralCode() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final code =
        List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
    return 'VR$code'; // VR prefix for VroomRide
  }

  // Add this helper function
  String _capitalizeNames(String name) {
    if (name.isEmpty) return name;
    return name.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // Register user
  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (_profileImageUrl == null) {
      Get.snackbar('Error', 'Please select a profile picture',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final capitalizedName = _capitalizeNames(_nameController.text);

      // Create user first
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Store user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': capitalizedName, // Use capitalized name here
        'email': _emailController.text,
        'phoneNumber': _phoneController.text,
        'profilePicture': _profileImageUrl,
        'walletBalance': 0.0,
        'referralCode': _generateReferralCode(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'Registration successful!',
          backgroundColor: Colors.green,
          colorText: const Color.fromRGBO(255, 255, 255, 1));
      Get.offAll(() => const RiderDashboard());
    } catch (e) {
      Get.snackbar('Error', _getErrorMessage(e),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Get error message
  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'weak-password':
          return 'The password provided is too weak';
        case 'email-already-in-use':
          return 'An account already exists for that email';
        case 'invalid-email':
          return 'The email address is invalid';
        default:
          return 'Authentication failed';
      }
    }
    return 'An unexpected error occurred';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Create Account",
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 20)),
        backgroundColor: const Color(0xFF323d4f),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF323d4f)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Picture Selection
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _profileImageUrl != null
                                ? NetworkImage(_profileImageUrl!)
                                : const AssetImage('assets/images/user.png')
                                    as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _showImageSourceDialog,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4AF37),
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Form Fields
                    _buildTextField(
                      controller: _nameController,
                      label: "Full Name",
                      hint: "Enter your full name",
                      icon: Icons.person_outline,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) => value?.isEmpty ?? true
                          ? "Please enter your name"
                          : null,
                    ),

                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      hint: "Enter your email",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value ?? '')
                              ? "Please enter a valid email"
                              : null,
                    ),

                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      hint: "Enter your phone number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value?.isEmpty ?? true
                          ? "Please enter your phone number"
                          : null,
                    ),

                    _buildTextField(
                      controller: _passwordController,
                      label: "Password",
                      hint: "Create a strong password",
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (value) {
                        if ((value?.length ?? 0) < 8) {
                          return "Password must be at least 8 characters";
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: "Confirm Password",
                      hint: "Re-enter your password",
                      icon: Icons.lock_outline,
                      obscureText: _obscureConfirmPassword, // Change this
                      suffixIcon: IconButton(
                        // Add this
                        icon: Icon(_obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF323d4f),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text("Create Account",
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Build text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF323d4f),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            textCapitalization: textCapitalization,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey[400],
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF323d4f),
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFD4AF37),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            style: GoogleFonts.poppins(
              color: const Color(0xFF323d4f),
            ),
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
