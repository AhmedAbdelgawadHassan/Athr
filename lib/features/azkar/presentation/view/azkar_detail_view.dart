import 'package:athr/features/azkar/presentation/view/widgets/azkar_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AzkarDetailView extends StatelessWidget {
  final String title;
  final String image;
  final List<String> azkars;

  const AzkarDetailView({
    super.key,
    required this.title,
    required this.image, required this.azkars,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // category image
            Container(
              margin: const EdgeInsets.all(16),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.fill,
                ),
              ),
            ),

           Gap(10),

           ///// Widgets
           AzkarListWidget(azkar: azkars,
           )       
           
          ],
        ),
      ),
    );
  }
}