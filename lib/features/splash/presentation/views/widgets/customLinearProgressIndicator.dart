import 'package:flutter/material.dart';

class Customlinearprogressindicator extends StatelessWidget {
  const Customlinearprogressindicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 100),
      child: LinearProgressIndicator(
        backgroundColor: Colors.white,
        minHeight: 3,
        valueColor: AlwaysStoppedAnimation(Colors.black),
      ),
    );
  }
}
