import 'package:athr/features/azkar/data/models/azkar_category_model.dart';
import 'package:athr/features/azkar/presentation/view/widgets/azkar_card.dart';
import 'package:athr/features/azkar/presentation/view/widgets/azkar_header.dart';
import 'package:flutter/material.dart';

class AzkarView extends StatefulWidget {
  const AzkarView({super.key});

  @override
  State<AzkarView> createState() => _AzkarViewState();
}

class _AzkarViewState extends State<AzkarView> {


  final List<AzkarCard> azkarCards = [

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AzkarHeader(),
            ),
            SliverToBoxAdapter(
              child:  ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              itemCount: AzkarCategoryModel.azkarCategories.length,
              itemBuilder: (context, index) {
                return AzkarCard(
                  azkarCategoryModel: AzkarCategoryModel.azkarCategories[index]);
              },
                           ),
            )
          ],
        )
         ),
    );
  }
}