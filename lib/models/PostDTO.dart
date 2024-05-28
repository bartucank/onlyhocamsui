import 'package:json_annotation/json_annotation.dart';

import 'CommentDTO.dart';
import 'DocumentDTO.dart';
import 'LikeLogDTO.dart';
import 'UserDTO.dart';
part 'PostDTO.g.dart';
@JsonSerializable(explicitToJson: true)
class PostDTO {
  int? id;
  String? content;
  String? publishDate;
  String? formattedDate;
  UserDTO? user;
  int? categoryId;
  String? categoryName;
  List<DocumentDTO>? documents;
  List<CommentDTO>? comments;
  List<LikeLogDTO>? actions;
  bool? isLiked;
  bool? isDisliked;






  PostDTO({
    this.id,
    this.content,
    this.publishDate,
    this.formattedDate,
    this.user,
    this.categoryId,
    this.categoryName,
    this.documents,
    this.comments,
    this.actions,
    this.isLiked,
    this.isDisliked
  });

  factory PostDTO.fromJson(Map<String,dynamic> data) => _$PostDTOFromJson(data);

  Map<String,dynamic> toJson()=>_$PostDTOToJson(this);
}
