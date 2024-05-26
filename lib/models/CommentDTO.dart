import 'package:json_annotation/json_annotation.dart';

import 'UserDTO.dart';

part 'CommentDTO.g.dart';
@JsonSerializable(explicitToJson: true)
class CommentDTO {
  int? id;
  string? content;
  UserDTO? user;
  int? postId;





  CommentDTO({
    this.id,
    this.content,
    this.user,
    this.postId,
  });

  factory CommentDTO.fromJson(Map<String,dynamic> data) => _$CommentDTOFromJson(data);

  Map<String,dynamic> toJson()=>_$CommentDTOToJson(this);
}
