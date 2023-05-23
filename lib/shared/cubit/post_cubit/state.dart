abstract class PostStates {}

class PostInitialState extends PostStates {}

class ImagePickedSuccessState extends PostStates {}

class ImagePickedErrorState extends PostStates {}

class ImageRemovedSuccessState extends PostStates {}

class TypeArabicState extends PostStates {}
class SearchState extends PostStates {}

///likes
class LikePostLoadingState extends PostStates {}

class LikePostSuccessState extends PostStates {}

class LikePostErrorState extends PostStates {}

class DisLikePostLoadingState extends PostStates {}

class DisLikePostSuccessState extends PostStates {}

class DisLikePostErrorState extends PostStates {}

class LikeCommentLoadingState extends PostStates {}

class LikeCommentSuccessState extends PostStates {}

class LikeCommentErrorState extends PostStates {}

class DisLikeCommentLoadingState extends PostStates {}

class DisLikeCommentSuccessState extends PostStates {}

class DisLikeCommentErrorState extends PostStates {}

class LikeReplyLoadingState extends PostStates {}

class LikeReplySuccessState extends PostStates {}

class LikeReplyErrorState extends PostStates {}

class DisLikeReplyLoadingState extends PostStates {}

class DisLikeReplySuccessState extends PostStates {}

class DisLikeReplyErrorState extends PostStates {}

///comment
class UploadCommentImageLoadingState extends PostStates {}

class CommentPostLoadingState extends PostStates {}

class CommentPostSuccessState extends PostStates {}

class CommentPostErrorState extends PostStates {}

class CommentUpdateLoadingState extends PostStates {}

class CommentUpdateSuccessState extends PostStates {}

class CommentUpdateErrorState extends PostStates {}

class DeleteCommentLoadingState extends PostStates {}

class DeleteCommentSuccessState extends PostStates {}

class DeleteCommentErrorState extends PostStates {}

///reply
class UploadReplyImageLoadingState extends PostStates {}

class ReplyCommentLoadingState extends PostStates {}

class ReplyCommentSuccessState extends PostStates {}

class ReplyCommentErrorState extends PostStates {}

class ReplyUpdateLoadingState extends PostStates {}

class ReplyUpdateSuccessState extends PostStates {}

class ReplyUpdateErrorState extends PostStates {}

class DeleteReplyLoadingState extends PostStates {}

class DeleteReplySuccessState extends PostStates {}

class DeleteReplyErrorState extends PostStates {}

///post
class UploadPostImageLoadingState extends PostStates {}

class CreatePostLoadingState extends PostStates {}

class CreatePostSuccessState extends PostStates {}

class CreatePostErrorState extends PostStates {}

class GetCommentPostLoadingState extends PostStates {}

class GetCommentPostSuccessState extends PostStates {}

class GetPostsLoadingState extends PostStates {}

class GetPostsSuccessState extends PostStates {}

class PostUpdateLoadingState extends PostStates {}

class PostUpdateSuccessState extends PostStates {}

class PostSaveLoadingState extends PostStates {}

class PostSaveSuccessState extends PostStates {}

class PostUnSaveSuccessState extends PostStates {}

class PostUpdateErrorState extends PostStates {}

class DeletePostLoadingState extends PostStates {}

class DeletePostSuccessState extends PostStates {}

class DeletePostErrorState extends PostStates {}

class CommentingState extends PostStates {}
