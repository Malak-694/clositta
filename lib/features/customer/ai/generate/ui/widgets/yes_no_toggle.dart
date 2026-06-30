import 'package:chicora/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YesNoToggle extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const YesNoToggle({super.key, this.initialValue = true, this.onChanged});

  @override
  State<YesNoToggle> createState() => _YesNoToggleState();
}

class _YesNoToggleState extends State<YesNoToggle> {
  late bool isYes;

  @override
  void initState() {
    super.initState();
    isYes = widget.initialValue;
  }

  void _toggle(bool value) {
    setState(() => isYes = value);
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 48.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildOption(
            label: 'Yes',
            selected: isYes,
            onTap: () => _toggle(true),
          ),
          _buildOption(
            label: 'No',
            selected: !isYes,
            onTap: () => _toggle(false),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: selected
                ? (label == 'Yes' ? AppColors.primery : AppColors.lightternary)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
