import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app2/shared/bloc_observer.dart';
import 'package:news_app2/shared/components/constants.dart';
import 'package:news_app2/shared/cubit/app_cubit/cubit.dart';
import 'package:news_app2/shared/cubit/post_cubit/cubit.dart';
import 'package:news_app2/shared/cubit/theme_cubit/cubit.dart';
import 'package:news_app2/shared/cubit/theme_cubit/state.dart';
import 'package:news_app2/shared/network/local/cache_helper.dart';
import 'package:news_app2/shared/network/remote/dio_helper.dart';
import 'package:news_app2/shared/style/colors.dart';

import 'layout/home_layout.dart';
import 'modules/login/login_screen.dart';

void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // foreground fcm
  // FirebaseMessaging.onMessage.listen((event)
  // {
  //   print(event.data);
  //   showToast(text: event.data['message'], state: ToastStates.SUCCESS,);
  // });

  //when click on notification to open app


  DioHelper.init();
  await CacheHelper.init();

  Bloc.observer =MyBlocObserver();
  bool isDark = CacheHelper.getData(key: 'DarkMood') == null ? false : CacheHelper.getData(key: 'DarkMood');
  uId = CacheHelper.getData(key: 'uId') == null ? "" : CacheHelper.getData(key: 'uId');


  Widget screen;

  if(uId != "")
    {
      screen = HomeLayout();
    }
  else
    {
      screen = LoginScreen();
    }

  runApp(MyApp(screen,isDark));
}

class MyApp extends StatelessWidget {

  Widget screen;
  bool isDark;

  MyApp(this.screen,this.isDark);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:
      [
        BlocProvider<AppCubit>(
          create: (context) => AppCubit()..getUser()..getUsers()
        ),
        BlocProvider<PostCubit>(
          create: (context) => PostCubit()..getPosts(userModel: AppCubit.get(context).userModel)
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit()..changeAppTheme(fromCache: isDark),
        ),
      ],
      child: BlocConsumer<ThemeCubit,ThemeStates>(
        listener: (context,state) {},
        builder: (context,state)
        {
          return MaterialApp(
            title: 'NewsApp',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: appLightColor,
              appBarTheme: AppBarTheme(
                color: appLightColor,
                titleTextStyle: TextStyle(color: silverColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                    fontFamily: 'Roboto Condensed'
                ),
                elevation: 5.0,
                iconTheme: IconThemeData(color: Colors.grey),
                actionsIconTheme: IconThemeData(color: Colors.grey),
                centerTitle: false,
               // backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: appLightColor,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: appLightColor,
                  unselectedItemColor: silverColor,
                  selectedItemColor: mainColor,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  type: BottomNavigationBarType.fixed,
                  elevation: 25.0
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: mainColor,
                  elevation: 20.0
              ),
              cardTheme: CardTheme(
                color: appLightColor,
               // shadowColor: Colors.grey[300],
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
              ),
              textTheme: TextTheme(
                headline3: TextStyle(
                    fontSize: 50.0,
                    color: Colors.black,
                    fontFamily: 'Roboto Condensed'
                ),
                subtitle1: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontFamily: 'Poppins'
                ),
                subtitle2: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    fontFamily: 'Poppins'
                ),
                bodyText1: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'
                ),
                bodyText2: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'
                ),
                caption: TextStyle(
                    fontSize: 13.0,
                    color: Colors.black,
                    fontFamily: 'Raleway'
                ),
              ),
              scaffoldBackgroundColor: appLightColor,
            ),
            darkTheme: ThemeData(
              primaryColor: appDarkColor,
              appBarTheme: AppBarTheme(
                color: appDarkColor,
                titleTextStyle: TextStyle(color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Roboto Condensed'
                ),
                elevation: 5.0,
                //brightness: Brightness.light,
                iconTheme: IconThemeData(color: Colors.grey),
                actionsIconTheme: IconThemeData(color: Colors.grey),
                //backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: appDarkColor,
                  statusBarIconBrightness: Brightness.light,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: appDarkColor,
                  unselectedItemColor: Colors.grey,
                  selectedItemColor: Colors.blue,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  type: BottomNavigationBarType.fixed,
                  elevation: 25.0
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: mainColor,
                  elevation: 20.0
              ),
              cardTheme: CardTheme(
                color: appDarkColor,
                elevation: 18.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
              ),
              textTheme: TextTheme(
                headline3: TextStyle(
                    fontSize: 50.0,
                    color: appLightColor,
                    fontFamily: 'Roboto Condensed'
                ),
                subtitle1: TextStyle(
                    fontSize: 15.0,
                    color: appLightColor,
                    fontFamily: 'Poppins'
                ),
                subtitle2: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    fontFamily: 'Poppins'
                ),
                bodyText1: TextStyle(
                    fontSize: 20.0,
                    color: appLightColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'
                ),
                bodyText2: TextStyle(
                    fontSize: 16.0,
                    color: appLightColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'
                ),
                caption: TextStyle(
                    fontSize: 13.0,
                    color: appLightColor,
                    fontFamily: 'Raleway'
                ),
              ),
              scaffoldBackgroundColor: appDarkColor,
            ),
            themeMode: ThemeCubit.get(context).isDark ? ThemeMode.dark :ThemeMode.light,
            home: screen,
          );
        },
      ),

    );
  }
}
