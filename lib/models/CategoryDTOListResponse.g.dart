// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CategoryDTOListResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDTOListResponse _$CategoryDTOListResponseFromJson(
        Map<String, dynamic> json) =>
    CategoryDTOListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => CategoryDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryDTOListResponseToJson(
        CategoryDTOListResponse instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };
