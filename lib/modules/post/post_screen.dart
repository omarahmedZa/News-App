import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/app_cubit/cubit.dart';
import '../../shared/cubit/post_cubit/cubit.dart';
import '../../shared/cubit/post_cubit/state.dart';
import '../../shared/network/remote/dio_helper.dart';
import '../../shared/style/colors.dart';



class PostScreen extends StatelessWidget {

  var postController = TextEditingController();
  bool dir= false;
  String temp = '';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit,PostStates>(
      listener: (context,state) {},
      builder: (context,state)
      {
        var model = AppCubit.get(context).userModel;
        temp = "";
        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Create a Post'),
              actions:
              [
                TextButton(
                  child:Text(
                    'Post',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: mainColor,fontWeight: FontWeight.bold,fontSize: 16.5),
                  ),
                  onPressed: ()
                  {
                    if(PostCubit.get(context).imageFile.path.isNotEmpty)
                    {
                      PostCubit.get(context).uploadPostImage(
                        userModel: model,
                        text: postController.text,
                        time: DateTime.now().toIso8601String(),
                      );
                      if(state is !CreatePostLoadingState)
                      {
                        Navigator.of(context).pop();
                      }
                    }
                    else if(postController.text.isNotEmpty)
                      {
                        PostCubit.get(context).createPost(
                          userModel: model,
                          text: postController.text,
                          time: DateTime.now().toIso8601String(),
                        );
                        if(state is !CreatePostLoadingState)
                        {
                          Navigator.of(context).pop();
                        }
                      }

                  }
                ),
                defultIconButton(
                  context: context,
                  icon: FontAwesomeIcons.cloudSun,
                  function: ()
                    {
                      if(temp.isEmpty)
                        {

                          DioHelper.getData().then((value)
                          {
                            temp = "\n\nTemperature: ${value.data["current_weather"]["temperature"]}°C";
                            print(temp);
                            postController.text+=temp;
                          });
                          print(temp);

                        }
                      else
                        {
                          postController.text.replaceAll(RegExp(r"\n\nTemperature:"), '');
                        }
                    },
                  height: 30,
                  width: 40
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children:
                [
                  if(state is CreatePostLoadingState)
                    LinearProgressIndicator(color: mainColor,),
                  if(state is CreatePostLoadingState)
                    SizedBox(height: 10.0,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children:
                      [
                        buildNetworkProfileImage(imageUrl: model.profileImage,radius: 25),
                        SizedBox(width: 10.0,),
                        Text(model.name, style: Theme
                            .of(context)
                            .textTheme
                            .bodyText2,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: 307.0
                    ),
                    child: TextFormField(
                      controller: postController,
                      minLines: 1,
                      maxLines: 50,
                      cursorHeight: 20.0,
                      cursorColor: Colors.blueGrey,
                      textDirection: postController.text.contains(RegExp(r'[\u0600-\u06FF]')) ? TextDirection.rtl :TextDirection.ltr,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 17),
                      decoration: InputDecoration(
                        focusColor: Colors.grey,
                        border : InputBorder.none,
                        labelStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey),
                        hintText: 'Write a post ...',

                      ),
                      onChanged: (value)
                      {
                        if(value.length<2 || value.length >= 50)
                          PostCubit.get(context).typeArabic();
                      },
                    ),
                  ),
                  if(PostCubit.get(context).imageFile.path.isNotEmpty)
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children:[
                          Image.file(
                            PostCubit.get(context).imageFile,
                            //height: 300.0,
                            width: double.infinity,
                          ),
                        IconButton(onPressed: ()=> PostCubit.get(context).removeImage(), icon: Icon(Icons.close))
                      ]
                    ),
                ],
              ),
            ),
            bottomNavigationBar: defaultButton(context: context, text: 'Add Photo', function: PostCubit.get(context).getImage),
          ),
        );
      },
    );
  }
}
