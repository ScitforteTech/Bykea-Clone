
import 'package:flutter/cupertino.dart';

class CustomSize{
  double customWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
  double customHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }
}