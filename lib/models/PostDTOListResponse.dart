import 'package:json_annotation/json_annotation.dart';

import 'PostDTO.dart';
import 'UserDTO.dart';

part 'PostDTOListResponse.g.dart';
@JsonSerializable(explicitToJson: true)
class PostDTOListResponse {
  List<PostDTO> data;





  PostDTOListResponse({
    required this.data
  });

  factory PostDTOListResponse.fromJson(Map<String,dynamic> data) => _$PostDTOListResponseFromJson(data);

  Map<String,dynamic> toJson()=>_$PostDTOListResponseToJson(this);
}
