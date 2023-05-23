
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/posts/post_model.dart';
import '../../models/users/users_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/cubit/app_cubit/cubit.dart';
import '../../shared/cubit/post_cubit/cubit.dart';
import '../../shared/cubit/post_cubit/state.dart';
import '../../shared/cubit/theme_cubit/cubit.dart';
import '../../shared/style/colors.dart';
import '../profile/user_profile_screen.dart';
import 'likes_screen.dart';

class ReplyScreen extends StatelessWidget {
  CommentModel comment;
  final PostModel post;
  TextEditingController replyController = TextEditingController();

  ReplyScreen(this.comment, this.post);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: ThemeCubit.get(context).isDark
                                ? Colors.grey[300]
                                : Colors.black,
                          )),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Replies',
                        style: Theme.of(context).textTheme.bodyText2,
                      )
                    ],
                  ),
                  myDivider(context),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () {
                                  if (AppCubit.get(context).isUserScreen ==
                                      false) {
                                    AppCubit.get(context).openUserScreen();
                                    PostCubit.get(context).getUserPosts(
                                        userModel: AppCubit.get(context)
                                            .users
                                            .firstWhere((element) =>
                                                comment.uId == element.uId));
                                    navigateTo(
                                        context,
                                        UserProfileScreen(AppCubit.get(context)
                                            .users
                                            .firstWhere((element) =>
                                                comment.uId == element.uId)));
                                  }
                                },
                                child: buildNetworkProfileImage(
                                    imageUrl: comment.userImage)),
                            SizedBox(
                              width: 5.0,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        10.0, 7.0, 10.0, 7.0),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    constraints: BoxConstraints(
                                        minHeight: 40.0, maxWidth: 290.0),
                                    decoration: BoxDecoration(
                                        color: ThemeCubit.get(context).isDark
                                            ? Colors.grey[800]
                                            : Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 2,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (AppCubit.get(context)
                                                    .isUserScreen ==
                                                false) {
                                              AppCubit.get(context)
                                                  .openUserScreen();
                                              PostCubit.get(context)
                                                  .getUserPosts(
                                                      userModel: AppCubit.get(
                                                              context)
                                                          .users
                                                          .firstWhere(
                                                              (element) =>
                                                                  comment.uId ==
                                                                  element.uId));
                                              navigateTo(
                                                  context,
                                                  UserProfileScreen(
                                                      AppCubit.get(context)
                                                          .users
                                                          .firstWhere(
                                                              (element) =>
                                                                  comment.uId ==
                                                                  element
                                                                      .uId)));
                                            }
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                comment.userName,
                                                textAlign: TextAlign.left,
                                                textDirection: comment.userName
                                                        .contains(RegExp(
                                                            r'[\u0600-\u06FF]'))
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    !.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              if(comment.uId == 'ff5Nc8LOWIPi6UZfxTDXlRc6lTs1')
                                                myVerification(),
                                            ],
                                          ),
                                        ),
                                        if (comment.text.isNotEmpty)
                                          Text(
                                            comment.text,
                                            textAlign: comment.text.contains(
                                                    RegExp(r'[\u0600-\u06FF]'))
                                                ? TextAlign.right
                                                : TextAlign.left,
                                            textDirection: comment.text
                                                    .contains(RegExp(
                                                        r'[\u0600-\u06FF]'))
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (comment.image.isNotEmpty)
                                  InkWell(
                                    child: buildNetworkImage(
                                        imageUrl: comment.image,
                                        height: 180.0,
                                        width: 230.0,
                                        radius: 15.0,
                                        fit: BoxFit.fill),
                                  ),
                                SizedBox(
                                  height: 3.5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      comment.time,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          !.copyWith(fontSize: 13.0),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    if (comment.likes.isNotEmpty)
                                      InkWell(
                                        onTap: ()
                                        {
                                          navigateTo(context, LikesScreen(comment.likes));
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              '${comment.likes.length}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  !.copyWith(
                                                    fontSize: 13.0,
                                                  ),
                                            ),
                                            Icon(
                                              comment.isLike == true
                                                  ? Icons.favorite
                                                  : Icons.favorite_border_outlined,
                                              color: Colors.red,
                                              size: 17.0,
                                            ),
                                          ],
                                        ),
                                      ),

                                    InkWell(
                                      onTap: () {
                                        print('liked');
                                        if (comment.isLike) {
                                          PostCubit.get(context).disLikeComment(
                                              postId: post.postId,
                                              comment: comment);
                                        } else {
                                          PostCubit.get(context).likeComment(
                                              postId: post.postId,
                                              comment: comment,
                                              time: DateTime.now()
                                                  .toIso8601String());
                                        }
                                      },
                                      child: Container(
                                        height: 23.0,
                                        child: Row(
                                          children: [
                                            if (comment.likes.isNotEmpty)
                                              SizedBox(
                                                width: 4.0,
                                              ),
                                            Text(
                                              comment.isLike ? 'Liked' : 'Like',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  !.copyWith(
                                                      fontSize: 13.0,
                                                      color: comment.isLike
                                                          ? Colors.red
                                                          : (ThemeCubit.get(
                                                                      context)
                                                                  .isDark
                                                              ? appLightColor
                                                              : appDarkColor)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Column(
                          children:
                              List.generate(comment.replies.length, (index) {
                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(45.0, 0, 0, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            if (AppCubit.get(context)
                                                    .isUserScreen ==
                                                false) {
                                              AppCubit.get(context)
                                                  .openUserScreen();
                                              PostCubit.get(context)
                                                  .getUserPosts(
                                                      userModel: AppCubit.get(
                                                              context)
                                                          .users
                                                          .firstWhere(
                                                              (element) =>
                                                                  comment.replies[index].uId ==
                                                                  element.uId));
                                              navigateTo(
                                                  context,
                                                  UserProfileScreen(
                                                      AppCubit.get(context)
                                                          .users
                                                          .firstWhere(
                                                              (element) =>
                                                                  comment.replies[index].uId ==
                                                                  element
                                                                      .uId)));
                                            }
                                          },
                                          child: buildNetworkProfileImage(
                                              imageUrl: comment.replies[index].userImage,
                                              radius: 15)),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10.0, 7.0, 10.0, 7.0),
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              constraints: BoxConstraints(
                                                  minHeight: 40.0,
                                                  maxWidth: 290.0),
                                              decoration: BoxDecoration(
                                                  color: ThemeCubit.get(context)
                                                          .isDark
                                                      ? Colors.grey[800]
                                                      : Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (AppCubit.get(context)
                                                              .isUserScreen ==
                                                          false) {
                                                        AppCubit.get(context)
                                                            .openUserScreen();
                                                        PostCubit.get(context).getUserPosts(
                                                            userModel: AppCubit
                                                                    .get(
                                                                        context)
                                                                .users
                                                                .firstWhere(
                                                                    (element) =>
                                                                        comment.replies[index]
                                                                            .uId ==
                                                                        element
                                                                            .uId));
                                                        navigateTo(
                                                            context,
                                                            UserProfileScreen(AppCubit
                                                                    .get(
                                                                        context)
                                                                .users
                                                                .firstWhere(
                                                                    (element) =>
                                                                        comment.replies[index]
                                                                            .uId ==
                                                                        element
                                                                            .uId)));
                                                      }
                                                    },
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          comment.replies[index].userName,
                                                          textAlign: TextAlign.left,
                                                          textDirection: comment.replies[index]
                                                                  .userName
                                                                  .contains(RegExp(
                                                                      r'[\u0600-\u06FF]'))
                                                              ? TextDirection.rtl
                                                              : TextDirection.ltr,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle1
                                                              !.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        if(comment.replies[index].uId == 'ff5Nc8LOWIPi6UZfxTDXlRc6lTs1')
                                                          myVerification(),
                                                      ],
                                                    ),
                                                  ),
                                                  if (comment.replies[index].text.isNotEmpty)
                                                    Text(
                                                      comment.replies[index].text,
                                                      textAlign: comment.replies[index].text
                                                              .contains(RegExp(
                                                                  r'[\u0600-\u06FF]'))
                                                          ? TextAlign.right
                                                          : TextAlign.left,
                                                      textDirection: comment.replies[index].text
                                                              .contains(RegExp(
                                                                  r'[\u0600-\u06FF]'))
                                                          ? TextDirection.rtl
                                                          : TextDirection.ltr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1,
                                                      maxLines: 4,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: true,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (comment.replies[index].image.isNotEmpty)
                                            InkWell(
                                              child: buildNetworkImage(
                                                  imageUrl: comment.replies[index].image,
                                                  height: 180.0,
                                                  width: 230.0,
                                                  radius: 15.0,
                                                  fit: BoxFit.fill),
                                            ),
                                          SizedBox(
                                            height: 3.5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                comment.replies[index].time,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    !.copyWith(fontSize: 13.0),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              if (comment.replies[index].likes.isNotEmpty)
                                                InkWell(
                                                  onTap: ()
                                                  {
                                                    navigateTo(context, LikesScreen(comment.replies[index].likes));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '${comment.replies[index].likes.length}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            !.copyWith(
                                                              fontSize: 13.0,
                                                            ),
                                                      ),
                                                      Icon(
                                                        comment.replies[index].isLike == true
                                                            ? Icons.favorite
                                                            : Icons
                                                            .favorite_border_outlined,
                                                        color: Colors.red,
                                                        size: 17.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              InkWell(
                                                onTap: () {
                                                  print(comment.replies[index].likes.length);
                                                  if (comment.replies[index].isLike) {
                                                    PostCubit.get(context)
                                                        .disLikeReply(
                                                            postId: post.postId,
                                                            commentId: comment
                                                                .commentId,
                                                            reply: comment.replies[index]);
                                                  } else {
                                                    PostCubit.get(context)
                                                        .likeReply(
                                                            postId: post.postId,
                                                            commentId: comment
                                                                .commentId,
                                                            reply: comment.replies[index],
                                                            time: DateTime.now()
                                                                .toIso8601String());
                                                  }
                                                },
                                                child: Container(
                                                  height: 23.0,
                                                  child: Row(
                                                    children: [
                                                      if (comment.replies[index]
                                                          .likes.isNotEmpty)
                                                        SizedBox(
                                                          width: 4.0,
                                                        ),
                                                      Text(
                                                        comment.replies[index].isLike
                                                            ? 'Liked'
                                                            : 'Like',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            !.copyWith(
                                                                fontSize: 13.0,
                                                                color: comment.replies[index]
                                                                        .isLike
                                                                    ? Colors.red
                                                                    : (ThemeCubit.get(context)
                                                                            .isDark
                                                                        ? appLightColor
                                                                        : appDarkColor)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  myDivider(context),
                  SizedBox(
                    height: 5.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          buildNetworkProfileImage(
                              imageUrl:
                                  AppCubit.get(context).userModel.profileImage),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: replyController,
                              keyboardType: TextInputType.text,
                              maxLines: 3,
                              minLines: 1,
                              style: Theme.of(context).textTheme.subtitle1,
                              textDirection: replyController.text
                                      .contains(RegExp(r'[\u0600-\u06FF]'))
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              onChanged: (value) {
                                if (value.length <= 2)
                                  PostCubit.get(context).typeArabic();
                              },
                              decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  filled: false,
                                  hintText: 'Write a reply ...',
                                  suffixIcon: (replyController
                                              .text.isNotEmpty ||
                                          PostCubit.get(context).imageFile !=
                                              null)
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.send,
                                            color: Colors.blue,
                                            size: 23,
                                          ),
                                          onPressed: ()
                                          {
                                            UserModel user = comment.uId == uId ? AppCubit.get(context).userModel :
                                            AppCubit.get(context).users.firstWhere((element) => element.uId == comment.uId);
                                            if (PostCubit.get(context)
                                                    .imageFile.path.isNotEmpty) {
                                              PostCubit.get(context)
                                                  .uploadReplyImage(
                                                post: post,
                                                comment: comment,
                                                text: replyController.text,
                                                time: DateTime.now()
                                                    .toIso8601String(),
                                              );
                                              PostCubit.get(context).imageFile =
                                                  File('');
                                            } else {
                                              PostCubit.get(context).reply(
                                                  post: post,
                                                  comment: comment,
                                                  text: replyController.text,
                                                  time: DateTime.now()
                                                      .toIso8601String());
                                            }

                                            replyController.text = '';
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(
                                            Icons.image,
                                            color: mainColor,
                                            size: 23,
                                          ),
                                          onPressed: () {
                                            PostCubit.get(context).getImage();
                                          },
                                        ),
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      !.copyWith(color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.3),
                                  ),
                                  focusColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.5),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.3),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.3),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                        ],
                      ),
                      if (PostCubit.get(context).imageFile.path != '')
                        Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 170.0,
                                width: 220.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    image: DecorationImage(
                                      image: FileImage(
                                        PostCubit.get(context).imageFile,
                                      ),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              IconButton(
                                  onPressed: () =>
                                      PostCubit.get(context).removeImage(),
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ))
                            ]),
                      //SizedBox(height: 10.0,)
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
