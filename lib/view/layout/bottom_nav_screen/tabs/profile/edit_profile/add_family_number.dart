import 'package:ahshiaka/bloc/profile_cubit/profile_cubit.dart';
import 'package:ahshiaka/bloc/profile_cubit/profile_states.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';

class AddFamilyNumber extends StatefulWidget {
  const AddFamilyNumber({Key? key}) : super(key: key);

  @override
  _AddFamilyNumberState createState() => _AddFamilyNumberState();
}

class _AddFamilyNumberState extends State<AddFamilyNumber> {
  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: Scaffold(
        body: BlocBuilder<ProfileCubit,ProfileState>(
            builder: (context, ProfileState state) {
              final cubit = ProfileCubit.get(context);
              return Column(
                children: [
                  CustomAppBar(title: "addFamilyNumber".tr()),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CustomInput(controller: cubit.firstName, hint: "firstName".tr(), textInputType: TextInputType.text),
                          const SizedBox(height: 25,),
                          CustomInput(controller: cubit.firstName, hint: "size".tr(), textInputType: TextInputType.text),

                          const Spacer(),
                          CustomButton(text: "saveChanges".tr(),onPressed: (){

                          },),
                          const SizedBox(height: 10,),

                        ],
                      ),
                    ),
                  )
                ],
              );
            }
        ),
      ),
    );
  }
}
