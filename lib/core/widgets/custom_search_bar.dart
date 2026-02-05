
import 'package:chicora/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.searchController, required this.onChanged,
  });
  final ValueChanged<String> onChanged;

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: "Search...",
        filled: true,
        fillColor: const Color.fromARGB(255, 242, 242, 254),
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.primery,
          size: 30,
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
    
      onChanged: onChanged
    );
  }
}
