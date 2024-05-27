import 'package:json_annotation/json_annotation.dart';

import 'NoteDTO.dart';
import 'UserDTO.dart';

part 'NoteDTOListResponse.g.dart';
@JsonSerializable(explicitToJson: true)
class NoteDTOListResponse {
  List<NoteDTO> data;





  NoteDTOListResponse({
    required this.data
  });

  factory NoteDTOListResponse.fromJson(Map<String,dynamic> data) => _$NoteDTOListResponseFromJson(data);

  Map<String,dynamic> toJson()=>_$NoteDTOListResponseToJson(this);
}
