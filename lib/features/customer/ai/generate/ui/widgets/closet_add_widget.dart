import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/custom_dropdown_list.dart';
import 'package:chicora/core/widgets/labeled_text_field.dart';
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
            CustomDropdownList(
              label: 'Category',
              hintText: 'Category',
              value: selectedCategory,
              items: const [
                "top",
                "bottom",
                "jacket",
                "scarf",
                "dress",
                "shoes",
                "accessories",
              ],
              onChanged: (val) {
                setState(() => selectedCategory = val ?? 'accessories');
              },
            ),
            SizedBox(height: 12.h),

            CustomDropdownList(
              label: 'Season',
              hintText: 'Season',
              value: selectedSeason,
              items: const ["summer", "winter", "spring", "fall", "all"],
              onChanged: (val) {
                setState(() => selectedSeason = val ?? 'all');
              },
            ),
            SizedBox(height: 12.h),

            CustomDropdownList(
              label: 'Occasion',
              hintText: 'Occasion',
              value: selectedOccasion,
              items: const [
                "casual",
                "formal",
                "semi-formal",
                "party",
                "sporty",
              ],
              onChanged: (val) {
                setState(() => selectedOccasion = val ?? 'casual');
              },
            ),
            SizedBox(height: 12.h),
            SizedBox(height: 12.h),
            LabeledTextField(
              controller: colorController,
              hintText: 'Enter color',
              label: 'Color',
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
