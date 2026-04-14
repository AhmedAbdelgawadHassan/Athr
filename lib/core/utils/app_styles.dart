// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';

abstract class AppStyles // App Styles taked from Style Organizer pluggin
{

  static TextStyle styleMedium36(context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, baseFontSize: 36),
      fontWeight: FontWeight.w500,
    );
  }

static TextStyle styleMedium12(context) {
  return TextStyle(
    fontSize: getResponsiveFontSize(context, baseFontSize: 12),
    fontWeight: FontWeight.w500);
}


 static TextStyle styleRegular18(context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, baseFontSize: 18),
      fontWeight: FontWeight.w400);
 }

static TextStyle styleMedium24(context) {
  return TextStyle(
    fontSize: getResponsiveFontSize(context, baseFontSize: 24)
    ,fontWeight: FontWeight.w500,);
}

 static  TextStyle styleMedium16(context){
    return  TextStyle(
    fontSize: getResponsiveFontSize(context,baseFontSize: 16),
    fontWeight: FontWeight.w500,);
  }

static TextStyle styleMedium30(context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, baseFontSize: 30),
      fontWeight: FontWeight.w500,);
}


  static   TextStyle styleRegular16(context){        // convert variable to function to can receive context 
    return TextStyle(
    fontSize:getResponsiveFontSize(context,baseFontSize: 16),
    fontWeight: FontWeight.w400,
  );
  }


 static  TextStyle styleMedium20(context){
    return  TextStyle(
    fontSize: getResponsiveFontSize(context,baseFontSize: 20),
    fontWeight: FontWeight.w500,
  );
  }



static  TextStyle styleRegular14(context){
    return TextStyle(
    fontSize: getResponsiveFontSize(context,baseFontSize: 14),
    fontWeight: FontWeight.w400,
  );
  }


static  TextStyle styleRegular12(context){
    return TextStyle(
      fontSize: getResponsiveFontSize(context, baseFontSize: 12),
      fontWeight: FontWeight.w400,);
}




static  TextStyle styleRegular24(context){
    return TextStyle(
      fontSize: getResponsiveFontSize(context, baseFontSize: 24),
      fontWeight: FontWeight.w400,);
}


static  TextStyle styleMedium18(context){
    return TextStyle(
      fontSize: getResponsiveFontSize(context, baseFontSize: 18),
      fontWeight: FontWeight.w500,);
}


 

  static  TextStyle styleSemiBold16(context){
    return TextStyle(
    fontSize: getResponsiveFontSize(context,baseFontSize: 16),
    fontWeight: FontWeight.w600,
  );
  }

  static  TextStyle styleSemiBold20(context){
    return TextStyle(
    fontSize: getResponsiveFontSize(context,baseFontSize: 20),
    fontWeight: FontWeight.w600,
  );
  }

  static  TextStyle styleSemiBold12(context){
    return TextStyle(
    fontSize: getResponsiveFontSize(context,baseFontSize: 12),
    fontWeight: FontWeight.w600,
  );
  }

  static  TextStyle styleSemiBold24(context){
    return  TextStyle(
    fontSize: getResponsiveFontSize(context,baseFontSize: 24),
    fontWeight: FontWeight.w600,
  );
  }

  

  static  TextStyle styleSemiBold18(context){
    return TextStyle(
    fontSize: getResponsiveFontSize(context,baseFontSize: 18),
    fontWeight: FontWeight.w600,
  );
  }

  static  TextStyle styleBold16(context){
    return  TextStyle(
    fontSize: getResponsiveFontSize(context,baseFontSize: 16),
    fontWeight: FontWeight.w700,
  );
  }
 
 
}





 double getResponsiveFontSize(context,{required double baseFontSize,}) {    // Method to Make Text Responsive
    double scaleFactor = getScaleFactor(context);  
    double responsiveFontSize = baseFontSize * scaleFactor;
    double upperLimit = baseFontSize * 1.2;
    double lowerLimit = baseFontSize * 0.8;
    return responsiveFontSize.clamp(lowerLimit, upperLimit);
  }

  double getScaleFactor(context) {   // Method get Scale Factor that must to multiply to base font size to make it responsive


    double screenWidth=MediaQuery.of(context).size.width;
  if (screenWidth < 600) {
  return screenWidth / 420;
} else if (screenWidth < 1024) {
  return screenWidth / 768;
} else {
  return screenWidth / 1440;
}
  }