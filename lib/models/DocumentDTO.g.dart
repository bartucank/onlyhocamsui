// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DocumentDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentDTO _$DocumentDTOFromJson(Map<String, dynamic> json) => DocumentDTO(
      id: (json['id'] as num?)?.toInt(),
      fileName: json['fileName'] as String?,
      fileType: json['fileType'] as String?,
      type: json['type'] as String?,
      data: const Uint8ListConverter().fromJson(json['data'] as String?),
    );

Map<String, dynamic> _$DocumentDTOToJson(DocumentDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'fileType': instance.fileType,
      'type': instance.type,
      'data': const Uint8ListConverter().toJson(instance.data),
    };
