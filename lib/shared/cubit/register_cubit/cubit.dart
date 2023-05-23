import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app2/shared/cubit/register_cubit/states.dart';

import '../../../models/users/users_model.dart';
import '../../components/constants.dart';


class RegisterCubit extends Cubit<RegisterStates>
{
  RegisterCubit() :super(RegisterInitialState());
  
  static RegisterCubit get(context) => BlocProvider.of(context);

  late String message;


  void register({
 required String name,
 required String email,
 required String password,
 required String phone,
})
  {
    emit(RegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
        .then((value)
    {
      print(value.user!.uid);
      uId = value.user!.uid;
      createUser(name: name, email: email, uId: value.user!.uid, phone: phone);
      emit(RegisterSuccessState());
    })
        .catchError((error)
    {
      emit(RegisterErrorState(error.toString()));
    });
  }

  void createUser({
   required String name,
   required String email,
   required String uId,
   required String phone,
   String image = 'https://springhub.org/wp-content/uploads/2021/04/blank_profile.png',
  })
  {
    emit(UserCreateLoadingState());
    UserModel model = UserModel(name, email, phone, uId,'',image);
    model.isAdmin = true;
    FirebaseFirestore.instance.collection('users').doc(uId).set(model.toMap())
        .then((value)
    {
       emit(UserCreateSuccessState(uId));
    })
        .catchError((error)
    {
      emit(UserCreateErrorState(error.toString()));
    });
  }

  bool isPassword = true;
  bool isPassword2 = true;
  void changeIsPassword()
  {
    isPassword = !isPassword;
    emit(ChangeIsPassword());
  }
  void changeIsPassword2()
  {
    isPassword2 = !isPassword2;
    emit(ChangeIsPassword());
  }
  
}