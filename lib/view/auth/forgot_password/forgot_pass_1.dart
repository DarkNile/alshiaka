import 'package:ahshiaka/bloc/auth_cubit/auth_cubit.dart';
import 'package:ahshiaka/bloc/auth_cubit/auth_states.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgot_pass_2.dart';
class ForgotPass1 extends StatefulWidget {
  const ForgotPass1({Key? key}) : super(key: key);

  @override
  _ForgotPass1State createState() => _ForgotPass1State();
}

class _ForgotPass1State extends State<ForgotPass1> {
  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top,),
              Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 20,),
              CustomText(text: "resetPass".tr(),fontSize: 20,fontWeight: FontWeight.w600,),
              SizedBox(width: AppUtil.responsiveWidth(context)*0.65,child: CustomText(text: "enterEmailOrPhone".tr(),color: AppUI.shimmerColor,textAlign: TextAlign.center,)),
              const SizedBox(height: 20,),
              CustomInput(controller: cubit.forgotPassEmail,hint: "email".tr(), textInputType: TextInputType.text),
              const SizedBox(height: 50,),
              BlocBuilder<AuthCubit,AuthState>(
                buildWhen: (_,state) => state is ResetPassLoadingState || state is ResetPassLoadedState,
                builder: (context, state) {
                  if(state is ResetPassLoadingState){
                    return const LoadingWidget();
                  }
                  return CustomButton(text: "sendCode".tr(),onPressed: () async {
                    await cubit.sendCode(cubit.forgotPassEmail.text,context);
                  },);
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
