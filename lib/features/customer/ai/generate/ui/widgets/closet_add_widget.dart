import 'package:chicora/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chicora/core/constants/colors.dart';

Future<Map<String, String>?> showAddToClosetSheet(BuildContext context) {
  return showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) => const _AddToClosetForm(),
  );
}

class _AddToClosetForm extends StatefulWidget {
  const _AddToClosetForm();

  @override
  State<_AddToClosetForm> createState() => _AddToClosetFormState();
}

class _AddToClosetFormState extends State<_AddToClosetForm> {
  String selectedCategory = 'top';
  String selectedSeason = 'all';
  String selectedOccasion = 'casual';
  final colorController = TextEditingController();

  @override
  void dispose() {
    colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            Text(
              'Add to Closet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primery,
              ),
            ),
            SizedBox(height: 16.h),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              items: [
                "top",
                "bottom",
                "jacket",
                "scarf",
                "dress",
                "shoes",
                "accessories",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                setState(() => selectedCategory = val ?? 'accessories');
              },
            ),
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              value: selectedSeason,
              decoration: InputDecoration(
                labelText: 'Season',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              items: [
                "summer",
                "winter",
                "spring",
                "fall",
                "all",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                setState(() => selectedSeason = val ?? 'all');
              },
            ),
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              value: selectedOccasion,
              decoration: InputDecoration(
                labelText: 'Occasion',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              items: [
                "casual",
                "formal",
                "semi-formal",
                "party",
                "sporty",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                setState(() => selectedOccasion = val ?? 'casual');
              },
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: colorController,
              decoration: InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primery,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop({
                        'category': selectedCategory,
                        'season': selectedSeason,
                        'occasion': selectedOccasion,
                        'color': colorController.text,
                      });
                    },
                    child: Text('Add', style: AppStyle.medBackground),
                  ),
                ),
                SizedBox(width: 12.w),

                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    child: Text('Cancel', style: AppStyle.medPrimery),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
