import '../posts/post_model.dart';

class UserModel
{
  String name ='';
  String email ='';
  String phone ='';
  String profileImage ='';
  String bio ='';
  String uId ='';
  List<PostModel> myPosts = [];
  bool isAdmin = false;
  int rate = 3;
  int index = -1;


  UserModel(this.name,this.email,this.phone,this.uId, this.bio, this.profileImage,);

  UserModel.fromJson(Map<String,dynamic>? json)
  {
    name = json!['name'];
    email = json['email'];
    phone = json['phone'];
    profileImage = json['profileImage'];
    bio = json['bio'];
    uId = json['uId'];
    rate = json['rate'];
    isAdmin = json['isAdmin'];
  }

  Map<String,dynamic> toMap()
  {
    return {
      'name' : name,
      'email' : email,
      'phone' : phone,
      'profileImage' : profileImage,
      'bio' : bio,
      'uId' : uId,
      'rate' : rate,
      'isAdmin' : isAdmin,
    };
  }

  void clear()
  {
    myPosts =[];
    name = '';
    email = '';
    phone = '';
    profileImage = '';
    bio = '';
    uId = '';
    rate = 0;
  }

}