// core/widgets/pinterest_grid.dart

import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/widgets/pinterest_card.dart';
import 'package:chicora/core/widgets/pinterest_grid_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PinterestGrid<T> extends StatelessWidget {
  final List<T> items;
  final Function(T item) onTap;
  final PinterestCardConfig Function(T item) configBuilder;
  final Color? mainColor;
  final Color? darkColor;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const PinterestGrid({
    super.key,
    required this.items,
    required this.onTap,
    required this.configBuilder,
    this.mainColor,
    this.darkColor,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      shrinkWrap: shrinkWrap,
      physics: physics ??
          (shrinkWrap ? const NeverScrollableScrollPhysics() : null),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return buildPinterestCard(
          configBuilder(items[index]),
          () => onTap(items[index]),
          mainColor: mainColor ?? AppColors.primery,
          darkColor: darkColor ?? AppColors.darkprimery,
        );
      },
    );
  }
}