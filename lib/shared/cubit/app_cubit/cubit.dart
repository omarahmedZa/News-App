import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:news_app2/shared/cubit/app_cubit/states.dart';
import '../../../models/posts/post_model.dart';
import '../../../models/users/users_model.dart';
import '../../../modules/home/home_screen.dart';
import '../../../modules/profile/profile_screen.dart';
import '../../../modules/settings/settings_screen.dart';
import '../../components/constants.dart';
import '../../network/local/cache_helper.dart';
import '../../network/remote/dio_helper.dart';
import '../../style/colors.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);


  Color color = mainColor;

  bool getChats = false;

  bool isComment = false;

  bool isUserScreen = false;

  void openUserScreen()
  {
    isUserScreen = true;
    emit(OpeningUserScreenState());
  }
  void closeUserScreen()
  {
    isUserScreen = false;
    emit(OpeningUserScreenState());
  }

  void isCommenting()
  {
    isComment = true;
    emit(CommentingState());
  }
  void closeCommenting()
  {
    isComment = false;
    emit(CommentingState());
  }

  void changeColor()
  {
    color = color;
    emit(AppColorChange());
  }

  List<Widget> screen =
  [
    HomeScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  void typeArabic()
  {
    emit(TypeArabicState());
  }

  int currentIndex = 0;

  void changeBottomNav(int index,context)
  {
    currentIndex = index;
    emit(BottomNavBarChangeState());
  }

  late UserModel userModel;
  void getUser()
  {
    emit(GetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value)
    {
      userModel = UserModel.fromJson(value.data());

      print(userModel.name);

      emit(GetUserSuccessState());
      isUpdateProfile = false;
    });
  }

  List<UserModel> users =[];

  void getUsers()
  {
    emit(GetUsersLoadingState());
    FirebaseFirestore.instance.collection('users').snapshots()
        .listen((event)
    {
      users = [];
      event.docs.forEach((element)
      {
        if(element.id != uId)
        {
          users.add(UserModel.fromJson(element.data()));
        }

        if(element.id == event.docs.last.id)
        {
          emit(GetUsersSuccessState());
        }
      });

    });
  }

  final picker=ImagePicker();
  File profileImageFile = File('');
  Future getProfileImage()async{

    final imagePicked = await picker.pickImage(source: ImageSource.gallery);

    if(imagePicked != null){
      profileImageFile= File(imagePicked.path);
      emit(ProfileImagePickedSuccessState());
    }
    else
      {
        print('no image picked');

        emit(ProfileImagePickedErrorState());
      }
  }

  bool isUpdateProfile = false;
  String updateProfile = '';
  void uploadProfileImage({
    required String name,
    required String bio,
    required String phone,
})
  {
    isUpdateProfile = true;
    emit(UserUpdateProfileLoadingState());

    firebase_storage.FirebaseStorage.instance.ref()
        .child('users/${uId}/${Uri.file(profileImageFile.path).pathSegments.last}')
        .putFile(profileImageFile)
        .then((value)
    {
      profileImageFile = File('');
      value.ref.getDownloadURL().then((value)
      {
        updateUser(name: name, bio: bio, phone: phone,image: value);
        updateProfile = value;
      }).catchError((error){});
    })
        .catchError((error)
    {
      emit(UserUpdateProfileErrorState());
    });
  }

  String profileName = '';
  void updateUser({
    required String name,
    required String bio,
    required String phone,
    String? image,
    double? rate,
  })
  {
    isUpdateProfile = true;
    profileName = name;
    emit(UserUpdateLoadingState());
    UserModel model = UserModel(name, userModel.email, phone, userModel.uId,bio,image ?? userModel.profileImage);
    if(userModel.isAdmin)
      {
        model.isAdmin = true;
      }
    if(rate != null)
    {
      model.rate = rate.floor();
    }
    FirebaseFirestore.instance.collection('users').doc(uId).update(model.toMap())
        .then((value)
    {
      getUser();
    })
        .catchError((error)
    {
      emit(UserUpdateErrorState());
    });
  }


  List<UserModel> searchUsers =[];
  void search({
    required String text,
  })
  {
    searchUsers = [];

    searchUsers.addAll(users.where((element) => element.name.toLowerCase().contains(RegExp(text.toLowerCase()))));

    emit(SearchState());
  }

  bool logoutState = false;
  void logOut()
  {
    emit(LogOutLoadingState());
    GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut()
    .then((value)
    {
      logoutState = true;
      currentIndex = 0;
      uId = '';
      CacheHelper.removeData(key: 'uId').then((value)
      {
        emit(LogOutSuccessState());
      });
    })
    .catchError((error)
    {
      emit(LogOutErrorState());
    });
  }
}