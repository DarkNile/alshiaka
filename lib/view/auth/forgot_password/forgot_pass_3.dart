import 'package:ahshiaka/utilities/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth_cubit/auth_cubit.dart';
import '../../../bloc/auth_cubit/auth_states.dart';
import '../../../shared/components.dart';
import '../../../utilities/app_ui.dart';

class ForgotPass3 extends StatefulWidget {
  final String email;
  const ForgotPass3({Key? key, required this.email}) : super(key: key);

  @override
  _ForgotPass3State createState() => _ForgotPass3State();
}

class _ForgotPass3State extends State<ForgotPass3> {
  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);
    return Scaffold(
      body: Form(
        key: cubit.forgotPassFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomText(
                  text: "resetPass".tr(),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                  return Column(
                    children: [
                      CustomInput(
                        controller: cubit.resetPass,
                        hint: "pass".tr(),
                        textInputType: TextInputType.text,
                        obscureText: cubit.passVisibility,
                        suffixIcon: IconButton(
                            onPressed: () {
                              cubit.passChangeVisibility();
                            },
                            icon: Icon(
                              cubit.passVisibilityIcon,
                              color: AppUI.iconColor,
                              size: 25,
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomInput(
                        controller: cubit.resetRePass,
                        hint: "rePass".tr(),
                        textInputType: TextInputType.text,
                        obscureText: cubit.rePassVisibility,
                        suffixIcon: IconButton(
                            onPressed: () {
                              cubit.rePassChangeVisibility();
                            },
                            icon: Icon(
                              cubit.rePassVisibilityIcon,
                              color: AppUI.iconColor,
                              size: 25,
                            )),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      BlocBuilder<AuthCubit, AuthState>(
                          buildWhen: (_, state) =>
                              state is ResetPassLoadingState ||
                              state is ResetPassLoadedState,
                          builder: (context, state) {
                            if (state is ResetPassLoadingState) {
                              return const LoadingWidget();
                            }
                            return CustomButton(
                              text: "submit".tr(),
                              onPressed: () {
                                if (cubit.forgotPassFormKey.currentState!
                                    .validate()) {
                                  if (cubit.resetPass.text !=
                                      cubit.resetRePass.text) {
                                    AppUtil.newErrorToastTOP(
                                        context, "passMisfit".tr());
                                    return;
                                  }
                                  cubit.resetPassword(context);
                                }
                              },
                            );
                          }),
                    ],
                  );
                }),
                // const SizedBox(height: 20,),
                // CustomText(text: "resendOTP".tr(),color: AppUI.errorColor,textDecoration: TextDecoration.underline),
                // CustomInput(controller: TextEditingController(),hint: "newPass".tr(), textInputType: TextInputType.text),
                // const SizedBox(height: 16,),
                // CustomInput(controller: TextEditingController(),hint: "reNewPass".tr(), textInputType: TextInputType.text),
                const SizedBox(
                  height: 50,
                ),
                // Row(
                //   children: [
                //     Expanded(child: Divider()),
                //     Expanded(child: CustomText(text: "isThatYou".tr(),textAlign: TextAlign.center,)),
                //     Expanded(child: Divider()),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
