import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/features/customer/biding/ui/Screens/detailes_screen.dart';
import 'package:chicora/features/customer/biding/ui/widgets/post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';


class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  InkWell(
                    onTap  :(){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailesScreen(urlImage: "assets/images/dress.png", describtion: "White floral summer dress, knee-length, with short sleeves", bids_num: 180)));
                    } ,
                    child: PostItem(
                      title: 'White floral summer dress, knee-length, with short sleeves',
                      bidCount: 3,
                      date: '11/28/2025',
                      Image_url: "assets/images/dress.png",
                      status: "selected",
                    ),
                  ),
                  SizedBox(height: 15.h,),
                  InkWell(
                    onTap  :(){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailesScreen(urlImage: "assets/images/dress.png", describtion: "White floral summer dress, knee-length, with short sleeves", bids_num: 180)));
                    } ,
                    child: PostItem(
                      title: 'White floral summer dress, knee-length, with short sleeves',
                      bidCount: 3,
                      date: '11/28/2025',
                      Image_url: "assets/images/dress.png",
                      status: "open",
                    ),
                  ),

                ],
              ),
            ),
          ],
               ),
       ),
    );
  }
}
