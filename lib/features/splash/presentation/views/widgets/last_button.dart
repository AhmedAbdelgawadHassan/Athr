import 'package:flutter/material.dart';

class Lastbutton extends StatelessWidget {
  const Lastbutton({super.key, required this.onPressed});
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: Colors.black.withValues(alpha: 0.25)),
        backgroundColor: Colors.white,
        shape:CircleBorder(),
        padding: const EdgeInsets.all(15)
      ),
      onPressed:onPressed ,
       child:Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,size: 15,),
      
    );
  }
}