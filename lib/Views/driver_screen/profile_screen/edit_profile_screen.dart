import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';
import 'package:vroom_ride_app/Resources/customComponents.dart';
import 'package:vroom_ride_app/Views/driver_screen/profile_screen/profile_details_screen.dart';
import 'package:vroom_ride_app/components/customButton.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController DocumentsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            // Get.back();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfileDetailsScreen()));
          },
          child: myBackButton(context),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: CustomSize().customWidth(context) / 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(CustomSize().customWidth(context) / 25),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: CustomSize().customWidth(context) / 16,
                    bottom: CustomSize().customWidth(context) / 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        CustomSize().customWidth(context) / 30),
                    border: Border.all(
                        width: CustomSize().customWidth(context) / 200,
                        color: Colors.grey.shade300)),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: CustomSize().customWidth(context) / 12,
                      backgroundImage: const AssetImage(
                        'assets/images/profile_pic.jpeg',
                      ),
                    ),
                    SizedBox(height: CustomSize().customHeight(context) / 70),
                    Text(
                      'Syed Ahmed',
                      style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 31, 164, 100),
                          fontWeight: FontWeight.w600,
                          fontSize: CustomSize().customWidth(context) / 22),
                    ),
                  ],
                ),
              ),
              SizedBox(height: CustomSize().customHeight(context) / 70),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: TextField(
                  cursorColor: Colors.black,
                  enableSuggestions: true,
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Syed Ahmed",
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: CustomSize().customWidth(context) / 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customWidth(context) / 30),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: CustomSize().customWidth(context) / 600,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customWidth(context) / 30),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 31, 164, 100),
                        width: CustomSize().customWidth(context) / 200,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: CustomSize().customHeight(context) / 30),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: TextField(
                  cursorColor: Colors.black,
                  enableSuggestions: true,
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "0313 025 6758",
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: CustomSize().customWidth(context) / 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customWidth(context) / 30),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: CustomSize().customWidth(context) / 600,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customWidth(context) / 30),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 31, 164, 100),
                        width: CustomSize().customWidth(context) / 200,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: CustomSize().customHeight(context) / 30),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: TextField(
                  cursorColor: Colors.black,
                  enableSuggestions: true,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "syedahmed@gmailcom",
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: CustomSize().customWidth(context) / 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customWidth(context) / 30),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: CustomSize().customWidth(context) / 600,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customWidth(context) / 30),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 31, 164, 100),
                        width: CustomSize().customWidth(context) / 200,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: CustomSize().customHeight(context) / 30),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: DropdownButtonFormField<String>(
                  icon: const SizedBox.shrink(),
                  value: null, // Initially no selected city
                  onChanged: (String? newValue) {
                    cityController.text =
                        newValue ?? ""; // Update controller with selected city
                  },
                  items:
                      ["Karachi", "Lahore", "Islamabad", "Peshawar", "Quetta"]
                          .map((String city) => DropdownMenuItem(
                                value: city,
                                child: Text(
                                  city,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        CustomSize().customWidth(context) / 18,
                                  ),
                                ),
                              ))
                          .toList(),
                  decoration: InputDecoration(
                    labelText: "City You Drive In",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Karachi",
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: const Color.fromARGB(255, 31, 164, 100),
                      size: CustomSize().customWidth(context) / 12,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: CustomSize().customWidth(context) / 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customWidth(context) / 30),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: CustomSize().customWidth(context) / 600,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customWidth(context) / 30),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 31, 164, 100),
                        width: CustomSize().customWidth(context) / 200,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: CustomSize().customHeight(context) / 30),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: TextField(
                  cursorColor: Colors.black,
                  enableSuggestions: true,
                  enabled: false,
                  controller: DocumentsController,
                  decoration: InputDecoration(
                    labelText: "Documents",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Update Documents Details",
                    hintStyle: const TextStyle(
                      // Ensures hint color remains black when disabled
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    suffixIcon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: const Color.fromARGB(255, 31, 164, 100),
                      size: CustomSize().customWidth(context) / 16,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: CustomSize().customWidth(context) / 16,
                    ),
                    disabledBorder: OutlineInputBorder(
                      // Border when disabled
                      borderRadius: BorderRadius.circular(
                          CustomSize().customWidth(context) / 30),
                      borderSide: BorderSide(
                        color: Colors.black, // Keep border color black
                        width: CustomSize().customWidth(context) / 600,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customWidth(context) / 30),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: CustomSize().customWidth(context) / 600,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customWidth(context) / 30),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 31, 164, 100),
                        width: CustomSize().customWidth(context) / 200,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: CustomSize().customHeight(context) / 30),
              Center(
                child: SizedBox(
                  // width: CustomSize().customWidth(context) * 0.8, // Adjust width to avoid overflow
                  child: CustomButton(
                    textColor: Colors.white,
                    radius: CustomSize().customWidth(context) / 12,
                    height: CustomSize().customHeight(context) / 12,
                    width: CustomSize().customWidth(context),
                    title: "Sumbit",
                    color: const Color.fromARGB(255, 31, 164, 100),
                    loading: false,
                    onTap: () {
                      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>VerficationCode()));
                    },
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
