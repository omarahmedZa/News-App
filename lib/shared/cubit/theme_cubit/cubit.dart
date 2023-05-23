import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app2/shared/cubit/theme_cubit/state.dart';
import '../../network/local/cache_helper.dart';




class ThemeCubit extends Cubit<ThemeStates>
{
  ThemeCubit() : super(ThemeInitialState());

  static ThemeCubit get(context) => BlocProvider.of(context);

  bool isDark = true;
  void changeAppTheme ({bool? fromCache})
  {
    if(fromCache != null)
    {
      isDark= fromCache;
    }
    else
    {
      isDark = !isDark;
    }
    CacheHelper.saveData(key: 'DarkMood', value: isDark).then((value)
    {
      emit(ChangeThemeState());
    });
  }

}



