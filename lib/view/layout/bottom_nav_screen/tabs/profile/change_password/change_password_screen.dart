import 'package:ahshiaka/bloc/profile_cubit/profile_cubit.dart';
import 'package:ahshiaka/bloc/profile_cubit/profile_states.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../shared/cash_helper.dart';
import '../../../../../../utilities/app_ui.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String oldPass = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPass();
  }

  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: Scaffold(
        body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, ProfileState state) {
          final cubit = ProfileCubit.get(context);
          return Form(
            key: cubit.changePassFormState,
            child: Column(
              children: [
                CustomAppBar(title: "changePass".tr()),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CustomInput(
                          controller: cubit.oldPassword,
                          hint: "oldPass".tr(),
                          textInputType: TextInputType.text,
                          obscureText: cubit.oldPassVisibility,
                          suffixIcon: IconButton(
                              onPressed: () {
                                cubit.oldPassChangeVisibility();
                              },
                              icon: Icon(
                                cubit.oldPassVisibilityIcon,
                                color: AppUI.iconColor,
                                size: 25,
                              )),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        CustomInput(
                          controller: cubit.password,
                          hint: "rePass".tr(),
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
                          height: 25,
                        ),
                        CustomInput(
                          controller: cubit.rePassword,
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
                          height: 30,
                        ),
                        BlocBuilder<ProfileCubit, ProfileState>(
                            buildWhen: (_, state) =>
                                state is ChangePassLoadingState ||
                                state is ChangePassLoadedState ||
                                state is ChangePassErrorState,
                            builder: (context, ProfileState state) {
                              if (state is ChangePassLoadingState) {
                                return const LoadingWidget();
                              }
                              return CustomButton(
                                text: "saveChanges".tr(),
                                onPressed: () async {
                                  if (cubit.changePassFormState.currentState!
                                      .validate()) {
                                    if (cubit.password.text !=
                                        cubit.rePassword.text) {
                                      AppUtil.newErrorToastTOP(
                                          context, "passMisfit".tr());
                                      return;
                                    }
                                    if (cubit.oldPassword.text != oldPass) {
                                      AppUtil.newErrorToastTOP(
                                          context, "invalidOldPass".tr());
                                      return;
                                    }
                                    await cubit.changePass();
                                    if (!mounted) return;
                                    cubit.password.clear();
                                    cubit.rePassword.clear();
                                    cubit.oldPassword.clear();
                                    AppUtil.newSuccessToastTOP(context,
                                        "passwordChangedSuccessfully".tr());
                                  }
                                },
                              );
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  getPass() async {
    oldPass = await CashHelper.getSavedString("pass", "");
  }
}
