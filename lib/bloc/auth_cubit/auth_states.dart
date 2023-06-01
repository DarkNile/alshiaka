import 'package:flutter/material.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}
class LoginVisibilityChangeState extends AuthState {}
class ConditionsAgreeChangeState extends AuthState {}
class RegisterVisibilityChangeState extends AuthState {}
class RegisterConfirmVisibilityChangeState extends AuthState {}
class GenderChangeState extends AuthState {}
class PassVisibilityChangeState extends AuthState {}

class LoginLoadingState extends AuthState{}
class LoginLoadedState extends AuthState{}
class LoginErrorState extends AuthState{}

class RegisterLoadingState extends AuthState{}
class RegisterLoadedState extends AuthState{}
class RegisterErrorState extends AuthState{}

class CheckLoadingState extends AuthState{}
class CheckLoadedState extends AuthState{}
class CheckErrorState extends AuthState{}

class ResetPassLoadingState extends AuthState{}
class ResetPassLoadedState extends AuthState{}

