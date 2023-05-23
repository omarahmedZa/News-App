import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioHelper
{

  //https://api.open-meteo.com/v1/forecast?latitude=30.06&longitude=31.25&current_weather=true&forecast_days=1&timezone=Africa%2FCairo
  static Dio dio = Dio();

  static init() => dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.open-meteo.com/',
      receiveDataWhenStatusError: true,
    ),
  );

  static Future getData() async
  {
    return await dio.get(
        'v1/forecast',
        queryParameters:
        {
          'latitude':30.06,
          'longitude':31.25,
          'current_weather':true,
        },
    );
  }


}
