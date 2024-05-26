import 'package:json_annotation/json_annotation.dart';

import 'UserDTO.dart';

part 'LikeLogDTO.g.dart';
@JsonSerializable(explicitToJson: true)
class LikeLogDTO {
  int? id;
  UserDTO? user;
  int? postId;
  String? type;



  LikeLogDTO({
    this.id,
    this.user,
    this.postId,
    this.type
  });

  factory LikeLogDTO.fromJson(Map<String,dynamic> data) => _$LikeLogDTOFromJson(data);

  Map<String,dynamic> toJson()=>_$LikeLogDTOToJson(this);
}
