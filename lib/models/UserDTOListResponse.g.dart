// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserDTOListResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDTOListResponse _$UserDTOListResponseFromJson(Map<String, dynamic> json) =>
    UserDTOListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => UserDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserDTOListResponseToJson(
        UserDTOListResponse instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };
