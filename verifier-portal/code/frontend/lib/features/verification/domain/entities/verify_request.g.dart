// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerifyRequestImpl _$$VerifyRequestImplFromJson(Map<String, dynamic> json) =>
    _$VerifyRequestImpl(data: json['data'] as String);

Map<String, dynamic> _$$VerifyRequestImplToJson(_$VerifyRequestImpl instance) =>
    <String, dynamic>{'data': instance.data};

_$VerifyResponseImpl _$$VerifyResponseImplFromJson(Map<String, dynamic> json) =>
    _$VerifyResponseImpl(
      isValid: json['isValid'] as bool,
      errors: (json['errors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      warnings: (json['warnings'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$VerifyResponseImplToJson(
  _$VerifyResponseImpl instance,
) => <String, dynamic>{
  'isValid': instance.isValid,
  'errors': instance.errors,
  'warnings': instance.warnings,
};
