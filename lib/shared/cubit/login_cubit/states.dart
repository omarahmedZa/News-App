abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class GoogleLoginLoadingState extends LoginStates {}

class FacebookLoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates
{
  final String uId;

  LoginSuccessState(this.uId);
}

class LoginErrorState extends LoginStates {
  final String message;

  LoginErrorState(this.message);
}

class ChangeIsPassword extends LoginStates {}

class ChangeIsRememberMe extends LoginStates {}

