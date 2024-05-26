// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostDTOListResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDTOListResponse _$PostDTOListResponseFromJson(Map<String, dynamic> json) =>
    PostDTOListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => PostDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostDTOListResponseToJson(
        PostDTOListResponse instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };
