import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showCancelOrderDialog({
  required BuildContext context,
  required ValueChanged<String> onConfirm,
}) async {
  final reasonController = TextEditingController();

  await showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Cancel order', style: AppStyle.medBlack),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Please provide a reason for cancellation.',
            style: AppStyle.smallBlack,
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: reasonController,
            maxLines: 3,
            style: AppStyle.body6,
            decoration: InputDecoration(
              hintText: 'Reason',
              hintStyle: AppStyle.smallBlack.copyWith(color: AppColors.light),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.primery),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text('Back', style: AppStyle.smallBlack),
        ),
        TextButton(
          onPressed: () {
            final reason = reasonController.text.trim();
            Navigator.pop(dialogContext);
            onConfirm(reason);
          },
          child: Text(
            'Confirm cancel',
            style: AppStyle.body6.copyWith(color: AppColors.ternary),
          ),
        ),
      ],
    ),
  );
}
