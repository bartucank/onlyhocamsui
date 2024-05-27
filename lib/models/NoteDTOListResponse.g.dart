// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NoteDTOListResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteDTOListResponse _$NoteDTOListResponseFromJson(Map<String, dynamic> json) =>
    NoteDTOListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => NoteDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NoteDTOListResponseToJson(
        NoteDTOListResponse instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };
