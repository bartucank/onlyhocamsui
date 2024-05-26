import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

import 'Uint8ListConverter.dart';

part 'DocumentDTO.g.dart';
@JsonSerializable(explicitToJson: true)
class DocumentDTO {
  int? id;
  String? fileName;
  String? fileType;
  String? type;

  @Uint8ListConverter()
  Uint8List? data;




  DocumentDTO({
    this.id,
    this.fileName,
    this.fileType,
    this.type,
    this.data,
  });

  factory DocumentDTO.fromJson(Map<String,dynamic> data) => _$DocumentDTOFromJson(data);

  Map<String,dynamic> toJson()=>_$DocumentDTOToJson(this);
}
