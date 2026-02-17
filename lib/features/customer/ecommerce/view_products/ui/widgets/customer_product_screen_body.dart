import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/constants.dart';
import '../../../../../../core/router/route_names.dart';
import '../../../../../../core/widgets/custom_search_bar.dart';
import '../../../../../../core/widgets/pinterest_grid.dart';

class CustomerProductScreenBody extends StatefulWidget {
  const CustomerProductScreenBody({super.key});

  @override
  State<CustomerProductScreenBody> createState() =>
      _CustomerProductScreenBodyState();
}

class _CustomerProductScreenBodyState extends State<CustomerProductScreenBody> {
  final List<Map<String, dynamic>> _allProducts = [
    {
      "id": 1,
      "name": "Summer Dress",
      "price": 45.0,
      "rating": 4.5,
      "reviews": 128,
      "image":
          "https://i.pinimg.com/736x/31/67/f9/3167f91f439ac06358fa00c32b571eec.jpg",
      "category": "Women",
      "seller": "Fashion Hub",
      "description":
          "Beautiful flowing summer dress perfect for warm weather. Made from breathable cotton blend fabric.",
    },
    {
      "id": 2,
      "name": "Cotton Shirt",
      "price": 35.0,
      "rating": 4.2,
      "reviews": 95,
      "image":
          "https://images.unsplash.com/photo-1620799140188-3b2a02fd9a77?w=400",
      "category": "Men",
      "seller": "Classic Wear",
      "description":
          "Comfortable cotton shirt ideal for casual or business wear. Available in multiple colors.",
    },
    {
      "id": 3,
      "name": "Denim Jacket",
      "price": 89.0,
      "rating": 4.8,
      "reviews": 210,
      "image":
          "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400",
      "category": "Unisex",
      "seller": "Denim Co",
      "description":
          "Premium denim jacket with classic design. Perfect for layering any outfit.",
    },
    {
      "id": 4,
      "name": "Floral Blouse",
      "price": 42.0,
      "rating": 4.6,
      "reviews": 156,
      "image":
          "https://images.unsplash.com/photo-1564557287817-3785e38ec1f5?w=400",
      "category": "Women",
      "seller": "Fashion Hub",
      "description":
          "Elegant floral blouse with delicate patterns. Great for casual and semi-formal occasions.",
    },
    {
      "id": 5,
      "name": "Casual Pants",
      "price": 55.0,
      "rating": 4.3,
      "reviews": 87,
      "image":
          "https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=400",
      "category": "Men",
      "seller": "Comfort Wear",
      "description":
          "Lightweight and comfortable pants for everyday wear. Perfect fit and durable fabric.",
    },
    {
      "id": 6,
      "name": "Kids T-Shirt",
      "price": 25.0,
      "rating": 4.7,
      "reviews": 142,
      "image":
          "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=400",
      "category": "Kids",
      "seller": "Kids Corner",
      "description":
          "Colorful and fun t-shirt for kids. Soft fabric and easy to care for.",
    },
    {
      "id": 7,
      "name": "Coat",
      "price": 250.0,
      "rating": 4.7,
      "reviews": 142,
      "image":
          "https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?w=400",
      "category": "Kids",
      "seller": "Kids Corner",
      "description":
          "Colorful and fun t-shirt for kids. Soft fabric and easy to care for.",
    },
  ];

  void _toggleFavorite(int index) {
    setState(() {
      _filteredProducts[index]['isFavorite'] =
          !_filteredProducts[index]['isFavorite'];
    });
  }

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

  @override
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomSearchBar(
            searchController: searchController,
            onChanged: (value) {
              searchController.clear();
              _performSearch();
            },
          ),
          SizedBox(height: 20.h),
          Container(
            color: Colors.indigo,
            height: 25.h,
            width: 389.w,
            child: Text("category place holder"),
          ),
          SizedBox(height: 20.h),

          Container(
            color: Colors.indigo,
            height: 107.h,
            width: 389.w,
            child: Text("ai place holder"),
          ),
          SizedBox(height: 20.h),

          PinterestGrid(
            products: _filteredProducts,
            onTap: () {
              Navigator.pushNamed(context, RouteNames.product_details_screen);
            },
          ),
        ],
      ),
    );
  }
}
