import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/app_cubit/cubit.dart';
import '../../shared/cubit/app_cubit/states.dart';
import '../../shared/cubit/post_cubit/cubit.dart';
import '../../shared/cubit/post_cubit/state.dart';
import '../../shared/cubit/theme_cubit/cubit.dart';
import '../../shared/style/colors.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {

  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // if(AppCubit.get(context).userModel.myPosts.isEmpty)
    //     PostCubit.get(context).getPosts(userModel: AppCubit.get(context).userModel);
    return BlocConsumer<PostCubit,PostStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        return BlocConsumer<AppCubit,AppStates>(
          listener: (context,state)
          {
            //if(state is GetUserSuccessState && !AppCubit.get(context).isUpdateProfile)

          },
          builder: (context,state)
          {
            var cubit = AppCubit.get(context);
            if(cubit.isUpdateProfile)
              PostCubit.get(context).updateProfile(
                  userModel: AppCubit.get(context).userModel,
                  profileImage: AppCubit.get(context).updateProfile,
                  profileName: cubit.profileName
              );
            print(cubit.userModel.myPosts.length);
            return ListView(
              physics: BouncingScrollPhysics(),
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
                          buildNetworkProfileImage(imageUrl: cubit.userModel.profileImage,radius: 40),
                          SizedBox(width: 35.0,),
                          Column(
                            children:
                            [
                              Text('${cubit.userModel.myPosts.length}',style: Theme.of(context).textTheme.subtitle1,),
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
                            cubit.userModel.name,
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 15,),
                          ),
                          if(cubit.userModel.uId == '4YacAzFrPRWreDYFtvrPTQSlcFf2')
                            myVerification(),
                        ],
                      ),
                      SizedBox(height: 5.0,),
                      Text(cubit.userModel.bio,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(wordSpacing: 2.0),
                        softWrap: true,
                      ),
                      SizedBox(height: 10.0,),
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
                          condition: cubit.userModel != null && cubit.userModel.myPosts != [],
                          builder: (context) => Column(
                                children: List.generate(cubit.userModel.myPosts.length, (index) => buildPosts(model:cubit.userModel.myPosts[index],context: context,commentController: commentController)),
                              ),
                          fallback: (context) => myIndicator()
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }
    );
  }
}
