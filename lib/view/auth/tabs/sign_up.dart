import 'package:ahshiaka/models/auth_models/error_user_model.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/size_config.dart';
import 'package:ahshiaka/view/auth/tabs/sign_up_country_code.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth_cubit/auth_cubit.dart';
import '../../../bloc/auth_cubit/auth_states.dart';
import '../../../utilities/app_ui.dart';
import '../../../utilities/app_util.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {},
                builder: (context, state) {
                  var cubit = AuthCubit.get(context);
                  return Form(
                    key: cubit.registerFormKey,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.padding),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: SizeConfig.padding * 1.5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Icon(
                                      Icons.arrow_back,
                                    )),
                                CustomText(
                                  text: "createAccount".tr(),
                                  fontSize: SizeConfig.titleFontSize * 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.padding * 1.5,
                            ),

                            // CustomInput(
                            //   controller: cubit.registerPhone,
                            //   hint: "phoneNumber".tr(),
                            //   textInputType: TextInputType.phone,
                            //   maxLength: 9,
                            //   suffixIcon: Image.asset(
                            //     "${AppUI.imgPath}sar.png",
                            //     width: 50,
                            //   ),
                            // ),
                            SignUpCountryCodeWidget(
                              cubit: cubit,
                            ),

                            SizedBox(
                              height: SizeConfig.padding * 1.5,
                            ),
                            CustomInput(
                                controller: cubit.registerFirstName,
                                hint: "firstName".tr(),
                                textInputType: TextInputType.text),
                            SizedBox(
                              height: SizeConfig.padding * 1.5,
                            ),
                            CustomInput(
                                controller: cubit.registerLastName,
                                hint: "lastName".tr(),
                                textInputType: TextInputType.text),
                            SizedBox(
                              height: SizeConfig.padding * 1.5,
                            ),
                            //CustomInput(controller: cubit.registerUserName, hint: "userName".tr(), textInputType: TextInputType.text),
                            //SizedBox(height: SizeConfig.padding * 1.5,),
                            CustomInput(
                              controller: cubit.registerEmail,
                              hint: "email".tr(),
                              textInputType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: SizeConfig.padding * 1.5,
                            ),
                            CustomInput(
                              controller: cubit.registerPassword,
                              hint: "pass".tr(),
                              textInputType: TextInputType.text,
                              obscureText: cubit.registerVisibility,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    cubit.registerChangeVisibility();
                                  },
                                  icon: Icon(
                                    cubit.registerVisibilityIcon,
                                    color: AppUI.iconColor,
                                    size: 25,
                                  )),
                            ),
                            SizedBox(
                              height: SizeConfig.padding * 1.5,
                            ),
                            CustomInput(
                              controller: cubit.registerConfirmPassword,
                              hint: "rePass".tr(),
                              textInputType: TextInputType.text,
                              obscureText: cubit.registerConfirmVisibility,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    cubit.registerConfirmChangeVisibility();
                                  },
                                  icon: Icon(
                                    cubit.registerConfirmVisibilityIcon,
                                    color: AppUI.iconColor,
                                    size: 25,
                                  )),
                            ),

                            SizedBox(
                              height: SizeConfig.padding * 2,
                            ),
                            if (state is RegisterLoadingState)
                              const LoadingWidget()
                            else
                              CustomButton(
                                text: "signup".tr(),
                                width: double.infinity,
                                onPressed: () async {
                                  if (cubit.registerFormKey.currentState!
                                      .validate()) {
                                    if (!AppUtil.isEmailValidate(
                                        cubit.registerEmail.text)) {
                                      AppUtil.errorToast(
                                          context, "inValidEmail".tr());
                                      return;
                                    }

                                    if (!AppUtil.isPhoneValidate(
                                        cubit.registerPhone.text)) {
                                      AppUtil.errorToast(
                                          context, "inValidPhone".tr());
                                      return;
                                    }
                                    await cubit.register(context);
                                    if (cubit.registerModel!
                                        is! ErrorUserModel) {
                                      if (!mounted) return;
                                      AppUtil.successToast(
                                          context, "doneCreatedUser".tr());
                                      // AppUtil.removeUntilNavigator(context, const BottomNavTabsScreen());
                                    } else {
                                      if (!mounted) return;
                                      AppUtil.errorToast(
                                          context, "loginFailed".tr());
                                    }
                                    // AppUtil.mainNavigator(context, const VerificationScreen(type:"register"));
                                  }
                                },
                              ),
                            SizedBox(
                              height: SizeConfig.padding * 1.5,
                            ),
                            /* Row(
                              children: [
                                const Expanded(child: Divider()),
                                Expanded(child: CustomText(text: "orLoginWith".tr(),color: AppUI.shimmerColor,textAlign: TextAlign.center,)),
                                const Expanded(child: Divider()),
                              ],
                            ),*/
                            /* SizedBox(height: SizeConfig.padding * 1.5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("${AppUI.imgPath}google.png",width: SizeConfig.safeBlockHorizontal *22,),
                            SizedBox(width: SizeConfig.padding * 1.5,),
                            Image.asset("${AppUI.imgPath}facebook.png",width: SizeConfig.safeBlockHorizontal *22,),
                            SizedBox(width: SizeConfig.padding * 1.5,),
                            Image.asset("${AppUI.imgPath}apple.png",width: SizeConfig.safeBlockHorizontal *22,),
                          ],
                        ),*/
                            SizedBox(height: SizeConfig.padding),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
