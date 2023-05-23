abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  final String message;

  RegisterErrorState(this.message);
}

class UserCreateLoadingState extends RegisterStates {}

class UserCreateSuccessState extends RegisterStates {
  final String uId;

  UserCreateSuccessState(this.uId);
}

class UserCreateErrorState extends RegisterStates {
  final String message;

  UserCreateErrorState(this.message);
}

class ChangeIsPassword extends RegisterStates {}

