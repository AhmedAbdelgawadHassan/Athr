// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Customtextfield extends StatefulWidget {
  const Customtextfield({
    super.key,
    this.controller,
    this.onChanged,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  State<Customtextfield> createState() => _CustomtextfieldState();
}

class _CustomtextfieldState extends State<Customtextfield> {
  late final TextEditingController _controller;
  var _ownsController = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
    _controller.addListener(() {
      final has = _controller.text.isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Gap(15),
          // ── الفيلد نفسه ──
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                // أيقونة البحث
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: AppColors.primaryColor,
                  ),
                ),
      
                const SizedBox(width: 10),
      
                // الإنبوت
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: widget.onChanged,
                    textInputAction: TextInputAction.search,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: AppStyles.styleSemiBold16(context).copyWith(
                      color: Colors.black87,
                      fontFamily: 'ScheherazadeNew',
                    ),
                    cursorColor: AppColors.primaryColor,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: 'ابحث عن سورة...',
                      hintStyle: AppStyles.styleRegular14(context).copyWith(
                        color: Colors.grey.shade400,
                        fontFamily: 'ScheherazadeNew',
                      ),
                    ),
                  ),
                ),
      
                // زرار المسح
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: _hasText
                      ? GestureDetector(
                          key: const ValueKey('clear'),
                          onTap: () {
                            _controller.clear();
                            widget.onChanged?.call('');
                          },
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        )
                      : const SizedBox(key: ValueKey('empty'), width: 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}