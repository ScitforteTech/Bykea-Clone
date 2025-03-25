import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Profile image
  File? _profileImage;
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add Cloudinary instance
  final cloudinary = CloudinaryPublic('dfkwjplv7', 'my_preset', cache: false);

  // Loading state
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        // Get additional user data from Firestore
        final userData =
            await _firestore.collection('users').doc(user.uid).get();

        setState(() {
          _nameController.text = userData.data()?['name'] ?? '';
          _emailController.text = user.email ?? '';
          _phoneController.text = userData.data()?['phoneNumber'] ?? '';
          _profileImageUrl = userData.data()?['profilePicture'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error loading user data: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
                if (_profileImage != null)
                  _buildImageSourceOption(
                    icon: Icons.delete,
                    label: "Remove",
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _profileImage = null;
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

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final User? user = _auth.currentUser;
        if (user != null) {
          // Update user data in Firestore
          Map<String, dynamic> updateData = {
            'name': _nameController.text,
            'phoneNumber': _phoneController.text,
          };

          // Update email in Firebase Auth if changed
          if (user.email != _emailController.text) {
            await user.updateEmail(_emailController.text);
          }

          // Upload profile image to Cloudinary if changed
          if (_profileImage != null) {
            try {
              CloudinaryResponse response = await cloudinary.uploadFile(
                CloudinaryFile.fromFile(
                  _profileImage!.path,
                  folder: 'profile_images',
                  resourceType: CloudinaryResourceType.Image,
                ),
              );

              // Update the profile image URL in Firestore
              updateData['profilePicture'] = response.secureUrl;
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error uploading image: $e'),
                  backgroundColor: Colors.red,
                ),
              );
              setState(() {
                _isLoading = false;
              });
              return;
            }
          }

          await _firestore.collection('users').doc(user.uid).update(updateData);

          // Reload user data to update the UI
          await _loadUserData();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    try {
      final user = _auth.currentUser;
      if (user != null && user.email != null) {
        await _auth.sendPasswordResetEmail(email: user.email!);

        // Sign out the user
        await _auth.signOut();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Password reset email sent. Please check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to login screen and clear navigation stack
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login', // Make sure this route is defined in your app's routes
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending reset email: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Edit Profile",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w300)),
        backgroundColor: const Color(0xFF323d4f),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text("Save",
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF323d4f)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Picture
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : (_profileImageUrl != null
                                        ? NetworkImage(_profileImageUrl!)
                                        : const AssetImage(
                                            'assets/images/profile_pic.jpeg'))
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
                    const SizedBox(height: 24),

                    // Full Name
                    _buildTextField(
                      controller: _nameController,
                      label: "Full Name",
                      hint: "Enter your full name",
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                    ),

                    // Email
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      hint: "Enter your email",
                      icon: Icons.email,
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
                    ),

                    // Phone Number
                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      hint: "Enter your phone number",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your phone number";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF323d4f),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Save Changes",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _sendPasswordResetEmail,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: const BorderSide(color: Color(0xFF323d4f)),
                        ),
                        child: Text(
                          "Reset Password",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF323d4f),
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

  // Build text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey[400],
              ),
              prefixIcon: Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: const Color(0xFF323d4f),
                  size: 22,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 50,
                minHeight: 50,
              ),
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
                vertical: 14,
              ),
            ),
            style: GoogleFonts.poppins(
              color: const Color(0xFF323d4f),
              fontSize: 14,
            ),
            keyboardType: keyboardType,
            readOnly: readOnly,
            maxLines: maxLines,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
