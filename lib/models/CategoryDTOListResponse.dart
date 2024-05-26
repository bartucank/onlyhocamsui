import 'package:json_annotation/json_annotation.dart';

import 'CategoryDTO.dart';
import 'UserDTO.dart';

part 'CategoryDTOListResponse.g.dart';
@JsonSerializable(explicitToJson: true)
class CategoryDTOListResponse {
  List<CategoryDTO> data;





  CategoryDTOListResponse({
    required this.data
  });

  factory CategoryDTOListResponse.fromJson(Map<String,dynamic> data) => _$CategoryDTOListResponseFromJson(data);

  Map<String,dynamic> toJson()=>_$CategoryDTOListResponseToJson(this);
}
