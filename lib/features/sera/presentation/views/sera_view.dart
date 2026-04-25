import 'package:athr/features/sera/data/models/sera_audio_model.dart';
import 'package:athr/features/sera/presentation/views/widgets/audio_item_widget.dart';
import 'package:flutter/material.dart';

class SeraView extends StatefulWidget {
  const SeraView({super.key});

  @override
  State<SeraView> createState() => _SeraViewState();
}

class _SeraViewState extends State<SeraView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:1,
        childAspectRatio: 1.5
      ),
      itemCount:SeraAudioModel.seraList.length,
      itemBuilder: (context, index) {
        return AudioItemWidget(
          seraAudioModel:  SeraAudioModel.seraList[index],
        );
      },
    )));
  }
}
