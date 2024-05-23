import 'dart:convert';
import 'dart:developer';

import 'package:ahshiaka/bloc/profile_cubit/profile_states.dart';
import 'package:ahshiaka/models/auth_models/profile_model.dart';
import 'package:ahshiaka/models/auth_models/register/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/profile_repository.dart';
import '../../shared/cash_helper.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);
  var contactUsFormKey = GlobalKey<FormState>();
  var changePassFormState = GlobalKey<FormState>();
  String _tabState = "current";

  String get tabState => _tabState;

  changeTabState(String tabState) {
    _tabState = tabState;
    emit(ProfileChangeTabState());
  }

  // edit profile
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var email = TextEditingController();
  var phoneN = TextEditingController();

  var id;
  var contactName = TextEditingController();
  var contactEmail = TextEditingController();
  var msg = TextEditingController();

  // change password
  var oldPassword = TextEditingController();
  var password = TextEditingController();
  var rePassword = TextEditingController();

  bool oldPassVisibility = true;
  bool passVisibility = true;
  bool rePassVisibility = true;
  IconData oldPassVisibilityIcon = Icons.visibility_off_outlined;
  IconData passVisibilityIcon = Icons.visibility_off_outlined;
  IconData rePassVisibilityIcon = Icons.visibility_off_outlined;

  void oldPassChangeVisibility() {
    oldPassVisibility = !oldPassVisibility;
    oldPassVisibilityIcon = oldPassVisibility
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
    emit(PassVisibilityChangeState());
  }

  void passChangeVisibility() {
    passVisibility = !passVisibility;
    passVisibilityIcon = passVisibility
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
    emit(PassVisibilityChangeState());
  }

  void rePassChangeVisibility() {
    rePassVisibility = !rePassVisibility;
    rePassVisibilityIcon = rePassVisibility
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
    emit(PassVisibilityChangeState());
  }

  List<ProfileModel> profileModel = [];
  fetchCustomer() async {
    profileModel.clear();
    emit(LoadingProfileState());
    String email = await CashHelper.getSavedString("email", "");
    print(email);
    print(
        "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    if (email != "") {
      print("#################################################3");
      try {
        List response = await ProfileRepository.fetchCustomer(email);
        profileModel.add(ProfileModel.fromJson(response[0]));
        firstName.text = profileModel[0].firstName!;
        lastName.text = profileModel[0].lastName!;
        this.email.text = profileModel[0].email!;
        this.id = profileModel[0].id!;
        await getPhone();
        emit(LoadedProfileState());
      } catch (e) {
        emit(ErrorProfileState());
        return Future.error(e);
      }
    }
  }

  editCustomer() async {
    emit(AddLoadingProfileState());
    var data = {
      "first_name": firstName.text,
      "last_name": lastName.text,
      "email": email.text,
      "billing": {"first_name": firstName.text},
      "shipping": {"first_name": firstName.text}
    };
    try {
      var response = await ProfileRepository.editCustomer(
          profileModel[0].id, jsonEncode(data));
      await updatePhone();
      await fetchCustomer();
      emit(AddLoadedProfileState());
    } catch (e) {
      emit(AddErrorProfileState());
      return Future.error(e);
    }
  }

  changePass() async {
    emit(ChangePassLoadingState());
    String email = await CashHelper.getSavedString("email", "");
    var data = {
      "email": email,
      "old_password": oldPassword.text,
      "password": password.text,
      "password_confirm": rePassword.text
    };
    try {
      var response = await ProfileRepository.changePass(data);
      emit(ChangePassLoadedState());
    } catch (e) {
      emit(ChangePassErrorState());
      return Future.error(e);
    }
  }

  contactUs() async {
    var data = {
      "contact_name": contactName.text,
      "contact_email": contactEmail.text,
      "contact_message": msg.text
    };
    try {
      var response = await ProfileRepository.contactUs(data);
    } catch (e) {
      return Future.error(e);
    }
  }

  List trackResponse = [];
  track(orderId) async {
    try {
      trackResponse = await ProfileRepository.track(orderId);
    } catch (e) {
      return Future.error(e);
    }
  }

  getPhone() async {
    String email = await CashHelper.getSavedString("email", "");
    try {
      var response = await ProfileRepository.getPhone(email);
      phoneN.text = response['phone'];
      log("response[phone] = ${response['phone']}");
    } catch (e) {
      return Future.error(e);
    }
  }

  updatePhone({email, phone}) async {
    String emaill = await CashHelper.getSavedString("email", "");
    try {
      await ProfileRepository.updatePhone(
          email ?? emaill, phone ?? phoneN.text);
    } catch (e) {
      return Future.error(e);
    }
  }
}
