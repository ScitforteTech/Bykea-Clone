import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';
import 'package:vroom_ride_app/Resources/customComponents.dart';
import 'package:vroom_ride_app/Views/driver_screen/profile_screen/edit_profile_screen.dart';
import 'package:vroom_ride_app/Views/driver_screen/profile_screen/wallet_balance_screen.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            // Get.back();
            //    Navigator.pushReplacement(context,
            //  MaterialPageRoute(builder: (context) => const MyWelcomeView()));
          },
          child: myBackButton(context),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: CustomSize().customWidth(context) / 16),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
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
                      Row(
                        children: [
                          Expanded(
                            child: CircleAvatar(
                              radius: CustomSize().customWidth(context) / 12,
                              backgroundImage: const AssetImage(
                                'assets/images/profile_pic.jpeg',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(const EditProfileScreen());
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    right: CustomSize().customWidth(context) /
                                        500),
                                child: const Icon(Icons.edit)),
                          )
                        ],
                      ),
                      SizedBox(height: CustomSize().customHeight(context) / 70),
                      Text(
                        'Syed Ahmed',
                        style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 31, 164, 100),
                            fontWeight: FontWeight.w600,
                            fontSize: CustomSize().customWidth(context) / 22),
                      ),
                      Text(
                        '0313 025 6758',
                        style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: CustomSize().customWidth(context) / 24),
                      ),
                      SizedBox(height: CustomSize().customHeight(context) / 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'My Rate',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            CustomSize().customWidth(context) /
                                                28),
                                  ),
                                  Icon(
                                    Icons.star,
                                    color:
                                        const Color.fromARGB(255, 31, 164, 100),
                                    size:
                                        CustomSize().customWidth(context) / 17,
                                  )
                                ],
                              ),
                              Text(
                                '4.30',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        CustomSize().customWidth(context) / 28),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'My Total Distance',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            CustomSize().customWidth(context) /
                                                28),
                                  ),
                                  Icon(Icons.route,
                                      color: const Color.fromARGB(
                                          255, 31, 164, 100),
                                      size: CustomSize().customWidth(context) /
                                          17)
                                ],
                              ),
                              Text(
                                '55.90 km',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        CustomSize().customWidth(context) / 28),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Total Trip',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            CustomSize().customWidth(context) /
                                                28),
                                  ),
                                  Icon(Icons.directions_bike_rounded,
                                      color: const Color.fromARGB(
                                          255, 31, 164, 100),
                                      size: CustomSize().customWidth(context) /
                                          17)
                                ],
                              ),
                              Text(
                                '26 Trip',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        CustomSize().customWidth(context) / 28),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: CustomSize().customHeight(context) / 70),
                myCustomListTile(
                    context,
                    "Your profile",
                    const Icon(
                      Icons.person_2_outlined,
                      color: Color.fromARGB(255, 31, 164, 100),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color.fromARGB(255, 31, 164, 100),
                    )),
                Divider(
                    color: Colors.grey.shade300,
                    thickness: CustomSize().customWidth(context) / 200),
                myCustomListTile(
                    context,
                    "List of trips",
                    const Icon(
                      Icons.watch_later_outlined,
                      color: Color.fromARGB(255, 31, 164, 100),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color.fromARGB(255, 31, 164, 100),
                    )),
                Divider(
                    color: Colors.grey.shade300,
                    thickness: CustomSize().customWidth(context) / 200),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WalletBalanceScreen()));
                  },
                  child: myCustomListTile(
                      context,
                      "Wallet balance",
                      const Icon(
                        Icons.email_outlined,
                        color: Color.fromARGB(255, 31, 164, 100),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color.fromARGB(255, 31, 164, 100),
                      )),
                ),
                Divider(
                    color: Colors.grey.shade300,
                    thickness: CustomSize().customWidth(context) / 200),
                myCustomListTile(
                    context,
                    "Settings",
                    const Icon(
                      Icons.settings,
                      color: Color.fromARGB(255, 31, 164, 100),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color.fromARGB(255, 31, 164, 100),
                    )),
                Divider(
                    color: Colors.grey.shade300,
                    thickness: CustomSize().customWidth(context) / 200),
                myCustomListTile(
                    context,
                    "Rating & Reviews",
                    const Icon(
                      Icons.star_border_outlined,
                      color: Color.fromARGB(255, 31, 164, 100),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color.fromARGB(255, 31, 164, 100),
                    )),
                Divider(
                    color: Colors.grey.shade300,
                    thickness: CustomSize().customWidth(context) / 200),
                myCustomListTile(
                    context,
                    "Customer Support",
                    const Icon(
                      Icons.help_center_outlined,
                      color: Color.fromARGB(255, 31, 164, 100),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color.fromARGB(255, 31, 164, 100),
                    )),
                Divider(
                    color: Colors.grey,
                    thickness: CustomSize().customWidth(context) / 200),
                myCustomListTile(
                    context,
                    "Privacy Policy",
                    const Icon(
                      Icons.security_update_good_outlined,
                      color: Color.fromARGB(255, 31, 164, 100),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color.fromARGB(255, 31, 164, 100),
                    )),
                Divider(
                    color: Colors.grey.shade300,
                    thickness: CustomSize().customWidth(context) / 200),
                myCustomListTile(
                    context,
                    "Log out",
                    const Icon(
                      Icons.logout_outlined,
                      color: Color.fromARGB(255, 31, 164, 100),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color.fromARGB(255, 31, 164, 100),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  myCustomListTile(context, String text, Icon leadingIcon, Icon trailingIcon) {
    return ListTile(
      title: Text(
        text,
        style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: CustomSize().customWidth(context) / 22),
      ),
      leading: leadingIcon,
      trailing: trailingIcon,
    );
  }
}
