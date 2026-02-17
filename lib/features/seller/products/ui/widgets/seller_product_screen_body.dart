import 'package:chicora/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/constants/style.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/custom_search_bar.dart';
import 'product_list_widget.dart';

class SellerProductScreenBody extends StatefulWidget {
  SellerProductScreenBody({super.key});

  @override
  State<SellerProductScreenBody> createState() =>
      _SellerProductScreenBodyState();
}

class _SellerProductScreenBodyState extends State<SellerProductScreenBody> {
  int nProducts = 4;
  final List<Map<String, dynamic>> _allProducts = [
    {
      "image":
          'https://i.pinimg.com/1200x/bf/3c/ea/bf3cea8d9492202c88b098ee0c24628b.jpg',
      'name': "Premium Silk Fabric",
      'rating': 4.7,
      'soldCount': 45,
      'pricePerYard': 45.0,
      'stock': 120,
      'status': "Active",
    },
    {
      'name': "Cotton Blend Material",
      'rating': 4.5,
      'soldCount': 89,
      'pricePerYard': 25.0,
      'stock': 5,
      'status': "Low Stock",
      'image':
          'https://i.pinimg.com/1200x/1d/0b/18/1d0b185b53c4ec35f23baf60499fe119.jpg',
    },
    {
      'name': "Linen Fabric Roll",
      'rating': 4.6,
      'soldCount': 67,
      'pricePerYard': 35.0,
      'stock': 0,
      'status': "Out of Stock",
      'image':
          'https://i.pinimg.com/1200x/e0/e1/b4/e0e1b4309fdde2b694dd32b4b4ff071b.jpg',
    },
    {
      'name': "Wool Suiting Fabric",
      'rating': 4.8,
      'soldCount': 23,
      'pricePerYard': 65.0,
      'stock': 50,
      'status': "Active",
      'image':
          'https://i.pinimg.com/1200x/1d/0b/18/1d0b185b53c4ec35f23baf60499fe119.jpg',
    },
    {
      'name': "Polyester Crepe",
      'rating': 4.3,
      'soldCount': 112,
      'pricePerYard': 18.0,
      'stock': 3,
      'status': "Low Stock",
      "image":
          'https://i.pinimg.com/1200x/bf/3c/ea/bf3cea8d9492202c88b098ee0c24628b.jpg',
    },
    {
      'name': "Chiffon Fabric",
      'rating': 4.6,
      'soldCount': 78,
      'pricePerYard': 28.0,
      'stock': 0,
      'status': "Out of Stock",
      'image':
          'https://i.pinimg.com/1200x/1d/0b/18/1d0b185b53c4ec35f23baf60499fe119.jpg',
    },
  ];

  List<Map<String, dynamic>> _filteredProducts = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_allProducts);
    searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredProducts = List.from(_allProducts);
      });
    } else {
      setState(() {
        _filteredProducts = _allProducts
            .where(
              (product) =>
                  product['name'].toString().toLowerCase().contains(query) ||
                  product['status'].toString().toLowerCase().contains(query),
            )
            .toList();
      });
    }
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        kHorizontalPadding,
        0,
        kHorizontalPadding,
        0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$nProducts Products",
                style: AppStyle.medPrimery.copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1
                    ..color = AppColors.darkprimery,
                ),
              ),
              CustomElevatedButton(
                value: "+ Add Product ",
                onPressed: () {},
                height: 40.h,
                width: 190.w,
                background: AppColors.ternary,
              ),
            ],
          ),
          CustomSearchBar(
            searchController: searchController,
            onChanged: (value) {
              searchController.clear();
              _performSearch();
            },
          ),
          ProductList(filteredProducts: _filteredProducts),
          SizedBox(height: 24.w),
        ],
      ),
    );
  }
}
