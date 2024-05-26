// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDTO _$UserDTOFromJson(Map<String, dynamic> json) => UserDTO(
      (json['id'] as num?)?.toInt(),
      json['role'] as String?,
      json['roleStr'] as String?,
      json['name'] as String?,
      json['username'] as String?,
      json['email'] as String?,
    );

Map<String, dynamic> _$UserDTOToJson(UserDTO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'roleStr': instance.roleStr,
      'email': instance.email,
      'username': instance.username,
    };
