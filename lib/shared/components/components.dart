import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/posts/post_model.dart';
import '../../models/users/users_model.dart';
import '../../modules/post/edit_post_screen.dart';
import '../../modules/post/likes_screen.dart';
import '../../modules/post/reply_screen.dart';
import '../../modules/profile/user_profile_screen.dart';
import '../cubit/app_cubit/cubit.dart';
import '../cubit/post_cubit/cubit.dart';
import '../cubit/post_cubit/state.dart';
import '../cubit/theme_cubit/cubit.dart';
import '../style/colors.dart';
import 'constants.dart';



void navigateTo(context,widget) => Navigator.push(context, MaterialPageRoute(builder: (context)=> widget));

void navigateAndDelTo(context,widget) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> widget));

Widget myDivider(context)=> Divider(height: 1.5, thickness: 1.5,color: ThemeCubit.get(context).isDark ? Colors.grey[700]: Colors.grey[300],);

Widget myIndicator() => Center(child: CircularProgressIndicator(color: mainColor,));

Widget myVerification() => Icon(FontAwesomeIcons.solidCircleCheck,size: 16.0,color: silverColor.withOpacity(0.7),);

Widget buildTextForm({
required TextEditingController controller,
  required TextInputType keyType,
  required String label,
  required IconData prefix,
  required BuildContext context,
  IconData? suffix,
  bool isPassword=false,
  TextInputAction? textInputAction,
  Function(String)? onChange,
  Function()? onTap,
  Function()? onEditingComplete,
  Function(String)? onFieldSubmitted,
  Function(String)? onSaved,
  Function()? onSuffix,
  String? Function(String?)? validator,
  double radius = 4,
  Color? borderColor,
}) => TextFormField(
  controller: controller,
  keyboardType: keyType,
  textInputAction: textInputAction,
  obscureText: isPassword,
  onChanged: onChange,
  onTap: onTap,
onEditingComplete: onEditingComplete,
validator: validator,
cursorHeight: 23.0,
cursorColor: silverColor,
onFieldSubmitted:onFieldSubmitted,
style: Theme.of(context).textTheme.bodyText2,
decoration: InputDecoration(
  //filled: false,
  //fillColor: ThemeCubit.get(context).isDark ? Color.fromRGBO(237, 237, 232,1) : Color.fromRGBO(39, 38, 37, 1),
prefixIcon: Icon(prefix,color: ThemeCubit.get(context).isDark ? appLightColor : appDarkColor,),
labelText: label,
labelStyle: Theme.of(context).textTheme.bodyText2,
suffixIcon: suffix == null ? null : IconButton(icon:Icon(suffix,color: ThemeCubit.get(context).isDark ? appLightColor : appDarkColor,),
  onPressed: onSuffix,),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
          color: borderColor ?? mainColor,
          width: 1.5
      ),
  ),
  focusColor: Colors.white,
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
          color: silverColor,
          width: 1.5
      ),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(
      color: borderColor ?? mainColor,
      width: 1.5
    ),
  ),
),
);

Widget defaultTextForm({
  required BuildContext context,
  required TextEditingController controller,
  String? Function(String?)? validator,
  String hint = '',
  String label = '',
  int maxLines = 5,
  double maxWidth = 307.0,
  InputBorder border = InputBorder.none
}) => Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth
        ),
        child: TextFormField(
          controller: controller,
          minLines: 1,
          maxLines: maxLines,
          cursorHeight: 20.0,
          cursorColor: Colors.blueGrey,
          validator: validator,
          textDirection: controller.text.contains(RegExp(r'[\u0600-\u06FF]')) ? TextDirection.rtl :TextDirection.ltr,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 17),
          decoration: InputDecoration(
            focusColor: Colors.grey,
            focusedBorder: border,
            labelStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey),
            labelText: label,
            hintText: hint,
            border: border
            ),
          onChanged: (value)
            {
              if(value.length<2 || value.length >= 50)
              AppCubit.get(context).typeArabic();
            },
        ),
      );

Widget defaultButton ({
  required BuildContext context,
  required String text,
  required Function()? function,
  Color? color,
  Color? fontColor,
  Color? borderColor,
  bool isUpperCase = true,
  double height = 50,
  double width = 300,
  double borderWidth = 0.3,
  double radius = 3,
}) => MaterialButton(
  child: Text(isUpperCase ? text.toUpperCase() : text,style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 17.0,color:fontColor ?? Colors.white),),

  onPressed: function,
  height: height,
  minWidth: width,
  color: color ?? mainColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
    side: BorderSide(
      width: borderWidth,
      color: borderColor ?? Colors.black
    ),
  ),
);

Widget defultIconButton ({
  required BuildContext context,
  required IconData icon,
  required Function()? function,
  Color? color,
  Color? iconColor,
  Color? borderColor,
  bool isUpperCase = true,
  double height = 50,
  double width = 300,
  double borderWidth = 0.3,
  double radius = 3,
}) => MaterialButton(
  child: Icon(icon, size: 25,color: appLightColor,),
  onPressed: function,
  height: height,
  minWidth: width,
  color: color ?? mainColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
    side: BorderSide(
      width: borderWidth,
      color: borderColor ?? Colors.black
    ),
  ),
);


void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 7,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    ).then((value) {});

void showDefaultDialog(
{
  required BuildContext context,
  required String title,
  required String buttonText,
  required Widget widget,
  Function()? function,
  bool barrierDismissible = false,
}) => showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context)
    {
      return AlertDialog(
        backgroundColor: ThemeCubit.get(context).isDark ? appDarkColor : appLightColor,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 15.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        content: widget,
        actions:
        [
          Center(
            child: defaultButton(
              context: context,
              text: buttonText,
              function: function ?? () => Navigator.of(context).pop(),
              width: 100.0
            ),
          )
        ],
      );
    }
).then((value) {});

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Color.fromRGBO(212, 52, 23, 1);
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

Widget buildNetworkImage({
  required String imageUrl,
  double height = 350.0,
  double width = double.infinity,
  double radius = 0,
  BoxFit? fit
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: (context, image) =>
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
              image: DecorationImage(
                image: image,
                fit: fit
              )
          ),
        ),
    placeholder: (context, _) =>
        Container(
          height: height,
          width: width,
          child: Center(child: CircularProgressIndicator(color: mainColor,))
        ),
    errorWidget: (context, text, _) =>
        Container(
            height: height,
            width: width,
            child: Icon(Icons.error, size: 35,)
        ),
  );
}

Widget buildNetworkProfileImage({
  required String imageUrl,
  double radius = 20.0
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: (context, image) =>
        CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey,
          backgroundImage: image,
        ),
    placeholder: (context, _) => Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
            shape: BoxShape.circle
        ),
        child: Center(
            child: CircularProgressIndicator(color: mainColor,strokeWidth: 2,)),
    ),
    errorWidget: (context, text, _) =>
        Container(
            height: radius,
            width: radius,
            decoration: BoxDecoration(
              shape: BoxShape.circle
            ),
            child: Icon(Icons.error, size: 35,)
        ),
  );
}

Widget buildPosts({
  required PostModel model,
  required BuildContext context,
  required TextEditingController commentController,
}) {
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children:
      [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: model.title.contains(RegExp(r'[\u0600-\u06FF]')) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children:
            [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  InkWell(
                    onTap: ()
                    {
                      if(AppCubit.get(context).isUserScreen == false)
                      {
                        AppCubit.get(context).openUserScreen();
                        PostCubit.get(context).getUserPosts(userModel:AppCubit.get(context).users.firstWhere((element) => model.uId == element.uId));
                        navigateTo(context, UserProfileScreen(AppCubit.get(context).users.firstWhere((element) => model.uId == element.uId)));
                      }
                    },
                    child: buildNetworkProfileImage(imageUrl: model.userImage,radius: 25)
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.0,),
                      InkWell(
                        onTap: ()
                        {
                          if(AppCubit.get(context).isUserScreen == false)
                          {
                            AppCubit.get(context).openUserScreen();
                            PostCubit.get(context).getUserPosts(userModel:AppCubit.get(context).users.firstWhere((element) => model.uId == element.uId));
                            navigateTo(context, UserProfileScreen(AppCubit.get(context).users.firstWhere((element) => model.uId == element.uId)));
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              model.userName,
                              textDirection: model.userName.contains(RegExp(r'[\u0600-\u06FF]')) ? TextDirection.rtl :TextDirection.ltr,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            if(model.uId == '4YacAzFrPRWreDYFtvrPTQSlcFf2')
                             myVerification(),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.0,),
                      Text(model.time, style: Theme
                          .of(context)
                          .textTheme
                          .caption,),
                    ],
                  ),
                  Spacer(),
                  IconButton(onPressed: ()
                  {
                    showModalBottomSheet(
                        backgroundColor: ThemeCubit.get(context).isDark ? appDarkColor : appLightColor,
                        context: context,
                        builder: (context)
                    {
                      return Container(
                        constraints: BoxConstraints(
                          maxHeight: 130
                        ),
                        width: double.infinity,
                        child: Column(
                          children:
                          [
                            if(uId == model.uId)
                              ListTile(
                                leading: Icon(Icons.edit,size: 25.0,
                                  color: ThemeCubit.get(context).isDark ? appLightColor : appDarkColor ,),
                                title: Text(
                                  'Edit post',
                                  style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 17.0),
                                ),
                                onTap: ()
                                {
                                  navigateAndDelTo(context,EditPostScreen(model));
                                },
                              ),
                            if(uId == model.uId)
                              ListTile(
                                leading: Icon(Icons.delete,size: 25.0,
                                  color: ThemeCubit.get(context).isDark ? appLightColor : appDarkColor ,),
                                title: Text(
                                  'Delete post',
                                  style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 17.0),
                                ),
                                onTap: ()
                                {
                                  PostCubit.get(context).deletePost(post: model);
                                  Navigator.of(context).pop();
                                },
                              ),
                            if(uId != model.uId)
                              ListTile(
                                leading: Icon(FontAwesomeIcons.bookmark,size: 25.0,
                                  color: ThemeCubit.get(context).isDark ? appLightColor : appDarkColor ,),
                                title: Text(
                                  model.isSaved ? 'UnSave post' : 'Save post' ,
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 17.0),
                                ),
                                onTap: (){
                                  if(model.isSaved) {
                                    PostCubit.get(context)..unSavePost(post:model)..getPosts(userModel: AppCubit.get(context).userModel);

                                  }
                                  else {
                                    PostCubit.get(context)
                                      ..savePost(post: model)
                                      ..getPosts(userModel: AppCubit
                                          .get(context)
                                          .userModel);
                                  }

                                },
                              ),
                          ],
                        ),
                      );
                    });
                  },
                      icon: Icon(FontAwesomeIcons.grip,size: 20,color: ThemeCubit.get(context).isDark ? Colors.grey[300] : Colors.black,)),
                ],
              ),
              if(model.title.isNotEmpty)
               SizedBox(height: 15.0,),
              Text(
                model.title,
                textAlign: model.title.contains(RegExp(r'[\u0600-\u06FF]')) ? TextAlign.right :TextAlign.left,
                textDirection: model.title.contains(RegExp(r'[\u0600-\u06FF]')) ? TextDirection.rtl :TextDirection.ltr,
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle1!.copyWith(fontSize: 17),
              ),
            ],
          ),
        ),
        //SizedBox(height: 5.0,),
        if(model.image.isNotEmpty)
          InteractiveViewer(
              child: buildNetworkImage(imageUrl: model.image)
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:
            [
              Row(
                children:
                [
                  Expanded(child: Row(
                    children: [
                      InkWell(
                        onTap: ()
                        {
                          navigateTo(context, LikesScreen(model.likes));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.favorite,color: Colors.red,),
                            SizedBox(width: 4.0,),
                            Text('${model.likes==null ?0:model.likes.length}', style: Theme
                                .of(context)
                                .textTheme
                                .caption,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: ()
                        {
                          AppCubit.get(context).isCommenting();
                          showComments(context: context, model: model, commentController: commentController);
                        },
                        child: Text('${model.comments==null ?0:model.comments.length} Comments', style: Theme
                            .of(context)
                            .textTheme
                            .caption,),
                      )
                    ],
                  )),
                ],
              ),
              SizedBox(height: 5.0,),
              myDivider(context),
              SizedBox(height: 7.0,),
              Row(
                children:
                [
                  Expanded(child: InkWell(
                    onTap: ()
                    {
                      if(model.isLike)
                      {
                        PostCubit.get(context).disLikePost(model: model);
                      }
                      else
                      {
                        PostCubit.get(context).likePost(model: model,time: DateTime.now().toIso8601String());
                      }
                    },
                    child: Container(
                      height: 35.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(model.isLike == true ? Icons.favorite : Icons.favorite_border_outlined ,color: Colors.red,),
                          SizedBox(width: 4.0,),
                          Text('Like', style: Theme.of(context).textTheme.subtitle1,)
                        ],
                      ),
                    ),
                  )),
                  Expanded(child: InkWell(
                    onTap: ()
                    {
                      AppCubit.get(context).isCommenting();
                      showComments(context: context, model: model, commentController: commentController);
                    },
                    child: Container(
                      height: 35.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.comment,size: 23,color: ThemeCubit.get(context).isDark ? Colors.grey[300] : Colors.black,),
                          SizedBox(width: 4.0,),
                          Text('Comment', style: Theme
                              .of(context)
                              .textTheme
                              .subtitle1,)
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ],
          ),
        )
        //SizedBox(height: 5.0,),
      ],
    ),
  );
}

void showComments ({
  required BuildContext context,
  required PostModel model,
  required TextEditingController commentController
}) => showBottomSheet(
  backgroundColor: ThemeCubit.get(context).isDark ? appDarkColor : appLightColor,
  context: context,
  builder: (context) => BlocConsumer<PostCubit,PostStates>(
    listener: (context,state) {},
    builder: (context,state) => Padding(
      padding: const EdgeInsets.fromLTRB(0,33.0,0,5.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children:
            [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children:
                [
                  IconButton(
                      onPressed: ()
                      {
                        AppCubit.get(context).closeCommenting();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back,color: ThemeCubit.get(context).isDark ? Colors.grey[300] : Colors.black,)
                  ),
                  SizedBox(width: 10.0,),
                  Center(child: Text('Comments',style: Theme.of(context).textTheme.bodyText2,))
                ],
              ),
              myDivider(context),
              SizedBox(height: 5.0,),
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context,index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                    [
                      InkWell(
                        onTap: ()
                        {
                          if(AppCubit.get(context).isUserScreen == false)
                          {
                            AppCubit.get(context).openUserScreen();
                            PostCubit.get(context).getUserPosts(userModel:AppCubit.get(context).users.firstWhere((element) => model.comments[index].uId == element.uId));
                            navigateTo(context, UserProfileScreen(AppCubit.get(context).users.firstWhere((element) => model.comments[index].uId == element.uId)));
                          }
                        },
                        child: buildNetworkProfileImage(imageUrl: model.comments[index].userImage),
                      ),
                      SizedBox(width: 5.0,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              child: Container(
                              padding: EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 7.0),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              constraints: BoxConstraints(
                                  minHeight: 40.0,
                                  maxWidth: 290.0
                              ),
                              decoration: BoxDecoration(
                                  color: ThemeCubit.get(context).isDark ? Colors.grey[800] : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children:
                                [
                                  SizedBox(height: 2,),
                                  InkWell(
                                    onTap: ()
                                    {
                                      if(AppCubit.get(context).isUserScreen == false)
                                      {
                                        AppCubit.get(context).openUserScreen();
                                        PostCubit.get(context).getUserPosts(userModel:AppCubit.get(context).users.firstWhere((element) => model.uId == element.uId));
                                        navigateTo(context, UserProfileScreen(AppCubit.get(context).users.firstWhere((element) => model.uId == element.uId)));
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          model.comments[index].userName,
                                          textAlign: TextAlign.left,
                                          textDirection: model.comments[index].userName.contains(RegExp(r'[\u0600-\u06FF]')) ? TextDirection.rtl :TextDirection.ltr,
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        if(model.comments[index].uId == '4YacAzFrPRWreDYFtvrPTQSlcFf2')
                                          myVerification(),
                                      ],
                                    ),
                                  ),
                                  if(model.comments[index].text.isNotEmpty)
                                  Text(
                                    model.comments[index].text,
                                    textAlign: model.comments[index].text.contains(RegExp(r'[\u0600-\u06FF]')) ?TextAlign.right : TextAlign.left,
                                    textDirection: model.comments[index].text.contains(RegExp(r'[\u0600-\u06FF]')) ? TextDirection.rtl :TextDirection.ltr,
                                    style: Theme.of(context).textTheme.subtitle1,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if(model.comments[index].image.isNotEmpty)
                            InkWell(
                              child: buildNetworkImage(
                                  imageUrl: model.comments[index].image,
                                  height: 180.0,
                                  width: 230.0,
                                  radius: 15.0,
                                  fit: BoxFit.fill
                              ),
                            ),
                          SizedBox(height: 3.5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                            [
                              SizedBox(width: 5.0,),
                              Text(
                                model.comments[index].time,
                                style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 13.0),
                              ),
                              SizedBox(width: 15,),
                              if(model.comments[index].likes.isNotEmpty)
                                InkWell(
                                  onTap: ()
                                  {
                                    navigateTo(context, LikesScreen(model.comments[index].likes));
                                  },
                                  child: Row(
                                    children: [
                                      Text('${model.comments[index].likes.length}', style: Theme
                                          .of(context)
                                          .textTheme
                                          .caption!.copyWith(
                                          fontSize: 13.0,),
                                      ),
                                      Icon(model.comments[index].isLike == true ?
                                      Icons.favorite :
                                      Icons.favorite_border_outlined ,
                                        color: Colors.red,
                                        size: 17.0,
                                      ),
                                    ],
                                  ),
                                ),

                              InkWell(
                                onTap: ()
                                {
                                  if(model.comments[index].isLike)
                                  {
                                    PostCubit.get(context).disLikeComment(postId: model.postId, comment: model.comments[index]);
                                  }
                                  else
                                    {
                                      PostCubit.get(context).likeComment(postId: model.postId,time: DateTime.now().toIso8601String(), comment: model.comments[index]);
                                    }
                                },
                                child: Container(
                                  height: 23.0,
                                  child: Row(
                                    children: [
                                      if(model.comments[index].likes.isNotEmpty)
                                        SizedBox(width: 4.0,),
                                      Text(model.comments[index].isLike ? 'Liked':'Like', style: Theme
                                          .of(context)
                                          .textTheme
                                          .caption!.copyWith(
                                          fontSize: 13.0,
                                          color: model.comments[index].isLike ?Colors.red:(ThemeCubit.get(context).isDark ? appLightColor : appDarkColor)),),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 15.0,),
                              InkWell(
                                onTap: ()
                                {
                                  //print(model.comments[index].commentId);
                                  navigateTo(context, ReplyScreen(model.comments[index], model));
                                },
                                child: Container(
                                  height: 20.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Reply', style: Theme
                                          .of(context)
                                          .textTheme
                                          .caption!.copyWith(fontSize: 13.0),)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if(model.comments[index].replies.isNotEmpty)
                            TextButton(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15.0,0,0,0),
                                child: Text(
                                  'View ${model.comments[index].replies.length} replies ...',
                                  style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              onPressed: ()=>navigateTo(context,ReplyScreen(model.comments[index], model)),
                            ),
                        ],
                      ),
                    ],
                  ),
                  separatorBuilder: (context,index) => SizedBox(height: 15.0,),
                  itemCount: model.comments.length,
                ),
              ),
              myDivider(context),
              SizedBox(height: 5.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children:
                    [
                      buildNetworkProfileImage(imageUrl: AppCubit.get(context).userModel.profileImage),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: TextFormField(
                          controller: commentController,
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                          minLines: 1,
                          style: Theme.of(context).textTheme.subtitle1,
                          textDirection: commentController.text.contains(RegExp(r'[\u0600-\u06FF]')) ? TextDirection.rtl :TextDirection.ltr,
                          onChanged: (value)
                          {
                            if(value.length<=2)
                              PostCubit.get(context).typeArabic();
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.grey,
                              filled: false,
                              hintText: 'Write a comment ...',
                              suffixIcon: (commentController.text.isNotEmpty||PostCubit.get(context).imageFile !=null)?
                              IconButton(
                                icon: Icon(Icons.send,color: Colors.blue,size: 23,),
                                onPressed: ()
                                {
                                  UserModel user = model.uId == uId ? AppCubit.get(context).userModel :
                                  AppCubit.get(context).users.firstWhere((element) => element.uId == model.uId);
                                  if(PostCubit.get(context).imageFile.path != '')
                                  {
                                    PostCubit.get(context).uploadCommentImage(
                                        post: model,
                                        text: commentController.text,
                                        time: DateTime.now().toIso8601String()
                                    );
                                    PostCubit.get(context).imageFile = File('');
                                  }else
                                    {
                                      PostCubit.get(context).comment(
                                          model: model,
                                          text: commentController.text,
                                          time: DateTime.now().toIso8601String()
                                      );
                                    }

                                  commentController.text='';
                                },
                              ): IconButton(
                                icon: Icon(Icons.image,color: mainColor,size: 23,),
                                onPressed: ()
                                {
                                  PostCubit.get(context).getImage();
                                },
                              ),
                              hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.3
                                ),
                              ),
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.5),
                                borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.3
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.3
                                ),
                              )
                          ),
                        ),
                      ),
                      SizedBox(width: 5.0,),
                    ],
                  ),
                  if(PostCubit.get(context).imageFile.path != '')
                    Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children:[
                          Container(
                            height: 180.0,
                            width: 220.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: FileImage(PostCubit.get(context).imageFile,),
                                fit: BoxFit.fill,
                              )
                            ),
                          ),
                          IconButton(onPressed: ()=> PostCubit.get(context).removeImage(), icon: Icon(Icons.close,color: Colors.white,))
                        ]
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  ),
).closed.then((value)
{
  if(PostCubit.get(context).imageFile.path.isNotEmpty)
  {
    PostCubit.get(context).imageFile = File('');
  }
  commentController.text = '';
  AppCubit.get(context).closeCommenting();
});
