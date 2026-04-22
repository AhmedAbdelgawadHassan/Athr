import 'package:athr/features/azkar/presentation/view/widgets/azkar_list_widget.dart';
import 'package:athr/features/azkar/presentation/view/widgets/card_plus_header.dart';
import 'package:athr/features/azkar/presentation/view/widgets/tool_button.dart';
import 'package:flutter/material.dart' hide CardTheme;
import 'package:flutter/services.dart';

class DuaaCard extends StatefulWidget {
  final String zikr;
  final int index;

  const DuaaCard({super.key, required this.zikr, required this.index});

  @override
  State<DuaaCard> createState() => DuaaCardState();
}

class DuaaCardState extends State<DuaaCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  bool _copied = false;

  CardTheme get theme => kThemes[widget.index % kThemes.length];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.zikr));
    HapticFeedback.lightImpact();
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: theme.bg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.border, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── رقم الدعاء ──
              CardHeader(
                index: widget.index,
                theme: theme,
              ),

              // ── نص الدعاء ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    widget.zikr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 19,
                      height: 2.0,
                      color: const Color(0xFF1C1C1E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // ── الفاصل ──
              Divider(color: theme.border, thickness: 1, height: 1),

              // ── شريط الأدوات ──
              ActionBar(
                theme: theme,
                copied: _copied,
                onCopy: _copy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionBar extends StatelessWidget {
  final CardTheme theme;
  final bool copied;
  final VoidCallback onCopy;

  const ActionBar({
    super.key,
    required this.theme,
    required this.copied,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // زر مشاركة

          const SizedBox(width: 10),

          // زر نسخ
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: ToolButton(
              key: ValueKey(copied),
              icon: copied ? Icons.check_rounded : Icons.copy_rounded,
              label: copied ? 'تم النسخ' : 'نسخ',
              color: copied ? const Color(0xFF2D7A5F) : theme.accent,
              onTap: onCopy,
            ),
          ),
        ],
      ),
    );
  }
}
