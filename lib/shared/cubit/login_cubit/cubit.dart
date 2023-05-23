import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app2/shared/cubit/login_cubit/states.dart';
import '../../../models/users/users_model.dart';
import '../../components/constants.dart';



class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit() :super(LoginInitialState());
  
  static LoginCubit get(context) => BlocProvider.of(context);

  bool rememberMe =false;

  void changeRememberMe (bool? value)
  {
    rememberMe = value!;
    emit(ChangeIsRememberMe());
  }

  late String message;

  void login({
  required String email,
  required String password,
})
  {
    emit(LoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
        .then((value)
    {
      uId = value.user!.uid;
      emit(LoginSuccessState(value.user!.uid));
    })
        .catchError((error)
    {
      emit(LoginErrorState(error.toString()));
    });
  }


  void googleLogin() async
  {
    emit(GoogleLoginLoadingState());
    GoogleSignIn().signIn().then((googleUser) {
      if (googleUser == null) return;

      googleUser.authentication.then((googleAuth) {
        final card = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
        FirebaseAuth.instance.signInWithCredential(card)
            .then((value) {
          final user = value.user;
          if (user == null) return;
          uId = user.uid;
          FirebaseFirestore.instance.collection('users').doc(uId).get().then((value)
          {
            if(!value.exists)
              {
                UserModel model = UserModel(
                    user.displayName!, user.email!, user.phoneNumber ?? "", uId, "",
                    user.photoURL!);

                FirebaseFirestore.instance.collection('users').doc(uId).set(
                    model.toMap());
              }
          });

          emit(LoginSuccessState(value.user!.uid));
      });
      });
    }).catchError((error)
    {
      emit(LoginErrorState(error.toString()));
    });
  }

  void facebookLogin() async
  {
    emit(FacebookLoginLoadingState());
    FacebookAuth.instance.login().then((value)
    {
      final card = FacebookAuthProvider.credential(value.accessToken!.token);
      FirebaseAuth.instance.signInWithCredential(card)
          .then((value)
      {
        final user = value.user;
        if (user == null) return;
        uId = user.uid;
        FirebaseFirestore.instance.collection('users').doc(uId).get().then((value)
        {
          if(!value.exists)
          {
            UserModel model = UserModel(
                user.displayName!, user.email!, user.phoneNumber ?? "", uId, "",
                user.photoURL!);

            FirebaseFirestore.instance.collection('users').doc(uId).set(
                model.toMap());
          }
        });

        emit(LoginSuccessState(value.user!.uid));
     });
    }).catchError((error)
    {
      emit(LoginErrorState(error.toString()));
    });
  }



  bool isPassword = true;
  void changeIsPassword()
  {
    isPassword = !isPassword;
    emit(ChangeIsPassword());
  }
  
}