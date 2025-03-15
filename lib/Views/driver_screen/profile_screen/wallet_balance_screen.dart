import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';
import 'package:vroom_ride_app/Views/driver_screen/profile_screen/profile_details_screen.dart';

class WalletBalanceScreen extends StatelessWidget {
  const WalletBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text properly
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            CustomSize().customWidth(context) / 18,
                          ),
                          bottomRight: Radius.circular(
                              CustomSize().customWidth(context) / 18)),
                      color: const Color.fromARGB(255, 31, 164, 100)),
                  padding: EdgeInsets.only(
                      top: CustomSize().customWidth(context) / 14,
                      bottom: CustomSize().customWidth(context) / 6),
                  child: Padding(
                    padding:
                        EdgeInsets.all(CustomSize().customWidth(context) / 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileDetailsScreen()));
                            },
                            child: const Icon(Icons.arrow_back)),
                        Text(
                          'Wallet balance',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: CustomSize().customWidth(context) / 18,
                          ),
                        ),
                        const Icon(
                          Icons.menu,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: CustomSize().customHeight(context) / 8,
                      left: CustomSize().customHeight(context) / 35,
                      right: CustomSize().customHeight(context) / 45),
                  padding: EdgeInsets.only(
                      top: CustomSize().customWidth(context) / 16,
                      bottom: CustomSize().customWidth(context) / 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          CustomSize().customWidth(context) / 30),
                      border: Border.all(
                          width: CustomSize().customWidth(context) / 400,
                          color: Colors.grey.shade200)),
                  width: double.infinity,
                  child: Padding(
                    padding:
                        EdgeInsets.all(CustomSize().customWidth(context) / 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Today',
                          style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: CustomSize().customWidth(context) / 22),
                        ),
                        SizedBox(
                            height: CustomSize().customHeight(context) / 70),
                        Text(
                          '1200 EGP',
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: CustomSize().customWidth(context) / 18),
                        ),
                        SizedBox(
                            height: CustomSize().customHeight(context) / 150),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.directions_bike_rounded,
                                color: const Color.fromARGB(255, 31, 164, 100),
                                size: CustomSize().customWidth(context) / 17),
                            Text(
                              '14 Riders',
                              style: GoogleFonts.poppins(
                                  color:
                                      const Color.fromARGB(255, 31, 164, 100),
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      CustomSize().customWidth(context) / 22),
                            ),
                          ],
                        ),
                        Divider(
                            color: Colors.grey.shade300,
                            thickness: CustomSize().customWidth(context) / 200),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Duration Column
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Duration',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                        CustomSize().customWidth(context) / 22,
                                  ),
                                ),
                                Text(
                                  '19h 48m',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize:
                                        CustomSize().customWidth(context) / 22,
                                  ),
                                ),
                              ],
                            ),

                            // Vertical Divider
                            Container(
                              width: CustomSize().customWidth(context) /
                                  400, // Line width
                              height: CustomSize().customWidth(context) /
                                  8, // Match column height
                              color: Colors.grey.shade400, // Line color
                            ),

                            // Distance Column
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Distance',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        CustomSize().customWidth(context) / 22,
                                  ),
                                ),
                                Text(
                                  '20 km',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize:
                                        CustomSize().customWidth(context) / 22,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: CustomSize().customHeight(context) / 70),

            // Row for "Trips" and "See All"
            Padding(
              padding: EdgeInsets.all(CustomSize().customWidth(context) / 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trips',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: CustomSize().customWidth(context) / 18,
                        ),
                      ),
                      Text(
                        'See All',
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 31, 164, 100),
                          fontWeight: FontWeight.w600,
                          fontSize: CustomSize().customWidth(context) / 18,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: CustomSize().customHeight(context) / 70),

                  // Trip Card
                  ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevents scrolling inside another scrollable view
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: CustomSize().customWidth(context) / 40),
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.9, // 90% of screen width
                          padding: EdgeInsets.symmetric(
                            vertical: CustomSize().customWidth(context) / 16,
                            horizontal: CustomSize().customWidth(context) / 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customWidth(context) / 30),
                            border: Border.all(
                              width: CustomSize().customWidth(context) / 200,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Profile Image
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade600,
                                radius: CustomSize().customWidth(context) / 12,
                                child: const Icon(Icons.person,
                                    color: Colors.white),
                              ),

                              SizedBox(
                                  width:
                                      CustomSize().customWidth(context) / 30),

                              // Trip Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name and Time Row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Ahmed",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: CustomSize()
                                                    .customWidth(context) /
                                                22,
                                          ),
                                        ),
                                        Text(
                                          "Half an hour ago",
                                          style: GoogleFonts.poppins(
                                            fontSize: CustomSize()
                                                    .customWidth(context) /
                                                28,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                        height:
                                            CustomSize().customHeight(context) /
                                                150),

                                    // Distance & Duration in One Row
                                    Text(
                                      "14 km",
                                      style: GoogleFonts.poppins(
                                        fontSize:
                                            CustomSize().customWidth(context) /
                                                28,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),

                                    Text(
                                      "20 minutes",
                                      style: GoogleFonts.poppins(
                                        fontSize:
                                            CustomSize().customWidth(context) /
                                                28,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
