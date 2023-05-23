

import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/app_cubit/cubit.dart';
import '../../shared/cubit/post_cubit/cubit.dart';
import '../../shared/cubit/post_cubit/state.dart';
import '../../shared/style/colors.dart';

class HomeScreen extends StatelessWidget {

  var commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BuildCondition(
      condition: AppCubit.get(context).userModel != null,
      builder: (context) => BlocConsumer<PostCubit, PostStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = PostCubit.get(context);
          return RefreshIndicator(
            onRefresh: () async
            {
              PostCubit.get(context).getPosts(userModel: AppCubit.get(context).userModel);
              return ;
            },
            child: BuildCondition(
              condition: cubit.homePosts.isNotEmpty || cubit.homePosts.length == 0,
              builder: (context)
              {
                if(cubit.homePosts.length > 0)
                {
                  return ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder:(context,index) => Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: buildPosts(model:cubit.homePosts[index],context: context,commentController: commentController),
                    ),
                    separatorBuilder:(context,index) => SizedBox(height: 0,),
                    itemCount:cubit.homePosts.length,
                  );
                }
                return Center(child:
                  Text('No posts yet ! ...start following new friends..',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14,color: silverColor.withOpacity(0.8)),
                  ),
                );
              },
              fallback: (context) => myIndicator(),
            ),
          );
        },
      ),
      fallback: (context) => myIndicator(),
    );
  }
}
