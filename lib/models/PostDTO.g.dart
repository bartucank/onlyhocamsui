// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDTO _$PostDTOFromJson(Map<String, dynamic> json) => PostDTO(
      id: (json['id'] as num?)?.toInt(),
      content: json['content'] as String?,
      publishDate: json['publishDate'] as String?,
      formattedDate: json['formattedDate'] as String?,
      user: json['user'] == null
          ? null
          : UserDTO.fromJson(json['user'] as Map<String, dynamic>),
      categoryId: (json['categoryId'] as num?)?.toInt(),
      categoryName: json['categoryName'] as String?,
      documents: (json['documents'] as List<dynamic>?)
          ?.map((e) => DocumentDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => LikeLogDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLiked: json['isLiked'] as bool?,
      isDisliked: json['isDisliked'] as bool?,
    );

Map<String, dynamic> _$PostDTOToJson(PostDTO instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'publishDate': instance.publishDate,
      'formattedDate': instance.formattedDate,
      'user': instance.user?.toJson(),
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'documents': instance.documents?.map((e) => e.toJson()).toList(),
      'comments': instance.comments?.map((e) => e.toJson()).toList(),
      'actions': instance.actions?.map((e) => e.toJson()).toList(),
      'isLiked': instance.isLiked,
      'isDisliked': instance.isDisliked,
    };
