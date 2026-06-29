import 'package:chicora/core/constants/colors.dart';
import 'package:flutter/material.dart';

enum PrefKey { orderUpdates, bidUpdates, offerUpdates, lowStockAlerts }

class PrefMeta {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Map<String, String> subtitles;

  const PrefMeta({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitles,
  });

  String subtitleFor(String? role) =>
      subtitles[role?.toLowerCase()] ?? subtitles['default']!;
}


const prefMeta = {
  PrefKey.orderUpdates: PrefMeta(
    icon: Icons.shopping_bag_outlined,
    iconColor: AppColors.secondary,
    title: 'Order Updates',
    subtitles: {
      'customer':        'Track your order from placement to delivery',
      'tailor':          'Get notified when orders are assigned or their status changes',
      'material_seller': 'Know when your products are purchased and shipped',
      'clothes_seller':  'Know when your products are purchased and shipped',
      'seller':          'Know when your products are purchased and shipped',
      'default':         'Confirmations, shipping & delivery status',
    },
  ),
  PrefKey.bidUpdates: PrefMeta(
    icon: Icons.gavel_outlined,
    iconColor: AppColors.primery,
    title: 'Bid Updates',
    subtitles: {
      'customer': 'Know when tailors place bids on your posts and when bidding closes',
      'tailor':   'Get notified when your bid is received and when the bid closes',
      'default':  'New bid offers and bid results',
    },
  ),
  PrefKey.offerUpdates: PrefMeta(
    icon: Icons.local_offer_outlined,
    iconColor: AppColors.darksecondary,
    title: 'Offer Updates',
    subtitles: {
      'customer': 'Get notified when a tailor sends an offer or updates their work',
      'tailor':   'Know when a customer accepts, rejects, or responds to your offer',
      'default':  'Acceptances, rejections and work updates',
    },
  ),
  PrefKey.lowStockAlerts: PrefMeta(
    icon: Icons.inventory_2_outlined,
    iconColor: AppColors.ternary,
    title: 'Low Stock Alerts',
    subtitles: {
      'material_seller': 'Get alerted before your materials run out of stock',
      'clothes_seller':  'Get alerted before your clothing items run out of stock',
      'seller':          'Get alerted before your products run out of stock',
      'default':         'Get notified when your product stock is running low',
    },
  ),
};


const roleKeys = {
  'customer':        [PrefKey.orderUpdates, PrefKey.bidUpdates, PrefKey.offerUpdates],
  'tailor':          [PrefKey.orderUpdates, PrefKey.bidUpdates, PrefKey.offerUpdates],
  'material_seller': [PrefKey.orderUpdates, PrefKey.lowStockAlerts],
  'clothes_seller':  [PrefKey.orderUpdates, PrefKey.lowStockAlerts],
  'seller':          [PrefKey.orderUpdates, PrefKey.lowStockAlerts],
};

List<PrefKey> keysForRole(String? role) =>
    roleKeys[role?.toLowerCase()] ??
        [PrefKey.orderUpdates, PrefKey.bidUpdates, PrefKey.offerUpdates];