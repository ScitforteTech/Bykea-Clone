import 'package:flutter/material.dart';

class CustomSize {
  double customWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double customHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
