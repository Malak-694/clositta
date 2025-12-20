import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_key.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/core/widgets/circle_indicator.dart';
import 'package:chicora/core/widgets/custom_elevated_button.dart';
import 'package:chicora/core/widgets/custom_nav_bar.dart';
import 'package:chicora/features/customer/biding/data/models/bid_customer_model.dart';
import 'package:chicora/features/customer/biding/logic/cubit/customer_bidding_cubit.dart';
import 'package:chicora/features/customer/biding/logic/cubit/customer_bidding_state.dart';
import 'package:chicora/features/customer/biding/ui/Screens/detailes_screen.dart';
import 'package:chicora/features/customer/biding/ui/widgets/post_item.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';


class PostScreen extends StatelessWidget {
  PostScreen({super.key});
  final prefs = getIt<SharedPrefHelper>();

  String formatDateBasic(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
         body:
         Container(
           height: double.infinity,
           width: double.infinity,
           padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
           child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("My Post", style: AppStyle.headline2,),
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: (){
                      Navigator.pushNamed(context, "upload_post");
                    },
                    label: Text("new post",style: TextStyle(color: AppColors.background),),
                    icon: Icon(LucideIcons.arrowUpFromLine,color: AppColors.background,),style:  ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ternary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),)
                ],
              ),
              Expanded(
                 child: Builder(
                     builder:  (context) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.read<CustomerBiddingCubit>().getMyBids();
                       });
                     return BlocBuilder<CustomerBiddingCubit,CustomerBiddingState>(
                       builder: (context, state) {
                      return state.when(
                         initial: () => Center(child: circleIndicator()),
                         loading: () => Center(child: circleIndicator()),
                         fail: (msg) => Center(
                             child: Column(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                                Text('failed to retrive the posts'),
                              const SizedBox(height: 8),
                                CustomElevatedButton(
                                 onPressed: () => context
                                    .read<CustomerBiddingCubit>().getMyBids(),
                                     value: 'Retry',
                         ),
                         ],
                         ),
                         ),
                         success: (data) {
                           if (data is List<BidResponse>) {
                               final bids = data;
                               if (bids.isEmpty) {
                               return Center(
                               child: Text('No posts available'),
                               );
                           }
                         return ListView.builder(
                          //r padding: EdgeInsets.all(10),
                           itemCount: bids.length,
                           itemBuilder : (context, index){
                            final post = bids[index];
                            return  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                 onTap  :(){
                                   Navigator.pushNamed(context, "post_details" , arguments: {
                                     'bidId' : post.id,
                                     'urlImage': post.imageUrl,
                                     'description': post.requestDescription,
                                   },);
                                 } ,
                                 child: PostItem(
                                   title: post.requestDescription,
                                   date: formatDateBasic(post.createdAt) ,
                                   Image_url: post.imageUrl,
                                   status: post.status,
                                 ),
                               ),
                            );
                         }

                         );
                         }
                         return Center(child: Text('Unexpected data'));

                       }
                      );
                   }
                );
                     },
              ),
                ),
            ],
                 ),
         ),
        bottomNavigationBar: FutureBuilder<String?>(
          future: prefs.getSecureData(SharedPrefKey.role),
          builder: (context, snapshot) {
            final role = snapshot.data ?? "Customer";
            return FloatingNavBar(userRole: role, selectedIndex: 0);
          },
        ),
      ),
    );
  }
}
