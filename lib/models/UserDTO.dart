import 'package:json_annotation/json_annotation.dart';

part 'UserDTO.g.dart';
@JsonSerializable(explicitToJson: true)
class UserDTO {
  int? id;
  String? role;
  String? roleStr;
  String? name;
  String? username;
  String? email;



  UserDTO(this.id,
      this.role,
      this.roleStr,
      this.name,
      this.username,
      this.email);

  factory UserDTO.fromJson(Map<String,dynamic> data) => _$UserDTOFromJson(data);

  Map<String,dynamic> toJson()=>_$UserDTOToJson(this);
}
