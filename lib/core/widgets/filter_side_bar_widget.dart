import 'package:chicora/core/widgets/custom_dropdown_list.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';
import '../constants/style.dart';

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
  final String? type;

  const FilterResult({
    required this.priceSort,
    required this.gender,
    required this.season,
    required this.occasion,
    this.type,
  });
}

Future<FilterResult?> showFilterSidebar(
  BuildContext context, {
  required PriceSortOrder initialPriceSort,
  required String? initialGender,
  required String? initialSeason,
  required String? initialOccasion,
  String? initialType,
  bool usePrice = true,
  bool useGender = true,
  bool useType = false,
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
        initialType: initialType,
        usePrice: usePrice,
        useGender: useGender,
        useType: useType,
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
  final String? initialType;
  final bool usePrice;
  final bool useGender;
  final bool useType;

  const _FilterSidebar({
    required this.initialPriceSort,
    required this.initialGender,
    required this.initialSeason,
    required this.initialOccasion,
    this.initialType,
    this.usePrice = true,
    this.useGender = true,
    this.useType = false,
  });

  @override
  State<_FilterSidebar> createState() => _FilterSidebarState();
}

class _FilterSidebarState extends State<_FilterSidebar> {
  late PriceSortOrder _priceSort = widget.initialPriceSort;
  late String? _gender = widget.initialGender;
  late String? _season = widget.initialSeason;
  late String? _occasion = widget.initialOccasion;
  late String? _type = widget.initialType;

  void _pop() {
    Navigator.pop(
      context,
      FilterResult(
        priceSort: _priceSort,
        gender: _gender,
        season: _season,
        occasion: _occasion,
        type: _type,
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
                    CustomDropdownList(
                      label: 'Sort By Price',
                      hintText: 'Price Sort',
                      value: _priceSort.label,
                      items: PriceSortOrder.values.map((e) => e.label).toList(),
                      showAllOption:
                          false, // matches old `hint != 'Price Sort'` exclusion
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
                    CustomDropdownList(
                      label: 'Gender',
                      hintText: 'Gender',
                      value: _gender,
                      items: const ['Male', 'Female', 'Kids', 'Unisex'],
                      showAllOption: true,
                      onChanged: (val) => setState(() => _gender = val),
                    ),
                    SizedBox(height: 20.h),
                  ],

                  if (widget.useType) ...[
                    CustomDropdownList(
                      label: 'Type',
                      hintText: 'Type',
                      value: _type,
                      items: const ['Clothes', 'Material'],
                      showAllOption: true,
                      onChanged: (val) => setState(() => _type = val),
                    ),
                    SizedBox(height: 20.h),
                  ],

                  CustomDropdownList(
                    label: 'Season',
                    hintText: 'Season',
                    value: _season,
                    items: const ['Winter', 'Summer', 'Spring', 'Autumn'],
                    showAllOption: true,
                    onChanged: (val) => setState(() => _season = val),
                  ),
                  SizedBox(height: 20.h),

                  CustomDropdownList(
                    label: 'Occasion',
                    hintText: 'Occasion',
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
                    showAllOption: true,
                    onChanged: (val) => setState(() => _occasion = val),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _pop,
                      child: Text('Apply', style: AppStyle.medPrimery),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  CustomElevatedButton(
                    height: 47.h,
                    value: 'Clear Filters',
                    onPressed: () {
                      setState(() {
                        if (widget.usePrice) _priceSort = PriceSortOrder.none;
                        if (widget.useGender) _gender = null;
                        if (widget.useType) _type = null;
                        _season = null;
                        _occasion = null;
                      });
                    },
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
}
