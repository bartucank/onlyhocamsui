// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NoteDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteDTO _$NoteDTOFromJson(Map<String, dynamic> json) => NoteDTO(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      publishDate: json['publishDate'] as String?,
      formattedDate: json['formattedDate'] as String?,
      user: json['user'] == null
          ? null
          : UserDTO.fromJson(json['user'] as Map<String, dynamic>),
      document: json['document'] == null
          ? null
          : DocumentDTO.fromJson(json['document'] as Map<String, dynamic>),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => ReviewDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPurchased: json['isPurchased'] as bool?,
    );

Map<String, dynamic> _$NoteDTOToJson(NoteDTO instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'publishDate': instance.publishDate,
      'formattedDate': instance.formattedDate,
      'user': instance.user?.toJson(),
      'document': instance.document?.toJson(),
      'reviews': instance.reviews?.map((e) => e.toJson()).toList(),
      'isPurchased': instance.isPurchased,
    };
