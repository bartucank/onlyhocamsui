import 'package:json_annotation/json_annotation.dart';

import 'UserDTO.dart';
import 'UserDTO.dart';

part 'UserDTOListResponse.g.dart';
@JsonSerializable(explicitToJson: true)
class UserDTOListResponse {
  List<UserDTO> data;





  UserDTOListResponse({
    required this.data
  });

  factory UserDTOListResponse.fromJson(Map<String,dynamic> data) => _$UserDTOListResponseFromJson(data);

  Map<String,dynamic> toJson()=>_$UserDTOListResponseToJson(this);
}
