

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/app_cubit/cubit.dart';
import '../../shared/cubit/app_cubit/states.dart';
import '../../shared/cubit/post_cubit/cubit.dart';
import '../../shared/cubit/post_cubit/state.dart';
import '../../shared/style/colors.dart';
import '../profile/user_profile_screen.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();
  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state) {},
      builder: (context,state)
        {
        return SafeArea(
          top: AppCubit.get(context).isComment ? false : true,
          child: WillPopScope(
            onWillPop: () async
            {
              AppCubit.get(context).searchUsers = [];
              PostCubit.get(context).searchPosts = [];
              Navigator.of(context).pop();
              return true;
            },
            child: Scaffold(
              appBar: AppCubit.get(context).isComment ? null : AppBar(
                toolbarHeight: 70,
                leadingWidth: 25.0,
                titleSpacing: 20.0,
                title: Container(
                  height: 50.0,
                  width: 300.0,
                  padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 7.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.grey[400]
                  ),
                  child: TextFormField(
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.subtitle1,
                      cursorColor: silverColor,
                      cursorHeight: 20.0,
                      textDirection: searchController.text.contains(RegExp(r'[\u0600-\u06FF]')) ? TextDirection.rtl :TextDirection.ltr,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: Theme.of(context).textTheme.subtitle1,
                        prefixIcon: Icon(Icons.search,color: silverColor,),
                      ),
                      onChanged: (value)
                      {
                        if(AppCubit.get(context).currentIndex ==0 && value.isNotEmpty)
                        {
                          AppCubit.get(context).search(text: value);
                          PostCubit.get(context).search(text: value);
                        }
                        // else if(AppCubit.get(context).currentIndex == 1 && value.isNotEmpty)
                        // {
                        //   ChatCubit.get(context).search(text: value);
                        // }
                      }
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocConsumer<PostCubit,PostStates>(
                      listener: (context,state) {},
                      builder: (context,state)
                      {
                        return ListView(
                            physics: BouncingScrollPhysics(),
                            children:
                            [
                              SizedBox(height: 10.0,),
                              if(AppCubit.get(context).searchUsers.isNotEmpty)
                                Text(
                                  'People',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              if(AppCubit.get(context).searchUsers.isNotEmpty)
                                Column(
                                  children: List.generate(AppCubit.get(context).searchUsers.length, (index) =>
                                      InkWell(
                                        onTap: ()
                                        {
                                          if(AppCubit.get(context).isUserScreen == false)
                                          {
                                            AppCubit.get(context).openUserScreen();
                                            PostCubit.get(context).getUserPosts(userModel:AppCubit.get(context).searchUsers[index]);
                                            navigateAndDelTo(context, UserProfileScreen(AppCubit.get(context).searchUsers[index]));
                                          }
                                        },
                                        child: Container(
                                          height: 80,
                                          child: Row(
                                            children:
                                            [
                                              buildNetworkProfileImage(
                                                  imageUrl: AppCubit.get(context).searchUsers[index].profileImage,
                                                  radius: 25.0
                                              ),
                                              SizedBox(width: 10.0,),
                                              Text(
                                                AppCubit.get(context).searchUsers[index].name,
                                                style: Theme.of(context).textTheme.bodyText2,
                                              ),
                                              if(AppCubit.get(context).searchUsers[index].uId == 'ff5Nc8LOWIPi6UZfxTDXlRc6lTs1')
                                                myVerification(),
                                              Spacer(),

                                            ],
                                          ),
                                        ),
                                      )
                                  ).toList(),
                                ),

                              if(PostCubit.get(context).searchPosts.isNotEmpty)
                                Text(
                                  'Posts',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              if(PostCubit.get(context).searchPosts.isNotEmpty)
                                Column(
                                  children: List.generate(PostCubit.get(context).searchPosts.length, (index) =>
                                      InkWell(
                                        onTap: ()
                                        {

                                        },
                                        child: buildPosts(
                                          model: PostCubit.get(context).searchPosts[index],
                                          context: context,
                                          commentController: commentController,
                                        ),
                                      )
                                  ).toList(),
                                ),


                            ]

                        );
                      },
                ),
              ),
            ),
          ),
        );
      });
  }
}
