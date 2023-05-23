import 'package:intl/intl.dart';

class PostModel
{
  String userName ='';
  String userImage ='';
  String time ='';
  String postTime ='';
  String title ='';
  String description ='';
  String image ='';
  String uId ='';
  String postId ='';
  List<LikeModel> likes =[];
  bool isLike = false;
  bool isSaved = false;
  List<CommentModel> comments = [];
  List<SaveModel> saved = [];

  PostModel(this.userName,this.userImage,this.postTime,this.title,this.uId, this.description,this.image);

  PostModel.fromJson(Map<String,dynamic> json)
  {
    userName = json['userName'];
    userImage = json['userImage'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    uId = json['uId'];
    postTime = json['time'];

    if(DateTime.now().difference(DateTime.parse(json['time'])).inSeconds == 0)
    {
      time = 'Just now';
    }
    if(DateTime.now().difference(DateTime.parse(json['time'])).inMinutes < 1 && DateTime.now().difference(DateTime.parse(json['time'])).inSeconds > 0)
    {
      time = '${DateTime.now().difference(DateTime.parse(json['time'])).inSeconds} s';
    }
    if(DateTime.now().difference(DateTime.parse(json['time'])).inMinutes >= 1)
    {
      time = '${DateTime.now().difference(DateTime.parse(json['time'])).inMinutes} m';
    }
    if(DateTime.now().difference(DateTime.parse(json['time'])).inHours >= 1)
    {
      time = '${DateTime.now().difference(DateTime.parse(json['time'])).inHours} h';
    }
    if(DateTime.now().difference(DateTime.parse(json['time'])).inDays >= 1)
    {
      time = '${DateTime.now().difference(DateTime.parse(json['time'])).inDays} d';
    }
    if(DateTime.now().difference(DateTime.parse(json['time'])).inDays >= 1 && DateTime.now().difference(DateTime.parse(json['time'])).inDays % 7 == 0)
    {
      time = '${(DateTime.now().difference(DateTime.parse(json['time'])).inDays / 7).floor()} w';
    }
    if(DateTime.now().difference(DateTime.parse(json['time'])).inDays >= 1 && DateTime.now().difference(DateTime.parse(json['time'])).inDays > 7
        && DateTime.now().difference(DateTime.parse(json['time'])).inDays % 7 != 0)
    {
      time = DateFormat.MMMd().format(DateTime.parse(json['time']));
    }
  }

  Map<String,dynamic> toMap()
  {
    return {
      'userName' : userName,
      'userImage' : userImage,
      'time' : postTime,
      'title' : title,
      'description' : description,
      'image' : image,
      'uId' : uId,
    };
  }
}

class CommentModel
{
  String userName ='';
  String userImage ='';
  String time ='';
  String commentTime ='';
  String text ='';
  String image ='';
  String uId ='';
  String commentId ='';
  List<LikeModel> likes = [];
  bool isLike = false;
  List<CommentModel> replies = [];

  CommentModel(this.userName,this.userImage,this.commentTime,this.text,this.uId, this.image);

  CommentModel.fromJson(Map<String,dynamic> json)
  {
    userName = json['userName'];
    userImage = json['userImage'];
    text = json['text'];
    image = json['image'];
    uId = json['uId'];
    commentTime = json['time'];

    if(DateTime.now().difference(DateTime.parse(json['time'])).inSeconds == 0)
    {
      time = 'Just now';
    }
    if(DateTime.now().difference(DateTime.parse(json['time'])).inMinutes < 1 && DateTime.now().difference(DateTime.parse(json['time'])).inSeconds > 0)
    {
      time = '${DateTime.now().difference(DateTime.parse(json['time'])).inSeconds} s';
    }
    if(DateTime.now().difference(DateTime.parse(json['time'])).inMinutes >= 1)
    {
      time = '${DateTime.now().difference(DateTime.parse(json['time'])).inMinutes} m';
    }
    if(DateTime.now().difference(DateTime.parse(json['time'])).inHours >= 1)
    {
      time = '${DateTime.now().difference(DateTime.parse(json['time'])).inHours} h';
    }
    if(DateTime.now().difference(DateTime.parse(json['time'])).inDays >= 1)
    {
      time = '${DateTime.now().difference(DateTime.parse(json['time'])).inDays} d';
    }
    if(DateTime.now().difference(DateTime.parse(json['time'])).inDays >= 1 && DateTime.now().difference(DateTime.parse(json['time'])).inDays % 7 ==0)
    {
      time = '${(DateTime.now().difference(DateTime.parse(json['time'])).inDays / 7).floor()} w';
    }
    if(DateTime.now().difference(DateTime.parse(json['time'])).inDays >= 1 && DateTime.now().difference(DateTime.parse(json['time'])).inDays > 7
        && DateTime.now().difference(DateTime.parse(json['time'])).inDays % 7 != 0)
    {
      time = DateFormat.MMMd().format(DateTime.parse(json['time']));
    }
  }

  Map<String,dynamic> toMap()
  {
    return {
      'userName' : userName,
      'userImage' : userImage,
      'time' : commentTime,
      'text' : text,
      'image' : image,
      'uId' : uId,
    };
  }
}

class LikeModel
{
  String? uId;
  String? time;
  bool? like;

  LikeModel(this.uId,this.time);

  LikeModel.fromJson(Map<String,dynamic> json)
  {
    like = json[like];
  }

}

class SaveModel
{
  String? uId;
  String? time;
  bool? save;

  SaveModel(this.uId,this.time);

  SaveModel.fromJson(Map<String,dynamic> json)
  {
    save = json[save];
  }

}