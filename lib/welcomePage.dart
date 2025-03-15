import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';
import 'package:vroom_ride_app/Views/auth_screen/login_screen.dart';
import 'package:vroom_ride_app/Views/auth_screen/phoneRegistration.dart';
import 'package:vroom_ride_app/components/customButton.dart';

class MyWelcomeView extends StatelessWidget {
  const MyWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
            SizedBox(
                                  height: CustomSize().customHeight(context) / 25),
         Center(
          child:  Image.asset("assets/images/onboardingPage1.png",scale: CustomSize().customWidth(context)/ 200,),
         ),
         SizedBox(
                                  height: CustomSize().customHeight(context) / 40),
         Text(
                                    'Your Safety is our priority',
                                    style:
                                        GoogleFonts.poppins(color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: CustomSize().customWidth(context) / 16
                                        ),
                                  ),
                                 
                                  Text(
                                    'Choose rides that are right for you',
                                    style:
                                        GoogleFonts.poppins(color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: CustomSize().customWidth(context) / 22
                                        ),
                                  ),
                                   SizedBox(
                                  height: CustomSize().customHeight(context) / 12),
    
                        CustomButton(
                          textColor: Colors.black,
                    radius: CustomSize().customWidth(context) / 40,
                    height: CustomSize().customHeight(context) / 12,
                    width: CustomSize().customWidth(context) / 1.2,
                    title: "Continue with Email",
                    color: const Color.fromARGB(255, 31, 164, 100),
                    loading: false,
                    onTap: (){
                      Navigator.pushReplacement(context,
                       MaterialPageRoute(builder: (context) => const loginScreen()));
                    },
                                   ),
                                    SizedBox(
                                  height: CustomSize().customHeight(context) / 45),
    
                                    CustomButton(
                                    textColor: Colors.black,
                    radius: CustomSize().customWidth(context) / 40,
                    height: CustomSize().customHeight(context) / 12,
                    width: CustomSize().customWidth(context) / 1.2,
                    title: "Continue with Phone",
                    color:  const Color.fromARGB(255, 31, 164, 100),
                    loading: false,
                    onTap: (){
                      Navigator.pushReplacement(context,
                       MaterialPageRoute(builder: (context) =>  PhoneRegistration()));
                    },
                                   ),
                                    SizedBox(
                                  height: CustomSize().customHeight(context) / 45),
    
                                    CustomButton(
                                    textColor: Colors.black,
                    radius: CustomSize().customWidth(context) / 40,
                    height: CustomSize().customHeight(context) / 12,
                    width: CustomSize().customWidth(context) / 1.2,
                    title: "Continue with Google",
                    color: const Color.fromARGB(255, 31, 164, 100),
                    loading: false,
                    onTap: (){
                      // Navigator.pushReplacement(context,
                      //  MaterialPageRoute(builder: (context) => const MyWelcomeView()));
                    },
                                   )

                   
            
        ],
      ),
    );
  }
}