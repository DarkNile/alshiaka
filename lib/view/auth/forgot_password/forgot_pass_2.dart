import 'dart:ui';

import 'package:ahshiaka/bloc/auth_cubit/auth_states.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth_cubit/auth_cubit.dart';
import '../../../shared/components.dart';
import '../../../utilities/app_ui.dart';
import '../../../utilities/app_util.dart';

class ForgotPass2 extends StatefulWidget {
  final String email;

  final String? type;
  const ForgotPass2({Key? key, required this.email, this.type})
      : super(key: key);

  @override
  _ForgotPass2State createState() => _ForgotPass2State();
}

class _ForgotPass2State extends State<ForgotPass2> {
  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);
    return Scaffold(
      body: Padding(
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
                text: "enterYourCode".tr(),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: AppUtil.responsiveWidth(context) * 0.65,
                  child: CustomText(
                    text: widget.type == "forgot"
                        ? "codeSentToEmail".tr()
                        : "codeSentToEmail2".tr(),
                    color: AppUI.shimmerColor,
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(
                height: 30,
              ),
              CustomInput(
                  textDirection: TextDirection.ltr,
                  controller: cubit.verifyController1,
                  hint: "enterYourCode".tr(),
                  textInputType: TextInputType.text),
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
                    return Column(
                      children: [
                        CustomButton(
                          text: "verify".tr(),
                          onPressed: () {
                            cubit.verifyCode(context, widget.email,
                                type: widget.type);
                          },
                        ),
                      ],
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () {
                    cubit.sendCode2(cubit.forgotPassEmail.text, context);
                  },
                  child: CustomText(
                      text: "resendOTP".tr(),
                      color: AppUI.errorColor,
                      textDecoration: TextDecoration.underline)),

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
    );
  }
}
