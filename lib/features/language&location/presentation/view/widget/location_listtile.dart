import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/language&location/data/location_listtile_model.dart';
import 'package:flutter/material.dart';

class LocationListtile extends StatelessWidget {
  const LocationListtile({super.key, required this.locationListtilemodel});
  final LocationListtileModel locationListtilemodel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(locationListtilemodel.title, style: AppStyles.styleMedium18(context)),
      subtitle: Text(
        locationListtilemodel.subtitle,
        style: AppStyles.styleRegular16(
          context,
        ).copyWith(color: Color(0xff6B6B6B)),
      ),
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color:Color(0xffF5F4F1)
        ),
        child: Icon(locationListtilemodel.icon,color: AppColors.primaryColor,size: 20,),)
    );
  }
}
