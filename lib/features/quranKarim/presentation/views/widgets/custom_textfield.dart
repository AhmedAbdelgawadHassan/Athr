import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Customtextfield extends StatefulWidget {
  const Customtextfield({super.key, this.controller, this.onChanged});

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  State<Customtextfield> createState() => _CustomtextfieldState();
}

class _CustomtextfieldState extends State<Customtextfield> {
  late final TextEditingController _controller;
  var _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: AppColors.primaryColor),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onChanged: widget.onChanged,
        style: AppStyles.styleSemiBold16(
          context,
        ).copyWith(color: Colors.grey.shade400),
        cursorColor: AppColors.secondaryColor,
        decoration: InputDecoration(
          prefixIcon: Icon(
            FontAwesomeIcons.magnifyingGlass.data,
            color: const Color(0xffA5CABF),
            size: 17,
          ),
          fillColor: const Color(0xff247F66),
          filled: true,
          hintTextDirection: TextDirection.rtl,
          hintText: "ابحث عن سورة ....",
          hintStyle: AppStyles.styleRegular16(
            context,
          ).copyWith(color: const Color(0xffA5CABF)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
