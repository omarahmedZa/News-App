import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:news_app2/shared/cubit/post_cubit/state.dart';
import '../../../models/posts/post_model.dart';
import '../../../models/users/users_model.dart';
import '../../components/constants.dart';
import '../../network/remote/dio_helper.dart';



class PostCubit extends Cubit<PostStates>
{
  PostCubit() : super(PostInitialState());

  static PostCubit get(context) => BlocProvider.of(context);

  File imageFile = File('');
  final picker=ImagePicker();

  late UserModel user;

  Future getImage()async
  {

    final imagePicked = await picker.pickImage(source: ImageSource.gallery);

    if(imagePicked != null){
      imageFile= File(imagePicked.path);
      emit(ImagePickedSuccessState());
    }
    else
    {
      print('no image picked');

      emit(ImagePickedErrorState());
    }

  }

  void removeImage()
  {
    imageFile = File('');
    emit(ImageRemovedSuccessState());
  }

  late String editImage;
  void removeImageEdit()
  {
    editImage = '';
    emit(ImageRemovedSuccessState());
  }

  bool isComment = false;
  void isCommenting()
  {
    isComment = true;
    emit(CommentingState());
  }
  void closeCommenting()
  {
    isComment = false;
    print(isComment);
    emit(CommentingState());
  }

  void typeArabic()
  {
    emit(TypeArabicState());
  }

///// Update Profile /////
  void updateProfile({
  required UserModel userModel,
  required String profileImage,
  required String profileName
})
  {
    posts.forEach((post)
    {
      if(userModel.uId == post.uId)
      {
        updatePosts(
          userModel: userModel,
          post: post,
          profileImage: profileImage,
          profileName: profileName
        );
      }
      post.comments.forEach((comment)
      {
        comment.replies.forEach((reply)
        {
          if(userModel.uId==reply.uId)
          {
            updateReply(

              reply: reply,
              commentId: comment.commentId,
              postId: post.postId,
              profileImage: profileImage,
              profileName: profileName
            );
          }
        });
        if(userModel.uId == comment.uId)
        {
           updateComments(

              comment: comment,
              post: post,
              profileImage: profileImage,
              profileName: profileName
          );
        }
      });
    });
  }

///// Post /////
  void uploadPostImage(
      {
        required String text,
        required String time,
        required String content,
        required UserModel userModel,
      })
  {
    emit(UploadPostImageLoadingState());

    firebase_storage.FirebaseStorage.instance.ref()
        .child('posts/${uId}/${Uri.file(imageFile.path).pathSegments.last}')
        .putFile(imageFile)
        .then((value)
    {
      imageFile = File('');
      value.ref.getDownloadURL().then((value)
      {
        createPost(text: text, time: time,image: value, userModel: userModel, content: content);
      }).catchError((error){
        emit(CreatePostErrorState());
      });

    }).catchError((error)
    {
      emit(CreatePostErrorState());
    });

  }

  void createPost({
    required UserModel userModel,
    required String text,
    required String content,
    required String time,
    String image = '',
  })
  {
    PostModel post = PostModel(userModel.name, userModel.profileImage, time, text, uId, content,image);

    emit(CreatePostLoadingState());

    FirebaseFirestore.instance.collection('posts').add(post.toMap())
        .then((value)
    {
      imageFile = File('');
      emit(CreatePostSuccessState());
    })
        .catchError((error)
    {
      emit(CreatePostErrorState());
    });
  }

  void uploadPostEditImage(
      {
        required PostModel post,
        required String text,
        required UserModel userModel,
      })
  {
    emit(UploadPostImageLoadingState());

    firebase_storage.FirebaseStorage.instance.ref()
        .child('posts/${uId}/${Uri.file(imageFile.path).pathSegments.last}')
        .putFile(imageFile)
        .then((value)
    {
      imageFile = File('');
      value.ref.getDownloadURL().then((value)
      {
        updatePosts(post: post,image: value,text: text,userModel: userModel);
      }).catchError((error){
        emit(PostUpdateErrorState());
      });

    }).catchError((error)
    {
      emit(PostUpdateErrorState());
    });

  }

  void updatePosts({
    required PostModel post,
    required UserModel userModel,
    String? image,
    String? profileImage,
    String? profileName,
    String? text,
    String? content,
  })
  {
    emit(PostUpdateLoadingState());
    PostModel model = PostModel(profileName ?? userModel.name, profileImage ?? userModel.profileImage,post.postTime,text ?? post.title, userModel.uId,content ?? post.description,image ?? post.image);

    FirebaseFirestore.instance.collection('posts').doc(post.postId).update(model.toMap())
        .then((value)
    {
      emit(PostUpdateSuccessState());
    })
        .catchError((error)
    {
      emit(PostUpdateErrorState());
    });
  }

  void deletePost({
    required PostModel post,
  })
  {
    emit(DeletePostLoadingState());

    FirebaseFirestore.instance.collection('posts')
        .doc(post.postId)
        .delete()
        .then((value)
    {
      post.likes.forEach((element)
      {
        FirebaseFirestore.instance.collection('posts')
            .doc(post.postId)
            .collection('likes')
            .doc(element.uId)
            .delete().then((value) {});
      });
      post.comments.forEach((element)
      {
        deleteComment(comment: element, postId: post.postId);
      });
      emit(DeletePostSuccessState());
    })
        .catchError((error)
    {
      print(error.toString());
      emit(DeletePostErrorState());
    });
  }

  void likePost(
      {
        required PostModel model,
        required String time,
      })
  {
    emit(LikePostLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(model.postId)
        .collection('likes')
        .doc(uId)
        .set({'like':true})
        .then((value)
    {
      model.isLike = true;
      emit(LikePostSuccessState());
    })
        .catchError((error)
    {
      print(error.toString());
      emit(LikePostErrorState());
    });
  }

  void disLikePost(
      {
        required PostModel model,
      })
  {
    emit(DisLikePostLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(model.postId)
        .collection('likes')
        .doc(uId)
        .delete()
        .then((value)
    {
      model.isLike = false;
      emit(DisLikePostSuccessState());
    })
        .catchError((error)
    {
      print(error.toString());
      emit(DisLikePostErrorState());
    });
  }

////// Comment //////

  void uploadCommentImage(
      {
        required PostModel post,
        required String text,
        required String time,
      })
  {
    emit(UploadCommentImageLoadingState());

    firebase_storage.FirebaseStorage.instance.ref()
        .child('posts/${uId}/${Uri.file(imageFile.path).pathSegments.last}')
        .putFile(imageFile)
        .then((value)
    {
      imageFile = File('');
      value.ref.getDownloadURL().then((value)
      {
        comment(model: post, text: text, time: time,image: value);
      }).catchError((error){
        emit(CommentPostErrorState());
      });

    }).catchError((error)
    {
      emit(CommentPostErrorState());
    });

  }

  void comment({

    required PostModel model,
    required String text,
    required String time,
    String? image
  })
  {
    emit(CommentPostLoadingState());

    CommentModel postComment = CommentModel(user.name,user.profileImage,time,text,uId,image ?? '');

    FirebaseFirestore.instance.collection('posts')
    .doc(model.postId)
    .collection('comments')
    .add(postComment.toMap())
    .then((value)
    {
      emit(CommentPostSuccessState());
    })
    .catchError((error)
    {
      print(error.toString());

      emit(CommentPostErrorState());
    });

  }

  void uploadCommentEditImage(
      {

        required PostModel post,
        required CommentModel comment,
        required String text,
      })
  {
    emit(UploadCommentImageLoadingState());

    firebase_storage.FirebaseStorage.instance.ref()
        .child('posts/${uId}/${Uri.file(imageFile.path).pathSegments.last}')
        .putFile(imageFile)
        .then((value)
    {
      imageFile = File('');
      value.ref.getDownloadURL().then((value)
      {
        updateComments(comment: comment, post: post,image: value,text: text);
      }).catchError((error){
        emit(CommentUpdateErrorState());
      });

    }).catchError((error)
    {
      emit(CommentUpdateErrorState());
    });

  }

  void updateComments({
    required CommentModel comment,
    required PostModel post,

    String? image,
    String? profileImage,
    String? profileName,
    String? text,
  })
  {
    emit(CommentUpdateLoadingState());
    CommentModel model = CommentModel(profileName ??user.name, profileImage ?? user.profileImage,comment.commentTime,text ?? comment.text, user.uId,image ?? comment.image);

    FirebaseFirestore.instance.collection('posts')
        .doc(post.postId)
        .collection('comments')
        .doc(comment.commentId)
        .update(model.toMap())
        .then((value)
    {
      emit(CommentUpdateSuccessState());
    })
        .catchError((error)
    {
      emit(CommentUpdateErrorState());
    });
  }

  void deleteComment({
    required CommentModel comment,
    required String postId,
  })
  {
    emit(DeleteCommentLoadingState());

    FirebaseFirestore.instance.collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment.commentId)
        .delete()
        .then((value)
    {
      comment.replies.forEach((element)
      {
        deleteReply(replyId: element, commentId: comment.commentId, postId: postId);
      });
      emit(DeleteCommentSuccessState());
    })
        .catchError((error)
    {
      print(error.toString());
      emit(DeleteCommentErrorState());
    });
  }

  void likeComment(
      {
        required String postId,
        required String time,
        required CommentModel comment,
      })
  {
    emit(LikeCommentLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment.commentId)
        .collection('likes')
        .doc(uId)
        .set({'like':true})
        .then((value)
    {
      comment.isLike = true;
      emit(LikeCommentSuccessState());
    })
        .catchError((error)
    {
      print(error.toString());
      emit(LikeCommentErrorState());
    });
  }

  void disLikeComment(
      {
        required String postId,
        required CommentModel comment,
      })
  {
    emit(DisLikeCommentLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment.commentId)
        .collection('likes')
        .doc(uId)
        .delete()
        .then((value)
    {
      comment.isLike = false;
      emit(DisLikeCommentSuccessState());
    })
        .catchError((error)
    {
      print(error.toString());
      emit(DisLikeCommentErrorState());
    });
  }

///// Reply /////

  void uploadReplyImage(
      {

        required PostModel post,
        required CommentModel comment,
        required String text,
        required String time,
      })
  {
    emit(UploadReplyImageLoadingState());

    firebase_storage.FirebaseStorage.instance.ref()
        .child('posts/${uId}/${Uri.file(imageFile.path).pathSegments.last}')
        .putFile(imageFile)
        .then((value)
    {
      imageFile = File('');
      value.ref.getDownloadURL().then((value)
      {
        reply(post: post,comment: comment, text: text, time: time,image: value);
      }).catchError((error){
        emit(ReplyCommentErrorState());
      });

    }).catchError((error)
    {
      emit(ReplyCommentErrorState());
    });

  }

  void reply({

    required PostModel post,
    required CommentModel comment,
    required String text,
    required String time,
    String? image
  })
  {
    emit(ReplyCommentLoadingState());

    CommentModel postComment = CommentModel(user.name,user.profileImage,time,text,user.uId,image ?? '');

    FirebaseFirestore.instance.collection('posts')
        .doc(post.postId)
        .collection('comments')
        .doc(comment.commentId)
        .collection('replies')
        .add(postComment.toMap())
        .then((value)
    {
      emit(ReplyCommentSuccessState());

    })
        .catchError((error)
    {
      print(error.toString());

      emit(ReplyCommentErrorState());
    });

  }

  void uploadReplyEditImage(
      {
        required CommentModel reply,
        required String commentId,
        required String postId,
        required String text,

      })
  {
    emit(UploadReplyImageLoadingState());

    firebase_storage.FirebaseStorage.instance.ref()
        .child('posts/${uId}/${Uri.file(imageFile.path).pathSegments.last}')
        .putFile(imageFile)
        .then((value)
    {
      imageFile = File('');
      value.ref.getDownloadURL().then((value)
      {
        updateReply(reply: reply,commentId: commentId, postId: postId,image: value,text: text);
      }).catchError((error){
        emit(ReplyUpdateErrorState());
      });

    }).catchError((error)
    {
      emit(ReplyUpdateErrorState());
    });

  }

  void updateReply({
    required CommentModel reply,
    required String commentId,
    required String postId,

    String? image,
    String? profileImage,
    String? profileName,
    String? text,
  })
  {
    print(reply.commentId);
    emit(ReplyUpdateLoadingState());
    CommentModel model = CommentModel(profileName ?? user.name, profileImage ?? user.profileImage,reply.commentTime,text ?? reply.text, user.uId,image ?? reply.image);

    FirebaseFirestore.instance.collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .doc(reply.commentId)
        .update(model.toMap())
        .then((value)
    {
      emit(ReplyUpdateSuccessState());
    })
        .catchError((error)
    {
      emit(ReplyUpdateErrorState());
    });
  }


  void deleteReply({
    required CommentModel replyId,
    required String commentId,
    required String postId,
  })
  {
    emit(DeleteReplyLoadingState());

    FirebaseFirestore.instance.collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .doc(replyId.commentId)
        .delete()
        .then((value)
    {
      emit(DeleteReplySuccessState());
    })
        .catchError((error)
    {
      print(error.toString());
      emit(DeleteReplyErrorState());
    });
  }

  void likeReply(
      {
        required String postId,
        required String commentId,
        required String time,
        required CommentModel reply,
      })
  {
    emit(LikeReplyLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .doc(reply.commentId)
        .collection('likes')
        .doc(uId)
        .set({'like':true})
        .then((value)
    {
      reply.isLike = true;
      emit(LikeReplySuccessState());
    })
        .catchError((error)
    {
      print(error.toString());
      emit(LikeReplyErrorState());
    });
  }

  void disLikeReply(
      {
        required String postId,
        required String commentId,
        required CommentModel reply,
      })
  {
    emit(DisLikeReplyLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .doc(reply.commentId)
        .collection('likes')
        .doc(uId)
        .delete()
        .then((value)
    {
      reply.isLike = false;
      emit(DisLikeReplySuccessState());
    })
        .catchError((error)
    {
      print(error.toString());
      emit(DisLikeReplyErrorState());
    });
  }

///// Get Posts /////

  List<PostModel> posts = [];
  List<PostModel> homePosts = [];

  void getPosts({
    required UserModel userModel,
})
  {
    user = userModel;
    int index = 0;
    emit(GetPostsLoadingState());

    FirebaseFirestore.instance
        .collection('posts').orderBy('time',descending: true)
        .snapshots()
        .listen((value)
    {
      posts = [];
      homePosts =[];
      userModel.myPosts = [];
      index = 0;
      value.docs.forEach((element)
      {
        element.reference.collection('likes').snapshots().listen((event)
        {
          posts.forEach((post)
          {
            if(post.postId == element.id)
            {
              post.likes = [];
              event.docs.forEach((e)
              {
                post.likes.add(LikeModel(e.id,e.data()['time']));
                if(uId == e.id)
                {
                  post.isLike = true;
                  emit(LikePostSuccessState());
                }
                else if(uId != e.id && !post.isLike)
                {
                  post.isLike = false;
                  emit(DisLikePostSuccessState());
                }
              });
            }
          });
        });
        element.reference.collection('comments').orderBy('time',descending: true)
            .snapshots()
            .listen((event)
        {

          posts.forEach((post)
          {
            int commentIndex = 0;
            if(post.postId == element.id )
            {
              post.comments = [];
              event.docs.forEach((e)
              {
                post.comments.add(CommentModel.fromJson(e.data()));
                post.comments[commentIndex].commentId = e.id;
                post.comments.forEach((comment)
                {

                  if(comment.commentId==e.id)
                  {


                    e.reference.collection('likes').snapshots().listen((event)
                    {
                      comment.likes = [];
                      event.docs.forEach((e)
                      {
                        comment.likes.add(LikeModel(e.id,e.data()['time']));
                        if(uId == e.id)
                        {
                          comment.isLike = true;
                          emit(LikeCommentSuccessState());
                        }
                        else if(uId != e.id && !comment.isLike)
                        {
                          comment.isLike = false;
                          emit(DisLikeCommentSuccessState());
                        }
                      });
                    });
                    e.reference.collection('replies').orderBy('time')
                        .snapshots()
                        .listen((event)
                    {
                      comment.replies =[];
                      int replyIndex = 0;
                      event.docs.forEach((reply)
                      {
                        comment.replies.add(CommentModel.fromJson(reply.data()));
                        comment.replies[replyIndex].commentId = reply.id;
                        print(comment.replies[replyIndex].commentId);
                        comment.replies.forEach((replies)
                        {
                          if(replies.commentId == reply.id)
                          {
                            reply.reference.collection('likes').snapshots().listen((like)
                            {
                              replies.likes = [];
                              like.docs.forEach((element)
                              {
                                replies.likes.add(LikeModel(element.id,element.data()['time']));
                                if(uId == element.id)
                                {
                                  replies.isLike = true;
                                  emit(LikeReplySuccessState());
                                }
                                else if(uId != element.id && !replies.isLike)
                                {
                                  replies.isLike = false;
                                  emit(DisLikeReplySuccessState());
                                }
                              });
                            });
                          }
                        });
                        replyIndex++;
                      });

                    });
                  }

                });
                commentIndex++;
              });

            }

          });
        });

        element.reference.collection('saved').snapshots().listen((event)
        {
          posts.forEach((post)
          {
            if(post.postId == element.id)
            {
              post.saved = [];
              event.docs.forEach((e)
              {
                post.saved.add(SaveModel(e.id,e.data()['time']));
                if(uId == e.id)
                {
                  userModel.myPosts.add(post);
                  post.isSaved = true;
                  emit(PostSaveSuccessState());
                }
                else if(uId != e.id && !post.isSaved)
                {
                  post.isSaved = false;
                  emit(PostUnSaveSuccessState());
                }
              });
            }
          });
        });


        posts.add(PostModel.fromJson(element.data()));
        posts[index].postId = element.id;
        //print(posts[index].saved.length);
        print(posts[index].saved.contains(uId));
        print(posts[index].saved.length);
        homePosts.add(posts[index]);

        if(posts[index].uId == uId || posts[index].saved.contains(uId))
        {
          userModel.myPosts.add(posts[index]);
        }
        index++;
        emit(GetPostsSuccessState());
      });
    });
  }

  void getUserPosts({
    required UserModel userModel,
})
  {
    emit(GetPostsLoadingState());
    userModel.myPosts = [];


    userModel.myPosts.addAll(posts.where((element)
    {
      if(userModel.isAdmin)
      {
        return element.uId == userModel.uId;
      }
      else {
        print("posts: ${element.postId}");
        bool found = false;
        element.saved.forEach((save) {
          print("posts: ${save.uId}");
          if (save.uId == userModel.uId)
            found = true;
        });

        return found;
      }
    }
    ));
    print("posts: ${userModel.myPosts.length}");
    emit(GetPostsSuccessState());

  }

///// Search /////

  List<PostModel> searchPosts =[];
  void search({
    required String text,
  })
  {
    searchPosts = [];

    searchPosts.addAll(posts.where((element) => (element.userName.toLowerCase().contains(RegExp(text.toLowerCase())) ||
        (element.title.toLowerCase().contains(text.toLowerCase())))));

    emit(SearchState());
  }


///// hide /////


  void savePost({
    required PostModel post
  })
  {
    emit(PostSaveLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.postId)
        .collection('saved')
        .doc(uId)
        .set({'save':true})
        .then((value)
    {
      post.isSaved = true;
      emit(PostSaveSuccessState());
    });

  }

  void unSavePost({
    required PostModel post
  })
  {
    emit(PostSaveLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.postId)
        .collection('saved')
        .doc(uId)
        .delete()
        .then((value)
    {
      post.isSaved = false;
      emit(PostSaveSuccessState());
    });

  }
}