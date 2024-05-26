import 'package:json_annotation/json_annotation.dart';

part 'StatusDTO.g.dart';
@JsonSerializable(explicitToJson: true)
class StatusDTO {
  String? statusCode;
  String? msg;






  StatusDTO({
    this.statusCode,
    this.msg,
  });

  factory StatusDTO.fromJson(Map<String,dynamic> data) => _$StatusDTOFromJson(data);

  Map<String,dynamic> toJson()=>_$StatusDTOToJson(this);
}
