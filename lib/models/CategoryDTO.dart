import 'package:json_annotation/json_annotation.dart';

import 'UserDTO.dart';

part 'CategoryDTO.g.dart';
@JsonSerializable(explicitToJson: true)
class CategoryDTO {
  int? id;
  String? name;





  CategoryDTO({
    this.id,
    this.name
  });

  factory CategoryDTO.fromJson(Map<String,dynamic> data) => _$CategoryDTOFromJson(data);

  Map<String,dynamic> toJson()=>_$CategoryDTOToJson(this);
}
