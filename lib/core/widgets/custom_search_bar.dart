import 'package:chicora/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.searchController,
    required this.onSearch,
    this.onChanged,
    this.width = 380,
  });

  final ValueChanged<String> onSearch;
  final ValueChanged<String>? onChanged;
  final TextEditingController searchController;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10, // 👈 controls height
            horizontal: 12,
          ),
          hintText: "Search...",
          filled: true,
          fillColor: const Color.fromARGB(255, 242, 242, 254),
          prefixIcon: IconButton(
            icon: Icon(Icons.search, color: AppColors.primery, size: 26),
            onPressed: () => onSearch(searchController.text.trim()),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 242, 242, 254),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: AppColors.primery, // Focused border color
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: const Color.fromARGB(
                255,
                242,
                242,
                254,
              ), // Enabled (not focused) border color
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.ternary, width: 2.0),
          ),
        ),

        onChanged: onChanged,
      ),
    );
  }
}
