
import 'package:flutter/material.dart';
import 'package:vroom_ride_app/Resources/CustomSize.dart';

class constant{

     static Color myMainColor=const Color(0xffFE724C);
     static Color myBlackColor=Colors.black;
     static Color myWhiteColor=Colors.white;
     static Color myGreyColor=Colors.grey;
     static Color myGrey2Color=const Color(0xff5B5B5E);
     static Color myRedColor=Colors.red;



     static mySizedBox(context,double myWidth,double myHeight){
      return SizedBox(
        width: MediaQuery.sizeOf(context).width*myWidth,
        height: MediaQuery.sizeOf(context).height*myHeight,
      );

     }
}

//Text method
myText(context,String txt,Color clr,double size,double leftSide,double topSide){
        return Container(
          margin: EdgeInsets.only(left:MediaQuery.sizeOf(context).width*leftSide,top: MediaQuery.sizeOf(context).height*topSide),
          child: Text(txt,style: TextStyle(color: clr,fontSize: size,fontWeight: FontWeight.bold),)
          );

      }


// custom Button
mycustomeButton(context,double myWidth,double myHeight,double radius,
      String txt,Color myTextColor,double size,Color myButtonColor,double leftSide,double topSide,double rightSide,double imageWidth,double imageleftSideImage,double imageRightSideSpace,{Image ?image}
      ){
        return Container(
          margin: EdgeInsets.only(left:MediaQuery.sizeOf(context).width*leftSide,top:MediaQuery.sizeOf(context).height*topSide ,right: MediaQuery.sizeOf(context).width*rightSide),
          width: myWidth,
          height: myHeight,
          decoration: BoxDecoration(
            color: myButtonColor,
            boxShadow:const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(3, 5),
              )
            ],
            borderRadius: BorderRadius.circular(radius),
          ),

          child:Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: imageleftSideImage,right: imageRightSideSpace),
                width:imageWidth,
                child: image,
              ),
              
              Text(txt,style: TextStyle(color: myTextColor,fontSize: size,fontWeight: FontWeight.bold),),
            ],
          )),

        );
      }



myDesign(context){
  return  Stack(
    children: [
            Image.asset("assets/images/Ellipse 126.png"),
            Image.asset("assets/images/Ellipse 127.png"),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset("assets/images/Ellipse 128.png"),
              ],
            ),
    ],
  );
            
}

myBackButton(context){
   return Container(
     margin: EdgeInsets.only(left: MediaQuery.sizeOf(context).width*0.06),
    //  height: 12,
     decoration: BoxDecoration(
       color: constant.myWhiteColor,
       borderRadius: BorderRadius.circular(CustomSize().customWidth(context) / 20),
          // border:Border.all(
          //   width:1 ,
          //   // color: Colors.grey.shade400
          // )
   
     ),
     child: Icon(Icons.arrow_back,color: constant.myBlackColor,),
   );
              
}


// 


myListtile(context,Image image,String txt,Color clr,double size,double leftSide,double topSide){
   return Container(
    margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).height*0.02),
     child: ListTile(
      leading: image,
      title: myText(context, txt, clr, size, leftSide, topSide),
     ),
   );
}



myTextField(context ,double width,double height,double marginwidth,double marginHeight,Color focusedColor,Color enabledColor,String hintText,TextEditingController textController,bool totHide ,{Icon? prefixIcon,Icon? suffixIcon}){
   return Container(
    
                        width: MediaQuery.sizeOf(context).width*width,
                        height: height,
                        margin: EdgeInsets.only(left: MediaQuery.sizeOf(context).width*marginwidth,top: MediaQuery.sizeOf(context).height*marginHeight ),
                         child: TextField(
                          cursorColor: constant.myMainColor,
                                    obscureText: totHide,
                                   enableSuggestions: true,
                                   keyboardType: TextInputType.number,
                                   controller: textController,
                                  
                                   decoration: InputDecoration(
                                    
                                    hintText: hintText,
                                     prefixIcon: prefixIcon,
                                     suffixIcon: suffixIcon,
                                     
                                     enabledBorder: OutlineInputBorder(
                                      
                                       borderRadius: BorderRadius.circular(12),
                                       borderSide: BorderSide(
                                         color: enabledColor,
                                         width: 2.0,
                                       )
                                     ),
                                     
                                     focusedBorder: OutlineInputBorder(
                                       borderRadius: BorderRadius.circular(12),
                                       borderSide: BorderSide(
                                         color: focusedColor,
                                         width: 2.0,
                                       )
                                     )
                                   ),
                                 ),
                       );
}


profileTextFiled(context ,double width,double height,double marginwidth,double marginHeight,Color focusedColor,Color enabledColor,String hintText,TextEditingController textController,bool totHide ,bool checkEdit,{Icon? prefixIcon,Icon? suffixIcon}){
   return Container(
    
                        width: MediaQuery.sizeOf(context).width*width,
                        height: height,
                        margin: EdgeInsets.only(left: MediaQuery.sizeOf(context).width*marginwidth,top: MediaQuery.sizeOf(context).height*marginHeight ),
                         child: TextField(
                          readOnly: checkEdit,
                          cursorColor: constant.myMainColor,
                                    obscureText: totHide,
                                   enableSuggestions: true,
                                   keyboardType: TextInputType.number,
                                   controller: textController,
                                  
                                   decoration: InputDecoration(
                                    
                                    hintText: hintText,
                                     prefixIcon: prefixIcon,
                                     suffixIcon: suffixIcon,
                                     
                                     enabledBorder: OutlineInputBorder(
                                      
                                       borderRadius: BorderRadius.circular(12),
                                       borderSide: BorderSide(
                                         color: enabledColor,
                                         width: 2.0,
                                       )
                                     ),
                                     
                                     focusedBorder: OutlineInputBorder(
                                       borderRadius: BorderRadius.circular(12),
                                       borderSide: BorderSide(
                                         color: focusedColor,
                                         width: 2.0,
                                       )
                                     )
                                   ),
                                 ),
                       );
}
