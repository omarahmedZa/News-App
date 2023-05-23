import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/app_cubit/cubit.dart';
import '../../shared/cubit/app_cubit/states.dart';
import '../../shared/cubit/post_cubit/cubit.dart';
import '../../shared/style/colors.dart';

class EditProfileScreen extends StatelessWidget {

  var userNameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state) {},
      builder: (context,state)
      {
        var cubit = AppCubit.get(context);
        if(userNameController.text.isEmpty && bioController.text.isEmpty && phoneController.text.isEmpty)
        {
          userNameController.text = cubit.userModel.name;
          bioController.text = cubit.userModel.bio;
          phoneController.text = cubit.userModel.phone;
        }
        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Edit Profile'),
              actions:
              [
                TextButton(
                  child: Text(
                     'Confirm',
                     style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.blue,fontWeight: FontWeight.w600),
                  ),
                  onPressed: ()
                  {
                    if(formKey.currentState!.validate())
                    {
                      if(cubit.profileImageFile.path.isNotEmpty)
                      {
                        cubit.uploadProfileImage(
                          name: userNameController.text,
                          bio: bioController.text,
                          phone: phoneController.text,
                        );
                        if(state is GetUserSuccessState)
                        {
                          PostCubit.get(context).updateProfile(
                              userModel: cubit.userModel,
                              profileImage: cubit.updateProfile,
                              profileName: cubit.profileName
                          );
                          Navigator.of(context).pop();
                        }

                      }
                      else
                        {
                          cubit.updateUser(
                            name: userNameController.text,
                            bio: bioController.text,
                            phone: phoneController.text
                          );
                          if(state is GetUserSuccessState)
                          {
                            PostCubit.get(context).updateProfile(
                                userModel: cubit.userModel,
                                profileImage: cubit.updateProfile,
                                profileName: cubit.profileName
                            );

                            Navigator.of(context).pop();
                          }
                        }
                      }

                  }
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                    [
                      if(state is UserUpdateProfileLoadingState || state is UserUpdateLoadingState || state is GetUserLoadingState)
                        LinearProgressIndicator(color: mainColor,),
                      if(state is UserUpdateProfileLoadingState || state is UserUpdateLoadingState || state is GetUserLoadingState)
                        SizedBox(height: 10.0,),
                      SizedBox(height: 30.0),
                      if(cubit.profileImageFile.path.isEmpty)
                        buildNetworkProfileImage(imageUrl: cubit.userModel.profileImage,radius: 40.0),
                      if(cubit.profileImageFile.path.isNotEmpty)
                        CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.grey,
                          backgroundImage: FileImage(cubit.profileImageFile),
                        ),
                      TextButton(
                        child: Text(
                            'Change profile photo',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.blue,fontWeight: FontWeight.bold),
                        ),
                        onPressed: ()=> cubit.getProfileImage(),
                      ),
                      SizedBox(height: 15.0,),
                      defaultTextForm(
                        context: context,
                          controller: userNameController,
                          border: UnderlineInputBorder(),
                          label: 'UserName',
                        validator: (value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'UserName must not be empty !';
                          }
                          return null;
                        }
                      ),
                      defaultTextForm(
                          context: context,
                          controller: bioController,
                          border: UnderlineInputBorder(),
                          label: 'Bio'
                      ),
                      defaultTextForm(
                          context: context,
                          controller: phoneController,
                          border: UnderlineInputBorder(),
                          label: 'Phone Number',
                          validator: (value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'UserName must not be empty !';
                            }
                            return null;
                          }
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
