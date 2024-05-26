import 'package:json_annotation/json_annotation.dart';

part 'DocumentDTO.g.dart';
@JsonSerializable(explicitToJson: true)
class DocumentDTO {
  int? id;
  string? fileName;
  string? fileType;
  String? type;
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
