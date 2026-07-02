import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/style.dart';

enum PriceSortOrder {
  none('Any'),
  lowToHigh('Low to High'),
  highToLow('High to Low');

  const PriceSortOrder(this.label);
  final String label;
}

class FilterResult {
  final PriceSortOrder priceSort;
  final String? gender;
  final String? season;
  final String? occasion;

  const FilterResult({
    required this.priceSort,
    required this.gender,
    required this.season,
    required this.occasion,
  });
}

Future<FilterResult?> showFilterSidebar(
  BuildContext context, {
  required PriceSortOrder initialPriceSort,
  required String? initialGender,
  required String? initialSeason,
  required String? initialOccasion,
  bool usePrice = true,
  bool useGender = true,
}) {
  return showGeneralDialog<FilterResult>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Filters',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),

    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return _FilterSidebar(
        initialPriceSort: initialPriceSort,
        initialGender: initialGender,
        initialSeason: initialSeason,
        initialOccasion: initialOccasion,
        usePrice: usePrice,
        useGender: useGender,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

class _FilterSidebar extends StatefulWidget {
  final PriceSortOrder initialPriceSort;
  final String? initialGender;
  final String? initialSeason;
  final String? initialOccasion;
  final bool usePrice;
  final bool useGender;

  const _FilterSidebar({
    required this.initialPriceSort,
    required this.initialGender,
    required this.initialSeason,
    required this.initialOccasion,
    this.usePrice = true,
    this.useGender = true,
  });

  @override
  State<_FilterSidebar> createState() => _FilterSidebarState();
}

class _FilterSidebarState extends State<_FilterSidebar> {
  late PriceSortOrder _priceSort = widget.initialPriceSort;
  late String? _gender = widget.initialGender;
  late String? _season = widget.initialSeason;
  late String? _occasion = widget.initialOccasion;

  void _pop() {
    Navigator.pop(
      context,
      FilterResult(
        priceSort: _priceSort,
        gender: _gender,
        season: _season,
        occasion: _occasion,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        elevation: 16,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          height: double.infinity,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Filter & Sort', style: AppStyle.medPrimery),
                      IconButton(
                        icon: Icon(Icons.close, color: AppColors.darkprimery),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  if (widget.usePrice) ...[
                    Text('Sort By Price', style: AppStyle.body5),
                    SizedBox(height: 8.h),
                    _buildDropdown(
                      hint: 'Price Sort',
                      value: _priceSort.label,
                      items: PriceSortOrder.values.map((e) => e.label).toList(),
                      onChanged: (val) {
                        if (val == null) return;
                        setState(() {
                          _priceSort = PriceSortOrder.values.firstWhere(
                            (e) => e.label == val,
                          );
                        });
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],

                  if (widget.useGender) ...[
                    Text('Gender', style: AppStyle.body5),
                    SizedBox(height: 8.h),
                    _buildDropdown(
                      hint: 'Gender',
                      value: _gender,
                      items: const ['Male', 'Female', 'Kids', 'Unisex'],
                      onChanged: (val) => setState(() => _gender = val),
                    ),
                    SizedBox(height: 20.h),
                  ],
                  Text('Season', style: AppStyle.body5),
                  SizedBox(height: 8.h),
                  _buildDropdown(
                    hint: 'Season',
                    value: _season,
                    items: const ['Winter', 'Summer', 'Spring', 'Autumn'],
                    onChanged: (val) => setState(() => _season = val),
                  ),
                  SizedBox(height: 20.h),
                  Text('Occasion', style: AppStyle.body5),
                  SizedBox(height: 8.h),
                  _buildDropdown(
                    hint: 'Occasion',
                    value: _occasion,
                    items: const [
                      'Casual',
                      'Formal',
                      'Wedding',
                      'Sport',
                      'Beach',
                      'Party',
                      'Other',
                    ],
                    onChanged: (val) => setState(() => _occasion = val),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _pop,
                      child: const Text('Apply'),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primery,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      onPressed: () {
                        setState(() {
                          if (widget.usePrice) _priceSort = PriceSortOrder.none;
                          if (widget.useGender) _gender = null;
                          _season = null;
                          _occasion = null;
                        });
                      },
                      child: Text(
                        'Clear Filters',
                        style: AppStyle.medBackground,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primery.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(20.r),
        color: value != null ? AppColors.primery.withValues(alpha: 0.1) : null,
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        hint: Text(
          hint,
          style: AppStyle.smallBlack.copyWith(color: AppColors.light),
        ),
        underline: const SizedBox.shrink(),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.primery,
          size: 20.sp,
        ),
        isDense: true,
        items: [
          if (hint != 'Price Sort')
            DropdownMenuItem<String>(
              value: null,
              child: Text('All', style: AppStyle.smallBlack),
            ),
          ...items.map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: AppStyle.smallBlack),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
