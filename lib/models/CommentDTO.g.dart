// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentDTO _$CommentDTOFromJson(Map<String, dynamic> json) => CommentDTO(
      id: (json['id'] as num?)?.toInt(),
      content: json['content'] as String?,
      user: json['user'] == null
          ? null
          : UserDTO.fromJson(json['user'] as Map<String, dynamic>),
      postId: (json['postId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CommentDTOToJson(CommentDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'user': instance.user?.toJson(),
      'postId': instance.postId,
    };
