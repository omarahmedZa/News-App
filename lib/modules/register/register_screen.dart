import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../layout/home_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/app_cubit/cubit.dart';
import '../../shared/cubit/register_cubit/cubit.dart';
import '../../shared/cubit/register_cubit/states.dart';
import '../../shared/cubit/theme_cubit/cubit.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/style/colors.dart';
import '../login/login_screen.dart';

class RegisterScreen extends StatelessWidget {

  var emailController =TextEditingController();
  var nameController =TextEditingController();
  var phoneController =TextEditingController();
  var passwordController =TextEditingController();
  var formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (context)=>RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(
        listener: (context,state)
        {
          if(state is UserCreateSuccessState)
          {
            if(AppCubit.get(context).logoutState)
            {
              AppCubit.get(context).getUser();
            }
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value)
            {
              navigateAndDelTo(context, HomeLayout());
            }).catchError((error){});
          }
          if(state is RegisterErrorState)
          {
            showToast(text: state.message, state: ToastStates.ERROR);
          }
        },
        builder: (context,state) {
          return Scaffold(
            //backgroundColor: Colors.grey[100],
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 100.0,
                      width: double.infinity,
                      alignment: AlignmentDirectional.center,
                      padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            //bottom: Radius.elliptical(MediaQuery.of(context).size.width, 30),
                          ),
                          // gradient: LinearGradient(
                          //     colors:
                          //     [
                          //       ThemeCubit.get(context).isDark ? appDarkColor : appLightColor,
                          //       ThemeCubit.get(context).isDark ? appLightColor.withOpacity(0.7) :appDarkColor.withOpacity(0.2),
                          //     ]
                          // )
                      ),
                      child: Text(
                        'Friends',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                        // style: GoogleFonts.lobster().copyWith(
                        //     fontSize: 50,
                        //     color: silverColor
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 30.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 30,),
                            Text(
                              'Register',
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 35.0)
                            ),
                            SizedBox(height: 5,),
                            Text('Register now to communicate with friends!',
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey,fontSize: 14.0)),
                            SizedBox(height: 30,),
                            buildTextForm(
                                context: context,
                                controller: nameController,
                                keyType: TextInputType.text,
                                label: 'Name',
                                radius: 20,
                                prefix: Icons.person,
                                validator: (String? value)
                                {
                                  if(value!.isEmpty)
                                    return 'Name must not be empty!';

                                  return null;
                                }
                            ),
                            SizedBox(height: 15,),
                            buildTextForm(
                                context: context,
                                controller: emailController,
                                keyType: TextInputType.emailAddress,
                                label: 'E-mail',
                                radius: 20,
                                prefix: Icons.alternate_email_outlined,
                                validator: (String? value)
                                {
                                  if(value!.isEmpty)
                                    return 'E-mail must not be empty!';

                                  return null;
                                }
                            ),
                            SizedBox(height: 15,),
                            buildTextForm(
                                context: context,
                                controller: phoneController,
                                keyType: TextInputType.phone,
                                label: 'Phone Number',
                                radius: 20,
                                prefix: Icons.phone_android,
                                validator: (String? value)
                                {
                                  if(value!.isEmpty)
                                    return 'Phone number must not be empty!';

                                  return null;
                                }
                            ),
                            SizedBox(height: 15,),
                            buildTextForm(
                                context: context,
                                controller: passwordController,
                                keyType: TextInputType.visiblePassword,
                                label: 'Password',
                                radius: 20,
                                isPassword: RegisterCubit.get(context).isPassword,
                                prefix: Icons.lock_outline,
                                suffix: RegisterCubit.get(context).isPassword ? Icons.visibility : Icons.visibility_off,
                                onSuffix: RegisterCubit.get(context).changeIsPassword,
                                validator: (String? value)
                                {
                                  if(value!.isEmpty)
                                    return 'Password must not be empty!';

                                  return null;
                                }
                            ),
                            SizedBox(height: 15,),
                            buildTextForm(
                                context: context,
                                controller: new TextEditingController(),
                                keyType: TextInputType.visiblePassword,
                                label: 'Confirm Password',
                                radius: 20,
                                isPassword: RegisterCubit.get(context).isPassword2,
                                prefix: Icons.lock_outline,
                                suffix: RegisterCubit.get(context).isPassword2 ? Icons.visibility : Icons.visibility_off,
                                onSuffix: RegisterCubit.get(context).changeIsPassword2,
                                validator: (String? value)
                                {
                                  if(value!.isEmpty || value != passwordController.text)
                                    return 'Password dosen\'t match !';

                                  return null;
                                }
                            ),
                            SizedBox(height: 20,),
                            BuildCondition(
                              condition: state is !RegisterLoadingState,
                              builder: (context) =>defaultButton(
                                context: context,
                                  text: 'Register',
                                  radius: 20,
                                  function: ()
                                  {
                                    if(formKey.currentState!.validate())
                                    {
                                      RegisterCubit.get(context).register(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text
                                      );
                                    }
                                  }
                              ),
                              fallback: (context) => myIndicator(),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Have an account ?',
                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14)
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Login Now',
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14,color: Colors.blueAccent)
                                    ),
                                    onPressed: () => navigateAndDelTo(context, LoginScreen()),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
