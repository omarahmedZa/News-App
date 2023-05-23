import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/users/users_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/cubit/app_cubit/cubit.dart';
import '../../shared/cubit/app_cubit/states.dart';
import '../../shared/cubit/post_cubit/cubit.dart';
import '../../shared/cubit/post_cubit/state.dart';
import '../../shared/cubit/theme_cubit/cubit.dart';
import '../../shared/style/colors.dart';
import 'edit_profile_screen.dart';


class UserProfileScreen extends StatelessWidget {

  var commentController = TextEditingController();
  bool commenting =false;
  UserModel user ;
  UserProfileScreen(this.user);
  @override
  Widget build(BuildContext context) {
    commenting = AppCubit.get(context).isComment;
    AppCubit.get(context).closeCommenting();
    return BlocConsumer<PostCubit,PostStates>(
        listener: (context, state) {},
        builder: (context, state)
        {
          if(user.myPosts.isEmpty)
          {
            PostCubit.get(context).getUserPosts(userModel: user);
          }
          return BlocConsumer<AppCubit,AppStates>(
            listener: (context,state) {},
            builder: (context,state)
            {
              return SafeArea(
                top: AppCubit.get(context).isComment ? false : true,
                child: WillPopScope(
                  onWillPop: () async
                  {
                    AppCubit.get(context).isComment = commenting;
                    AppCubit.get(context).closeUserScreen();
                    Navigator.of(context).pop();
                    return true;
                  },
                  child: Scaffold(
                    body: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children:
                            [
                              IconButton(
                                  onPressed: ()
                                  {
                                    AppCubit.get(context).isComment = commenting;
                                    AppCubit.get(context).closeUserScreen();
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.arrow_back,color: ThemeCubit.get(context).isDark ? Colors.grey[300] : Colors.black,)
                              ),
                              SizedBox(width: 10.0,),
                              Text(user.name,style: Theme.of(context).textTheme.headline3!.copyWith(
                                  fontWeight: FontWeight.bold,fontSize: 23.0,color: silverColor
                                ),
                              ),
                              if(user.uId == '4YacAzFrPRWreDYFtvrPTQSlcFf2')
                                myVerification(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children:
                            [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                  [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        buildNetworkProfileImage(imageUrl: user.profileImage,radius: 40),
                                        SizedBox(width: 35.0,),
                                        Column(
                                          children:
                                          [
                                            Text('${user.myPosts.length}',style: Theme.of(context).textTheme.subtitle1,),
                                            SizedBox(height: 5.0,),
                                            Text('Posts',style: Theme.of(context).textTheme.subtitle1,)
                                          ],
                                        ),
                                        SizedBox(width: 15.0,),

                                      ],
                                    ),
                                    SizedBox(height: 7.0,),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          user.name,
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 15,),
                                        ),
                                        if(user.uId == 'ff5Nc8LOWIPi6UZfxTDXlRc6lTs1')
                                          myVerification(),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),
                                    Text(user.bio,
                                      style: Theme.of(context).textTheme.subtitle1!.copyWith(wordSpacing: 2.0),
                                      softWrap: true,
                                    ),
                                    SizedBox(height: 10.0,),

                                    if(user.uId == uId)
                                      defaultButton(
                                        context: context,
                                        text: 'Edit Profile',
                                        height: 30.0,
                                        width: 340,
                                        color:ThemeCubit.get(context).isDark ? appDarkColor: appLightColor,
                                        fontColor: ThemeCubit.get(context).isDark ? appLightColor: appDarkColor,
                                        borderColor: Colors.grey,
                                        isUpperCase: false,
                                        function: ()=> navigateTo(context, EditProfileScreen()),
                                      ),
                                    BuildCondition(
                                        condition: user != null && user.myPosts != [],
                                        builder: (context) => Column(
                                          children: List.generate(user.myPosts.length, (index) => buildPosts(model:user.myPosts[index],context: context,commentController: commentController)),
                                        ),
                                        fallback: (context) => myIndicator()
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
    );
  }
}
