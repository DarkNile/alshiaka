import 'dart:developer';

import 'package:ahshiaka/shared/cash_helper.dart';
import 'package:ahshiaka/utilities/size_config.dart';
import 'package:ahshiaka/view/auth/tabs/sign_up.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import '../../../bloc/auth_cubit/auth_cubit.dart';
import '../../../bloc/auth_cubit/auth_states.dart';
import '../../../bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import '../../../models/auth_models/error_user_model.dart';
import '../../../shared/components.dart';
import '../../../utilities/app_ui.dart';
import '../../../utilities/app_util.dart';
import '../../layout/bottom_nav_screen/bottom_nav_tabs_screen.dart';
import '../forgot_password/forgot_pass_1.dart';
class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<AuthCubit,AuthState>(
        listener: (context,state){},
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
          return GestureDetector(
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Form(
              key: cubit.loginFormKey,
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.padding),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: CustomText(text: "signin".tr(),fontSize: SizeConfig.titleFontSize *1.2,fontWeight: FontWeight.w600,)),
                      SizedBox(height: SizeConfig.padding * 1.5,),
                      CustomInput(controller: cubit.loginPhone, hint: "email".tr(), textInputType: TextInputType.emailAddress,
                        // suffixIcon: Image.asset("${AppUI.imgPath}sar.png",width: 60,),
                      ),
                      SizedBox(height: SizeConfig.padding * 1.5 ,),
                      CustomInput(controller: cubit.loginPassword, hint: "pass".tr(), textInputType: TextInputType.text,obscureText: cubit.loginVisibality,suffixIcon: IconButton(onPressed: (){
                        cubit.loginChangeVisibility();
                      }, icon: Icon(cubit.loginVisibilityIcon,color: AppUI.iconColor,size: 30,)),),
                      SizedBox(height: SizeConfig.padding),
                      InkWell(
                          onTap: (){
                            AppUtil.mainNavigator(context, const ForgotPass1());
                          },
                          child: CustomText(text: "forgetPass".tr(),color: AppUI.mainColor,)),
                      SizedBox(height: SizeConfig.padding,),
                      if(state is LoginLoadingState)
                        const LoadingWidget()
                      else
                        CustomButton(text: "signin".tr(),width: double.infinity,onPressed: () async {
                          if(!mounted)return;
                          if(!AppUtil.isEmailValidate(cubit.loginPhone.text)){
                            AppUtil.errorToast(context, "inValidEmail".tr());
                            return ;
                          }
          
                          if(cubit.loginFormKey.currentState!.validate()) {
                            await cubit.login(context);
                            if(cubit.loginModel! is !ErrorUserModel){
                              if(!mounted)return;
                              CheckoutCubit.get(context).fetchAddresses();
                              AppUtil.successToast(context, 'loginSuccessfully'.tr());
          
                              AppUtil.removeUntilNavigator(context, const BottomNavTabsScreen());
                            }else{
                              if(!mounted)return;
                              AppUtil.errorToast(context, 'loginFailed'.tr());
                            }
                          }
                        },),
                      SizedBox(height: MediaQuery.of(context).size.height*.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () async {
                                AppUtil.removeUntilNavigator(
                                    context, const BottomNavTabsScreen());
                              },
                              child: CustomText(text: "skipLogin".tr(),color: AppUI.mainColor,fontWeight: FontWeight.w600,fontSize: 16.0,)),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*.1),
                      //const Spacer(),
                     /* Row(
                        children: [
                          const Expanded(child: Divider()),
                          Expanded(child: CustomText(text: "orLoginWith".tr(),color: AppUI.shimmerColor,textAlign: TextAlign.center,)),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: SizeConfig.padding *1.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              GoogleSignIn _googleSignIn = GoogleSignIn(
                                scopes: ['email',],
                              );
                              try {
                                GoogleSignInAccount? account = await _googleSignIn.signIn();
                                cubit.loginPhone.text = account!.email;
                                cubit.loginPassword.text = "123456789";
                                if(!mounted)return;
                                await cubit.login(context);
                              } catch (error) {}
                            },
                              child: Image.asset("${AppUI.imgPath}google.png",width: SizeConfig.safeBlockHorizontal *22,)),
                           SizedBox(width: SizeConfig.padding * 1.5,),
                          Image.asset("${AppUI.imgPath}facebook.png",width: SizeConfig.safeBlockHorizontal *22,),
                           SizedBox(width: SizeConfig.padding * 1.5,),
                          Image.asset("${AppUI.imgPath}apple.png",width: SizeConfig.safeBlockHorizontal *22,),
                        ],
                      ),*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () async {
                                AppUtil.mainNavigator(
                                    context, const SignUp());
                              },
                              child: CustomText(text: "donthaveaccount".tr(),fontWeight: FontWeight.w600,fontSize: 16.0,)),
                        ],
                      ),
                      SizedBox(height: SizeConfig.padding * 1.5,),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

}
