import 'package:json_annotation/json_annotation.dart';

import 'DocumentDTO.dart';
import 'ReviewDTO.dart';
import 'UserDTO.dart';

part 'NoteDTO.g.dart';
@JsonSerializable(explicitToJson: true)
class NoteDTO {
  int? id;

   String? title;
  String? publishDate;
   String? formattedDate;
   UserDTO? user;
   DocumentDTO? document;
   List<ReviewDTO>? reviews;
   bool? isPurchased;




  NoteDTO({
    this.id,
    this.title,
    this.publishDate,
    this.formattedDate,
    this.user,
    this.document,
    this.reviews,
    this.isPurchased
  });

  factory NoteDTO.fromJson(Map<String,dynamic> data) => _$NoteDTOFromJson(data);

  Map<String,dynamic> toJson()=>_$NoteDTOToJson(this);
}
