// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReviewDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewDTO _$ReviewDTOFromJson(Map<String, dynamic> json) => ReviewDTO(
      id: (json['id'] as num?)?.toInt(),
      content: json['content'] as String?,
      user: json['user'] == null
          ? null
          : UserDTO.fromJson(json['user'] as Map<String, dynamic>),
      noteId: (json['noteId'] as num?)?.toInt(),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ReviewDTOToJson(ReviewDTO instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'user': instance.user?.toJson(),
      'noteId': instance.noteId,
      'type': instance.type,
    };
