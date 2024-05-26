import 'package:json_annotation/json_annotation.dart';

part 'PostDTO.g.dart';
@JsonSerializable(explicitToJson: true)
class PostDTO {
  int? id;
  string? content;
  string? publishDate;
  string? formattedDate;
  UserDTO? user;
  int? categoryId;
  string? categoryName;
  List<DocumentDTO>? documents;
  List<CommentDTO>? comments;
  List<LikeLogDTO>? actions;






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
  });

  factory PostDTO.fromJson(Map<String,dynamic> data) => _$PostDTOFromJson(data);

  Map<String,dynamic> toJson()=>_$PostDTOToJson(this);
}
