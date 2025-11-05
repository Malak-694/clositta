import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/router/route_names.dart';
import 'package:chicora/features/auth/ui/widgets/custom_elevated_button.dart';
import 'package:chicora/features/auth/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: AppColors.background,
       body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/password.png") , fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox( height : 200.h),
                 Container(
                   height: 280.h,
                   child: Image.asset("assets/images/recovery.png"),
                 ),
                Text("Password Recovery" , style: AppStyle.headline1,),
                Text("Enter your email to send \n recovery code",textAlign: TextAlign.center, style: AppStyle.body1,),
                SizedBox(
                  height: 25.h,
                ),
                CustomTextFormField(text: "Email",controller: _email ,),
                SizedBox(
                  height: 90.h,
                ),
                CustomElevatedButton(value: "Next", onPressed: (){Navigator.pushNamed(context, RouteNames.recovery_code);}),
                SizedBox(
                  height: 16.h,
                ),
                TextButton(onPressed: (){}, child: Text("cancel",style: AppStyle.body1,))
              ],
            ),
          ),
       ),
    );
  }
}
