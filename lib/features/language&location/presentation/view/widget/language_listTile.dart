import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/language&location/data/languageListTileItemModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LanguageListtile extends StatelessWidget {
  const LanguageListtile({super.key, required this.languagelisttileitemmodel, required this.isActive,});
  final Languagelisttileitemmodel languagelisttileitemmodel;
  final bool isActive;



  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color:isActive? AppColors.primaryColor:Colors.white,width: isActive? 2:1),
      ),
      leading: Image.asset(languagelisttileitemmodel.countryFlag),
      title: Text(languagelisttileitemmodel.title,style: AppStyles.styleRegular14(context),),
      subtitle: Text(languagelisttileitemmodel.subtitle,style: AppStyles.styleRegular14(context).copyWith(color: Color(0xff6B6B6B)),),
      trailing:isActive? Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor,
        ),
        child: Icon(FontAwesomeIcons.check.data,color: Colors.white,size: 14,),
    
      ):null
    );
  }
}