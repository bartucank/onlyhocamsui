// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JWTResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JWTResponse _$JWTResponseFromJson(Map<String, dynamic> json) => JWTResponse(
      jwt: json['jwt'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$JWTResponseToJson(JWTResponse instance) =>
    <String, dynamic>{
      'jwt': instance.jwt,
      'role': instance.role,
    };
