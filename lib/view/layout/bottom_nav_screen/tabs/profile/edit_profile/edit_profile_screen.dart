import 'package:ahshiaka/bloc/profile_cubit/profile_cubit.dart';
import 'package:ahshiaka/bloc/profile_cubit/profile_states.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
import '../../../../../../utilities/app_ui.dart';
import '../../../../../../utilities/app_util.dart';
import 'add_family_number.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProfileCubit.get(context).fetchCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: Scaffold(
        body: BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (_, state) =>
                state is LoadingProfileState ||
                state is LoadedProfileState ||
                state is ErrorProfileState,
            builder: (context, ProfileState state) {
              final cubit = ProfileCubit.get(context);
              if (state is LoadingProfileState) {
                return const LoadingWidget();
              }
              if (state is ErrorProfileState) {
                return CustomText(
                  text: "error".tr(),
                  fontSize: 18,
                );
              }

              return Column(
                children: [
                  CustomAppBar(title: "profile".tr()),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CustomInput(
                              controller: cubit.firstName,
                              hint: "firstName".tr(),
                              textInputType: TextInputType.text),
                          const SizedBox(
                            height: 25,
                          ),
                          CustomInput(
                              controller: cubit.lastName,
                              hint: "lastName".tr(),
                              textInputType: TextInputType.text),
                          const SizedBox(
                            height: 25,
                          ),
                          CustomInput(
                              controller: cubit.email,
                              hint: "email".tr(),
                              textInputType: TextInputType.emailAddress),
                          const SizedBox(
                            height: 25,
                          ),
                          CustomInput(
                              controller: cubit.phoneN,
                              hint: "phoneNumber".tr(),
                              textInputType: TextInputType.phone),
                          const Spacer(),
                          BlocBuilder<ProfileCubit, ProfileState>(
                              buildWhen: (_, state) =>
                                  state is AddLoadingProfileState ||
                                  state is AddLoadedProfileState ||
                                  state is AddErrorProfileState,
                              builder: (context, ProfileState state) {
                                if (state is AddLoadingProfileState) {
                                  return const LoadingWidget();
                                }
                                return CustomButton(
                                  text: "saveChanges".tr(),
                                  onPressed: () async {
                                    await cubit.editCustomer();
                                    AppUtil.newSuccessToastTOP(context,
                                        "profileEditedSuccessfully".tr());
                                  },
                                );
                              }),
                          // const SizedBox(height: 10,),
                          // CustomButton(text: "addFamilyNumber".tr(),borderColor: AppUI.mainColor,color: AppUI.whiteColor,textColor: AppUI.mainColor,onPressed: (){
                          //   AppUtil.mainNavigator(context, AddFamilyNumber());
                          // },)
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
