import 'package:ahshiaka/bloc/profile_cubit/profile_cubit.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = ProfileCubit.get(context);
    return CheckNetwork(
      child: Scaffold(
        appBar: customAppBar(title: "contactUs".tr(),elevation: 0),
        body: Form(
          key: cubit.contactUsFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 16,),
                CustomInput(controller: cubit.contactName,hint: "firstName".tr(), textInputType: TextInputType.name),
                const SizedBox(height: 16,),
                CustomInput(controller: cubit.contactEmail,hint: "email".tr(), textInputType: TextInputType.emailAddress),
                const SizedBox(height: 16,),
                CustomInput(controller: cubit.msg,hint: "message".tr(), textInputType: TextInputType.text,maxLines: 4,),
                const SizedBox(height: 40,),
                CustomButton(text: "send".tr(),onPressed: () async {
                  if(!AppUtil.isEmailValidate(cubit.contactEmail.text)){
                    AppUtil.errorToast(context, "inValidEmail".tr());
                    return ;
                  }
                  if(cubit.contactUsFormKey.currentState!.validate()) {
                    AppUtil.dialog2(context, "", const [
                      LoadingWidget(),
                      SizedBox(height: 30,)
                    ]);
                    await cubit.contactUs();
                    Navigator.of(context,rootNavigator: true).pop();
                    AppUtil.successToast(context, "sentSuccessfully".tr());
                  }
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
