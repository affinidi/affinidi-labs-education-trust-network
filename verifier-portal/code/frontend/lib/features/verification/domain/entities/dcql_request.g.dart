// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dcql_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DcqlRequestImpl _$$DcqlRequestImplFromJson(Map<String, dynamic> json) =>
    _$DcqlRequestImpl(
      clientId: json['clientId'] as String,
      holderChannelDid: json['holderChannelDid'] as String,
      payloadId: json['payloadId'] as String,
      dcqlQuery: json['dcqlQuery'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$DcqlRequestImplToJson(_$DcqlRequestImpl instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'holderChannelDid': instance.holderChannelDid,
      'payloadId': instance.payloadId,
      'dcqlQuery': instance.dcqlQuery,
    };

_$DcqlResponseImpl _$$DcqlResponseImplFromJson(Map<String, dynamic> json) =>
    _$DcqlResponseImpl(
      status: json['status'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$$DcqlResponseImplToJson(_$DcqlResponseImpl instance) =>
    <String, dynamic>{'status': instance.status, 'message': instance.message};
