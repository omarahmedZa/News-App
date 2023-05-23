
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/posts/post_model.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/app_cubit/cubit.dart';
import '../../shared/cubit/post_cubit/cubit.dart';
import '../../shared/cubit/post_cubit/state.dart';
import '../../shared/style/colors.dart';

class EditPostScreen extends StatelessWidget {

  final PostModel model;

  var editPostController = TextEditingController();

  EditPostScreen(this.model);
  @override
  Widget build(BuildContext context) {
    if(editPostController.text.isEmpty)
    {
      editPostController.text = model.title;
      PostCubit.get(context).editImage = model.image;
    }
    return BlocConsumer<PostCubit,PostStates>(
      listener: (context,state) {},
      builder: (context,state)
      {

        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Edit Post'),
              actions:
              [
                TextButton(
                    child:Text(
                      'Save',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: mainColor,fontWeight: FontWeight.bold,fontSize: 16.5),
                    ),
                    onPressed: ()
                    {
                      if(PostCubit.get(context).imageFile.path.isNotEmpty)
                      {
                        PostCubit.get(context).uploadPostEditImage(
                            userModel: AppCubit.get(context).userModel,
                            post: model,
                            text: editPostController.text
                        );
                        Navigator.of(context).pop();
                      }
                      else if(editPostController.text.isNotEmpty && (PostCubit.get(context).editImage.isNotEmpty||PostCubit.get(context).editImage.isEmpty))
                        {
                          PostCubit.get(context).updatePosts(
                              userModel: AppCubit.get(context).userModel,
                              post: model,
                              text: editPostController.text,
                              image: PostCubit.get(context).editImage
                          );
                          Navigator.of(context).pop();
                        }

                    }
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children:
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children:
                      [

                        buildNetworkProfileImage(imageUrl: model.userImage,radius: 25),
                        SizedBox(width: 10.0,),
                        Text(model.userName, style: Theme.of(context).textTheme.bodyText2,),
                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: 307.0
                    ),
                    child: TextFormField(
                      controller: editPostController,
                      minLines: 1,
                      maxLines: 50,
                      cursorHeight: 20.0,
                      textDirection: editPostController.text.contains(RegExp(r'[\u0600-\u06FF]')) ? TextDirection.rtl :TextDirection.ltr,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 17),
                      decoration: InputDecoration(
                          hintText: 'Write a post ...',
                          border: InputBorder.none
                      ),
                      onChanged: (value)
                      {
                        if(value.length<=2)
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
                  if(PostCubit.get(context).editImage!= '')
                    Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children:[
                          buildNetworkImage(imageUrl: PostCubit.get(context).editImage),
                          IconButton(onPressed: ()=>PostCubit.get(context).removeImageEdit(), icon: Icon(Icons.close))
                        ]
                    ),
                ],
              ),
            ),
            bottomNavigationBar: defaultButton(context: context, text: 'Add Photo', function: PostCubit.get(context).editImage.isEmpty? PostCubit.get(context).getImage:null),
          ),
        );
      },
    );
  }
}
