import 'package:json_annotation/json_annotation.dart';

import 'UserDTO.dart';

part 'ReviewDTO.g.dart';
@JsonSerializable(explicitToJson: true)
class ReviewDTO {
   int? id;
   String? content;
   UserDTO? user;
   int? noteId;
   String? type;
   bool? canDelete;



  ReviewDTO({
     this.id,
    this.content,
    this.user,
    this.noteId,
    this.type,
    this.canDelete
  });

  factory ReviewDTO.fromJson(Map<String,dynamic> data) => _$ReviewDTOFromJson(data);

  Map<String,dynamic> toJson()=>_$ReviewDTOToJson(this);
}
