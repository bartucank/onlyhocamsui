// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LikeLogDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeLogDTO _$LikeLogDTOFromJson(Map<String, dynamic> json) => LikeLogDTO(
      id: (json['id'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : UserDTO.fromJson(json['user'] as Map<String, dynamic>),
      postId: (json['postId'] as num?)?.toInt(),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$LikeLogDTOToJson(LikeLogDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user?.toJson(),
      'postId': instance.postId,
      'type': instance.type,
    };
