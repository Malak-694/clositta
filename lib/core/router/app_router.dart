import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/features/chat/ui/screens/chat_screen.dart';
import 'package:chicora/features/customer/ai/ui/screen/outfit_recomendation_screen.dart';
import 'package:chicora/features/customer/closet/logic/cubit/closet_cubit.dart';
import 'package:chicora/features/customer/closet/ui/screens/added_item_screen.dart';
import 'package:chicora/features/customer/closet/ui/screens/closet_items_screen.dart';
import 'package:chicora/features/ecommerce_multi/logic/rate_products_logic/rate_products_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/view_product_logic/view_products_cubit.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/features/auth/logic/cubit/authentication_cubit.dart';
import 'package:chicora/features/auth/ui/screens/password_recovery_screen.dart';
import 'package:chicora/features/auth/ui/screens/recovery_code_screen.dart';
import 'package:chicora/features/auth/ui/screens/reset_password_screen.dart';
import 'package:chicora/features/auth/ui/screens/log_in_screen.dart';
import 'package:chicora/features/customer/biding/logic/cubit/custom_bidding_cubit/customer_bidding_cubit.dart';
import 'package:chicora/features/customer/biding/ui/Screens/detailes_screen.dart';
import 'package:chicora/features/customer/biding/ui/Screens/form_screen.dart';
import 'package:chicora/features/customer/biding/ui/Screens/post_screen.dart';
import 'package:chicora/features/ecommerce_multi/ui/screens/order_view_screen.dart';
import 'package:chicora/features/ecommerce_multi/ui/screens/product_details_screen.dart';
import 'package:chicora/features/seller/products/logic/cubit/seller_products_cubit.dart';
import 'package:chicora/features/seller/analysis/logic/cubit/analysis_seller_cubit.dart';
import 'package:chicora/features/seller/products/ui/screens/added_product_form.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_cubit.dart';
import 'package:chicora/features/tailor/bidding_tailor/ui/Screens/detailes_screen_tailor.dart';
import 'package:chicora/features/tailor/bidding_tailor/ui/Screens/join_bidding_screen.dart';
import 'package:chicora/features/tailor/portfolio/logic/cubit/portfolio_tailor_cubit.dart';
import 'package:chicora/features/tailor/portfolio/ui/screens/added_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/ui/screens/sign_up_screen.dart';
import '../../features/chat/data/repo/chat_repo.dart';
import '../../features/chat/logic/chat_cubit/chat_cubit.dart';
import '../../features/chat/ui/screens/conversations_screen.dart';
import '../../features/customer/biding/ui/Screens/tailor_info_screen.dart';
import '../../features/customer/closet/data/models/closet_item_response_model.dart';
import '../../features/customer/closet/data/repo/closet_repo.dart';
import '../../features/customer/ecommerce/customer_cart_screen.dart';
import '../../features/customer/ecommerce/customer_products_screen.dart';
import '../../features/customer/profile/ui/customer_profile_screen.dart';
import '../../features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import '../../features/ecommerce_multi/ui/screens/seller_info_screen.dart';
import '../../features/profile/data/model/profile_model.dart';
import '../../features/profile/logic/profile_cubit.dart';
import '../../features/profile/ui/screens/edit_profile_screen.dart';
import '../../features/seller/orders/logic/cubit/order_mangement_cubit.dart';
import '../../features/seller/products/data/models/product_model_response.dart';
import '../../features/seller/analysis/ui/screens/analysis_seller_screen.dart';
import '../../features/seller/orders/ui/screens/order_mangement_screen.dart';
import '../../features/seller/products/ui/screens/seller_products_screen.dart';
import '../../features/seller/profile/ui/seller_profile_screen.dart' hide TailorProfileScreen;
import '../../features/tailor/bidding_tailor/ui/Screens/active_order_screen.dart';
import '../../features/tailor/bidding_tailor/ui/Screens/posts_tailor_screen.dart';
import '../../features/tailor/ecommerce/tailor_cart_screen.dart';
import '../../features/tailor/ecommerce/tailor_products_screen.dart';
import '../../features/tailor/portfolio/data/models/portfolio_tailor_response_model.dart';
import '../../features/tailor/portfolio/ui/screens/portfolio_tailor_screen.dart';
import '../../features/tailor/profile/ui/tailor_profile_screen.dart';
import '../constants/colors.dart';
import '../networking/socket_service.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: LoginScreen(),
          ),
        );
      case RouteNames.sing_up:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: SignUpScreen(),
          ),
        );
      case RouteNames.passord_recovery:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: PasswordRecoveryScreen(),
          ),
        );

      case RouteNames.recovery_code:
        final email = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: RecoveryCodeScreen(email: email),
          ),
        );

      case RouteNames.reset_password:
        final email = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: ResetPasswordScreen(email: email),
          ),
        );
      case RouteNames.profile_customer_screen:
        return MaterialPageRoute(
          builder: (_) => const CustomerProfileScreen(),
        );
      case RouteNames.profile_tailor_screen:
        return MaterialPageRoute(
          builder: (_) => const TailorProfileScreen(),
        );

      case RouteNames.profile_seller_screen:
        return MaterialPageRoute(
          builder: (_) => const SellerProfileScreen(),
        );
      case RouteNames.edit_profile_screen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final profile = args['profile'] as ProfileResponse?;
        final primaryColor = args['primaryColor'] as Color? ?? AppColors.primery;
        final lightColor = args['lightColor'] as Color? ?? AppColors.lightprimery;

        if (profile == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Profile data not found')),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ProfileCubit>(),
            child: EditProfileScreen(
              profile: profile,
              primaryColor: primaryColor,
              lightColor: lightColor,
            ),
          ),
        );
      case RouteNames.posts_customer:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<CustomerBiddingCubit>()),
              BlocProvider(create: (_) => getIt<ViewProductsCubit>()),

            ],
            child: const PostScreen(),
          ),
        );
    // case RouteNames.upload_post:
    //   return MaterialPageRoute(
    //     builder: (_) => BlocProvider(
    //       create: (_) => getIt<CustomerBiddingCubit>(),
    //       child: FormScreen(),
    //     ),
    //   );
      case RouteNames.upload_post:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<CustomerBiddingCubit>(),
            child: FormScreen(
              bidId: args?['bidId'],
              initialDescription: args?['initialDescription'],
              initialImageUrl: args?['initialImageUrl'],
              initialPrice: args?['initialPrice'] as double?,
              initialDuration: args?['initialDuration'],
            ),
          ),
        );
      case RouteNames.view_bidding_tailor:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<BiddingTailorCubit>(),
            child: PostScreenTailor(),
          ),
        );
      case RouteNames.outfit_recomendation:
        return MaterialPageRoute(
          builder: (_) => OutfitRecomendationScreen(),
        );
      case RouteNames.post_details_customer:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final bidId = args['bidId'] as String? ?? '';
        final urlImage = args['urlImage'] as String? ?? '';
        final description = args['description'] as String? ?? '';
        final status = args["status"] as String ?? '' ;

        return MaterialPageRoute(
          builder: (_) => BlocProvider<CustomerBiddingCubit>(
            create: (context) => getIt<CustomerBiddingCubit>(),
            child: DetailesScreen(
              bidId: bidId,
              urlImage: urlImage,
              description: description,
              bidStatus: status,
            ),
          ),
        );
      case RouteNames.view_offers_tailor:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final urlImage = args['urlImage'] as String? ?? '';
        final description = args['description'] as String? ?? '';
        final price = args['price'] as String? ?? '';
        final period = args['period'] as String? ?? '';
        final postId = args['postId'] as String? ?? ''; // optional

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<BiddingTailorCubit>(),
            child: DetailesScreenTailor(
              urlImage: urlImage,
              price: price,
              period: period,
              describtion: description,
              postId: postId,
            ),
          ),
        );
    // case RouteNames.join_bidding:
    //   final args = settings.arguments as Map<String, dynamic>? ?? {};
    //   final urlImage = args['urlImage'] as String? ?? '';
    //   final price = args['price'] as String? ?? '';
    //   final period = args['period'] as String? ?? '';
    //   final title = args['title'] as String? ?? '';
    //   final postId = args['postId'] as String? ?? '';
    //
    //   return MaterialPageRoute(
    //     builder: (_) => BlocProvider(
    //       create: (_) => getIt<BiddingTailorCubit>(),
    //       child: JoinBiddingScreen(
    //         imageUrl: urlImage,
    //         price: price,
    //         period: period,
    //         title: title,
    //         postId: postId,
    //       ),
    //     ),
    //   );
      case RouteNames.active_order:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<BiddingTailorCubit>()..getMyAcceptedOffers(),
            child: const ActiveOrderScreen(),
          ),
        );
      case RouteNames.tailor_info_screen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => TailorInfoScreen(
            name: args['name'] as String? ?? '',
            imageUrl: args['imageUrl'] as String?,
            location: args['location'] as String?,
            rating: args['rating'] as double?,
            reviewCount: args['reviewCount'] as int?,
            email: args['email'] as String?,
            tailorId: args['tailorId'] as String,
          ),
        );
      case RouteNames.join_bidding:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<BiddingTailorCubit>(),
            child: JoinBiddingScreen(
              imageUrl: args['urlImage'] ?? '',
              price: args['price'] ?? '',
              period: args['period'] ?? '',
              title: args['title'] ?? '',
              postId: args['postId'] ?? '',
              offerId: args['offerId'],
              initialPrice: args['initialPrice'],
              initialDays: args['initialDays'],
              initialMessage: args['initialMessage'],
            ),
          ),
        );
      case RouteNames.seller_products_screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<SellerProductsCubit>()..getProducts(),
            child: SellerProductsScreen(),
          ),
        );
      case RouteNames.analysis_seller_screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AnalysisSellerCubit>()..getSellerAnalysis(),
            child: const AnalysisSellerScreen(),
          ),
        );
      case RouteNames.seller_orders_screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<OrderMangementCubit>(),
            child: const OrderMangementScreen(),
          ),
        );
      case RouteNames.added_product_item:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<SellerProductsCubit>(),
            child: AddedProductForm(),
          ),
        );
      case RouteNames.update_product_screen:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<SellerProductsCubit>(),
            child: AddedProductForm(product: product),
          ),
        );
      case RouteNames.customer_products_screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ViewProductsCubit>(),
            child: CustomerProductsScreen(),
          ),
        );
      case RouteNames.tailor_products_screen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) {
                  final cart = getIt<CartCubit>();
                  cart.getCart();
                  return cart;
                },
              ),
              BlocProvider(create: (_) => getIt<ViewProductsCubit>()),
            ],
            child: TailorProductsScreen(),
          ),
        );
      case RouteNames.product_details_screen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final product = args['product'];
        final cartCubit = args['cartCubit'] as CartCubit?; // ✅ extract it

        if (product == null || cartCubit == null) {
          return MaterialPageRoute(
            builder: (_) =>
            const Scaffold(body: Center(child: Text('Product not found'))),
          );
        }

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<RateProductsCubit>()),
              BlocProvider.value(
                value: cartCubit,
              ),
            ],
            child: ProductDetailScreen(product: product),
          ),
        );
      case RouteNames.seller_info_screen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => SellerInfoScreen(
            name: args['name'] as String? ?? '',
            sellerId: args['sellerId'] as String? ?? '',
            imageUrl: args['imageUrl'] as String?,
            email: args['email'] as String?,
            location: args['location'] as String?,
            rating: args['rating'] as double?,
            reviewCount: args['reviewCount'] as int?,
          ),
        );
      case RouteNames.closet_items_screen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => ClosetCubit(closetRepo: getIt<ClosetRepo>()),
              ),
            ],
            child: ClosetItemsScreen(),
          ),
        );
      case RouteNames.upload_closet_item:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ClosetCubit>(),
            child: AddedClosetItemScreen(),
          ),
        );
      case RouteNames.update_closet_item:
        final item = settings.arguments as ClosetItemResponseModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ClosetCubit>(),
            child: AddedClosetItemScreen(item: item),
          ),
        );
      case RouteNames.portfolio_tailor_screen:
        return MaterialPageRoute(builder: (_) => PortfolioTailorScreen());
      case RouteNames.added_work_screen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<PortfolioTailorCubit>(),
            child: AddedItemScreen(),
          ),
        );
      case RouteNames.update_work_screen:
        final item = settings.arguments as PortfolioTailorResponseModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<PortfolioTailorCubit>(),
            child: AddedItemScreen(item: item),
          ),
        );
      case RouteNames.customer_cart_screen:
        return MaterialPageRoute(builder: (_) => CustomerCartScreen());
      case RouteNames.tailor_cart_screen:
        return MaterialPageRoute(builder: (_) => TailorCartScreen());
      case RouteNames.order_view_screen:
        final orderArgs =
            settings.arguments as Map<String, dynamic>? ?? {};
        final openedFromCart = orderArgs['fromCart'] as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => OrderViewScreen(openedFromCart: openedFromCart),
        );
      case RouteNames.chat_screen:
        final args         = settings.arguments as Map<String, dynamic>? ?? {};
        final receiverId   = args['receiverId']   as String? ?? '';
        final receiverName = args['receiverName'] as String? ?? '';

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ChatCubit(
              getIt<SocketService>(),
              getIt<ChatRepo>(),
            ),
            child: ChatScreen(
              receiverId:   receiverId,
              receiverName: receiverName,
            ),
          ),
        );
      case RouteNames.conversations_screen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final currentUserId = args['currentUserId'] as String? ?? '';

        return MaterialPageRoute(
          builder: (_) => ConversationsScreen(
            currentUserId: currentUserId,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined for this path')),
          ),
        );
    }
  }
}
