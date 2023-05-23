import 'package:buildcondition/buildcondition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../layout/home_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/app_cubit/cubit.dart';
import '../../shared/cubit/login_cubit/cubit.dart';
import '../../shared/cubit/login_cubit/states.dart';
import '../../shared/cubit/post_cubit/cubit.dart';
import '../../shared/cubit/theme_cubit/cubit.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/style/colors.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatelessWidget {
  var emailController =TextEditingController();
  var passwordController =TextEditingController();
  var formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context)=>LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context,state)
        {
          if(state is LoginSuccessState)
          {
            if(AppCubit.get(context).logoutState)
            {
              AppCubit.get(context)..getUser()..getUsers();
              PostCubit.get(context).getPosts(userModel: AppCubit.get(context).userModel);
            }
            if(LoginCubit.get(context).rememberMe)
            {
              CacheHelper.saveData(key: 'uId', value: state.uId);
            }
            navigateAndDelTo(context, HomeLayout());
          }
          if(state is LoginErrorState)
          {
            showToast(text: state.message, state: ToastStates.ERROR);
          }
        },
        builder: (context,state) {
          return Scaffold(
            //backgroundColor: Colors.grey[100],
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 310.0,
                    width: double.infinity,
                    alignment: AlignmentDirectional.bottomStart,
                    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(MediaQuery.of(context).size.width, 30),
                      ),
                      gradient: LinearGradient(
                        // begin: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                        colors:
                        [
                          ThemeCubit.get(context).isDark ? appDarkColor : appLightColor,
                          ThemeCubit.get(context).isDark ? appLightColor.withOpacity(0.7) :appDarkColor.withOpacity(0.2),
                        ]
                      )
                    ),
                    child: Text(
                      'NewsApp',
                      style: GoogleFonts.lobster().copyWith(
                          fontSize: 50,
                          color: silverColor
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 30.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: 30,),
                          Text(
                            'Login',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 35.0)
                          ),
                          SizedBox(height: 5,),
                          Text('Login now to communicate with friends!',
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey,fontSize: 14.0),),
                          SizedBox(height: 30,),
                          buildTextForm(
                            context: context,
                              controller: emailController,
                              keyType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
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
                              controller: passwordController,
                              keyType: TextInputType.visiblePassword,
                              label: 'Password',
                              radius: 20,
                              isPassword: LoginCubit.get(context).isPassword,
                              prefix: Icons.lock_outline,
                              suffix: LoginCubit.get(context).isPassword ? Icons.visibility : Icons.visibility_off,
                              onSuffix: LoginCubit.get(context).changeIsPassword,
                              validator: (String? value)
                              {
                                if(value!.isEmpty)
                                  return 'Password must not be empty!';

                                return null;
                              }
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Checkbox(
                                value: LoginCubit.get(context).rememberMe,
                                onChanged: (value) => LoginCubit.get(context).changeRememberMe(value),
                                side: BorderSide(
                                  color: ThemeCubit.get(context).isDark ? appLightColor : appDarkColor,
                                  width: 1.5
                                ),
                              ),
                              Text(
                                'Remember me ?',
                              ),
                            ],
                          ),
                          BuildCondition(
                            condition: state is !LoginLoadingState,
                            builder: (context) =>defaultButton(
                              context: context,
                                text: 'Login',
                                radius: 20,
                                function: ()
                                {
                                  if(formKey.currentState!.validate())
                                  {
                                    LoginCubit.get(context).login(
                                        email: emailController.text,
                                        password: passwordController.text
                                    );
                                  }
                                }
                            ),
                            fallback: (context) => myIndicator(),
                          ),
                          SizedBox(height: 10,),
                          BuildCondition(
                            condition: state is !GoogleLoginLoadingState,
                            builder: (context) => defultIconButton(
                                context: context,
                                icon: FontAwesomeIcons.google,
                                radius: 20,
                                function: ()
                                {
                                  LoginCubit.get(context).googleLogin();
                                }
                            ),
                            fallback: (context) => myIndicator(),
                          ),
                          SizedBox(height: 10,),
                          BuildCondition(
                            condition: state is !FacebookLoginLoadingState,
                            builder: (context) => defultIconButton(
                                context: context,
                                icon: FontAwesomeIcons.facebook,
                                radius: 20,
                                function: ()
                                {
                                  LoginCubit.get(context).facebookLogin();
                                }
                            ),
                            fallback: (context) => myIndicator(),
                          ),
                          Center(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Don\'t have an account ?',
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14.0)
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Register Now',
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: mainColor,fontSize: 14)
                                      ),
                                      onPressed: () => navigateAndDelTo(context, RegisterScreen()),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  child: Text(
                                      'Forget password ?',
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: mainColor,fontSize: 14)
                                  ),
                                  onPressed: ()
                                  {
                                    if(emailController.text.isNotEmpty)
                                      FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text)
                                          .then((value)
                                      {
                                        showToast(text: 'Please check your email', state: ToastStates.SUCCESS);
                                      })
                                          .catchError((error)
                                      {
                                        print(error.toString());
                                        showToast(text: 'Incorrect email address', state: ToastStates.ERROR);
                                      });
                                  },
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
          );
        },
      ),
    );
  }
}
