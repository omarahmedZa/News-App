import 'package:buildcondition/buildcondition.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modules/post/post_screen.dart';
import '../modules/search/search_screen.dart';
import '../shared/components/components.dart';
import '../shared/cubit/app_cubit/cubit.dart';
import '../shared/cubit/app_cubit/states.dart';
import '../shared/network/remote/dio_helper.dart';
import '../shared/style/colors.dart';

class HomeLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {
        if(AppCubit.get(context).logoutState && state is GetUserSuccessState)
        {

        }
      },
      builder: (context,state)
      {
        var cubit = AppCubit.get(context);
        cubit.isUserScreen = false;
        DioHelper.getData().then((value) => print(value.data["current_weather"]["temperature"]));
        return SafeArea(
          top: false,
          child: BuildCondition(
            condition: state is! AppInitialState && state is! GetUserLoadingState && state is! GetUsersLoadingState && state is! GetUsersSuccessState,
            builder: (context) => WillPopScope(
              onWillPop: ()async
              {
                if(cubit.currentIndex == 0)
                {
                  if(!cubit.isComment)
                    SystemNavigator.pop();
                  else
                    Navigator.of(context).pop();
                }
                else
                  {
                    cubit.changeBottomNav(0, context);
                  }
                return true;
              },
              child: Scaffold(
                appBar: !cubit.isComment ? AppBar(
                  title: Text('NewsApp'),
                  titleTextStyle: GoogleFonts.lobster().copyWith(
                      fontSize: 30,
                      color: silverColor
                  ),
                  actions:
                  [
                    if(cubit.currentIndex == 0 || cubit.currentIndex == 1)
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: ()
                        {
                          navigateTo(context, SearchScreen());
                        },
                      ),
                    if((cubit.currentIndex == 0 && cubit.userModel.isAdmin) || (cubit.currentIndex == 3 && cubit.userModel.isAdmin))
                      IconButton(
                        icon: Icon(Icons.add_box_outlined),
                        onPressed: ()
                        {
                          navigateTo(context, PostScreen());
                        },
                      ),
                  ],
                ) : null,
                body: cubit.screen[cubit.currentIndex],
                bottomNavigationBar: !cubit.isComment ? BottomNavigationBar(
                  onTap: (index) => cubit.changeBottomNav(index,context),
                  currentIndex: cubit.currentIndex,
                  items:
                  [
                    BottomNavigationBarItem(icon: Icon(Icons.home ,size: 28.0,),label: 'Home'),
                    //BottomNavigationBarItem(icon: Icon(Icons.search ,size: 28.0,),label: 'Search'),
                    BottomNavigationBarItem(icon: buildNetworkProfileImage(
                         imageUrl: cubit.userModel.profileImage,
                         radius: 13
                     ),label: 'Profile'),
                    BottomNavigationBarItem(icon: Icon(Icons.settings,size: 25.0),label: 'Settings'),
                  ],
                ): null,
              ),
            ),
            fallback: (context) => Scaffold(
              body: myIndicator(),
            ),
          ),
        );
      },
    );
  }
}
