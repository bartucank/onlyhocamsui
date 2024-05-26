import 'package:json_annotation/json_annotation.dart';

part 'JWTResponse.g.dart';
@JsonSerializable(explicitToJson: true)
class JWTResponse {
  string? jwt;
  string? role;





  JWTResponse({
    this.jwt,
    this.role,
  });

  factory JWTResponse.fromJson(Map<String,dynamic> data) => _$JWTResponseFromJson(data);

  Map<String,dynamic> toJson()=>_$JWTResponseToJson(this);
}
