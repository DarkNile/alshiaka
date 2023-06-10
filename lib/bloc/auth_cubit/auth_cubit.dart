import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/bloc/profile_cubit/profile_cubit.dart';
import 'package:ahshiaka/models/auth_models/error_user_model.dart';
import 'package:ahshiaka/models/auth_models/login/login_model.dart';
import 'package:ahshiaka/view/auth/auth_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/bottom_nav_tabs_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/auth_models/register/user_model.dart';
import '../../repository/auth_repository.dart';
import '../../shared/cash_helper.dart';
import '../../utilities/app_util.dart';
import '../../view/auth/forgot_password/forgot_pass_2.dart';
import '../../view/auth/forgot_password/forgot_pass_3.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final checkFormKey = GlobalKey<FormState>();
  final forgotPassFormKey = GlobalKey<FormState>();
  final newPassFormKey = GlobalKey<FormState>();

  final TextEditingController forgotPassEmail = TextEditingController();

  final TextEditingController loginPhone = TextEditingController();
  final TextEditingController loginPassword = TextEditingController();

  final TextEditingController registerEmail = TextEditingController();
  final TextEditingController registerFirstName = TextEditingController();
  final TextEditingController registerLastName = TextEditingController();
  final TextEditingController registerUserName = TextEditingController();
  final TextEditingController registerPhone = TextEditingController();
  final TextEditingController nationalNum = TextEditingController();
  final TextEditingController registerPassword = TextEditingController();
  final TextEditingController registerConfirmPassword = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final TextEditingController verifyController1 = TextEditingController();

  final TextEditingController resetPass = TextEditingController();
  final TextEditingController resetRePass = TextEditingController();

  reset() {
    forgotPassEmail.clear();
    loginPhone.clear();
    loginPassword.clear();
    registerEmail.clear();
    registerFirstName.clear();
    registerLastName.clear();
    registerUserName.clear();
    registerPhone.clear();
    nationalNum.clear();
    registerPassword.clear();
    registerConfirmPassword.clear();
    dateController.clear();
    verifyController1.clear();
    resetPass.clear();
    resetRePass.clear();
  }

  bool loginVisibality = true;

  bool registerVisibility = true;
  bool registerConfirmVisibility = true;

  IconData registerVisibilityIcon = Icons.visibility_outlined;
  void registerChangeVisibility() {
    registerVisibility = !registerVisibility;
    registerVisibilityIcon = registerVisibility
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(RegisterVisibilityChangeState());
  }

  bool male = true;
  changeGenderState(gender) {
    male = gender;
    emit(GenderChangeState());
  }

  IconData registerConfirmVisibilityIcon = Icons.visibility_off_outlined;
  void registerConfirmChangeVisibility() {
    registerConfirmVisibility = !registerConfirmVisibility;
    registerConfirmVisibilityIcon = registerConfirmVisibility

        ? Icons.visibility_outlined:
        Icons.visibility_off_outlined;
    emit(RegisterVisibilityChangeState());
  }

  IconData loginVisibilityIcon = Icons.visibility_outlined;
  void loginChangeVisibility() {
    loginVisibality = !loginVisibality;
    loginVisibilityIcon = loginVisibality
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(LoginVisibilityChangeState());
  }

  bool passVisibility = true;
  bool rePassVisibility = true;
  IconData passVisibilityIcon = Icons.visibility_outlined;
  IconData rePassVisibilityIcon = Icons.visibility_outlined;
  void passChangeVisibility() {
    passVisibility = !passVisibility;
    passVisibilityIcon = passVisibility
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(PassVisibilityChangeState());
  }

  void rePassChangeVisibility() {
    rePassVisibility = !rePassVisibility;
    rePassVisibilityIcon = rePassVisibility
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(PassVisibilityChangeState());
  }

  var loginModel;
  login(context) async {
    emit(LoginLoadingState());
    // String fcm = await AppUtil.getToken();
    Map<String, dynamic> formData = {
      "username": loginPhone.text,
      "password": loginPassword.text,
      // "token": fcm
    };
    try {
      Map<String, dynamic> response = await AuthRepositories.login(formData);
      print('response: $response');
      print(
          "responceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      if (response['token'] == null) {
        loginModel = ErrorUserModel.fromJson(response);
      } else {
        loginModel = LoginModel.fromJson(response);
        //print(loginModel.id);
        // print("------------------------------------------------------------------------------------");
        // CashHelper.setSavedString("id", loginModel.id);
        CashHelper.setSavedString("user", loginModel.userDisplayName);
        CashHelper.setSavedString("jwt", loginModel.token);
        CashHelper.setSavedString("email", loginModel.userEmail);
        CashHelper.setSavedString("pass", loginPassword.text);
        reset();
        await ProfileCubit.get(context).fetchCustomer();
        CheckoutCubit.get(context).fetchOrders(context);
      }
      emit(LoginLoadedState());
    } catch (e) {
      // AppUtil.errorToast(context, e.toString());
      emit(LoginErrorState());
      return Future.error(e);
    }
  }

  var registerModel;
  register(context) async {
    if (registerPassword.text != registerConfirmPassword.text) {
      AppUtil.errorToast(context, "passMisfit".tr());
      return;
    }
    emit(RegisterLoadingState());
    Map<String, dynamic> formData = {
      "email": registerEmail.text,
      "first_name": registerFirstName.text,
      "last_name": registerLastName.text,
      "password": registerPassword.text,
      "username": registerUserName.text,
    };

    try {
      Map<String, dynamic> response = await AuthRepositories.register(formData);
      if (response['id'] == null) {
        registerModel = ErrorUserModel.fromJson(response);
      } else {
        await ProfileCubit.get(context)
            .updatePhone(email: registerEmail.text, phone: registerPhone.text);
        registerModel = UserModel.fromJson(response);
        loginPhone.text = registerEmail.text;
        loginPassword.text = registerPassword.text;
        CashHelper.setSavedString("id", response['id'].toString());
        Map<String, dynamic> sendCodeResponse =
            await sendCode(registerEmail.text, context);
        var email = registerEmail.text;
        if (sendCodeResponse['data']['status'] == 200) {
          reset();
          AppUtil.successToast(context, "codeSentSuccessfully".tr());
          AppUtil.mainNavigator(context, ForgotPass2(email: email));
        } else {
          AppUtil.errorToast(context, "someThingWentWrong".tr());
        }
      }
      emit(RegisterLoadedState());
    } catch (e) {
      // AppUtil.errorToast(context, e.toString());
      emit(RegisterErrorState());
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> sendCode2(email, context) async {
    print(email);
    print("sssssssssssssssssssssssssssssssssssssssssssssssssss");
    emit(ResetPassLoadingState());
    try {
      Map<String, dynamic> response = await AuthRepositories.sendCode(email);
      if (response['data']['status'] == 200) {
        AppUtil.successToast(context, "codeSentSuccessfully".tr());
      } else {
        AppUtil.errorToast(context, "wrongmail".tr());
      }
      emit(ResetPassLoadedState());
      return response;
    } catch (e) {
      emit(ResetPassLoadedState());
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> sendCode(email, context) async {
    print(email);
    print("sssssssssssssssssssssssssssssssssssssssssssssssssss");
    emit(ResetPassLoadingState());
    try {
      Map<String, dynamic> response = await AuthRepositories.sendCode(email);
      if (response['data']['status'] == 200) {
        AppUtil.mainNavigator(
            context,
            ForgotPass2(
              email: forgotPassEmail.text,
              type: "forgot",
            ));
        AppUtil.successToast(context, "codeSentSuccessfully".tr());
      } else {
        AppUtil.errorToast(context, "wrongmail".tr());
      }
      emit(ResetPassLoadedState());
      return response;
    } catch (e) {
      emit(ResetPassLoadedState());
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> verifyCode(context, email, {type}) async {
    emit(ResetPassLoadingState());
    try {
      Map<String, dynamic> response =
          await AuthRepositories.validateCode(email, verifyController1.text);
      if (response['data']['status'] == 200) {
        AppUtil.successToast(context, "validCode".tr());
        if (type == "forgot") {
          AppUtil.mainNavigator(context, ForgotPass3(email: email));
        } else {
          AppUtil.removeUntilNavigator(context, const BottomNavTabsScreen());
          login(context);
        }
      } else {
        AppUtil.errorToast(context, "someThingWentWrong".tr());
      }
      emit(ResetPassLoadedState());
      return response;
    } catch (e) {
      emit(ResetPassLoadedState());
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> resetPassword(context) async {
    emit(ResetPassLoadingState());
    try {
      Map<String, dynamic> response = await AuthRepositories.resetPassword(
          forgotPassEmail.text, resetPass.text, verifyController1.text);
      if (response['data']['status'] == 200) {
        reset();
        await AppUtil.successToast(context, "passwordChangedSuccessfully".tr());
        AppUtil.removeUntilNavigator(context, const AuthScreen());
        login(context);
      } else {
        AppUtil.errorToast(context, "someThingWentWrong".tr());
      }
      emit(ResetPassLoadedState());
      return response;
    } catch (e) {
      emit(ResetPassLoadedState());
      return Future.error(e);
    }
  }

  //
  // Map<String,dynamic>? checkVerificationCodeResponse;
  //
  // checkVerificationCode(phone,code,context) async {
  //   emit(CheckLoadingState());
  //   Map<String,dynamic> formData = {
  //     "phone": phone,
  //     "recode": code
  //   };
  //   try{
  //     checkVerificationCodeResponse = await AuthRepositories.checkVerificationCode(formData);
  //     emit(CheckLoadedState());
  //   }catch(e){
  //     emit(CheckErrorState());
  //     AppUtil.errorToast(context, e.toString());
  //     return Future.error(e);
  //   }
  // }
  //
  // UserModel? changePassModel;
  // changePass(context) async {
  //   if(registerPassword.text!=registerConfirmPassword.text){
  //     AppUtil.errorToast(context, "passwordError".tr());
  //     return;
  //   }
  //   emit(LoginLoadingState());
  //   Map<String,dynamic> formData = {
  //     "phone": loginPhone.text,
  //     "password": registerPassword.text
  //   };
  //   try{
  //     Map<String,dynamic> response = await AuthRepositories.changePass(formData);
  //     changePassModel = UserModel.fromJson(response);
  //     emit(LoginLoadedState());
  //   }catch(e){
  //     AppUtil.errorToast(context, e.toString());
  //     emit(LoginErrorState());
  //     return Future.error(e);
  //   }
  // }
}
