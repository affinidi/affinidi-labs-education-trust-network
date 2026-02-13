// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebSocketMessageImpl _$$WebSocketMessageImplFromJson(
  Map<String, dynamic> json,
) => _$WebSocketMessageImpl(
  type: json['type'] as String,
  message: json['message'] as String?,
  timestamp: (json['timestamp'] as num?)?.toInt(),
  data: json['data'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$WebSocketMessageImplToJson(
  _$WebSocketMessageImpl instance,
) => <String, dynamic>{
  'type': instance.type,
  'message': instance.message,
  'timestamp': instance.timestamp,
  'data': instance.data,
};

_$OobUrlRefreshedMessageImpl _$$OobUrlRefreshedMessageImplFromJson(
  Map<String, dynamic> json,
) => _$OobUrlRefreshedMessageImpl(
  type: json['type'] as String,
  oobUrl: json['oobUrl'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$$OobUrlRefreshedMessageImplToJson(
  _$OobUrlRefreshedMessageImpl instance,
) => <String, dynamic>{
  'type': instance.type,
  'oobUrl': instance.oobUrl,
  'message': instance.message,
};

_$VdspResponseMessageImpl _$$VdspResponseMessageImplFromJson(
  Map<String, dynamic> json,
) => _$VdspResponseMessageImpl(
  status: json['status'] as String,
  completed: json['completed'] as bool,
  channelDid: json['channelDid'] as String,
  message: json['message'] as String,
  presentationAndCredentialsAreValid:
      json['presentationAndCredentialsAreValid'] as bool,
);

Map<String, dynamic> _$$VdspResponseMessageImplToJson(
  _$VdspResponseMessageImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'completed': instance.completed,
  'channelDid': instance.channelDid,
  'message': instance.message,
  'presentationAndCredentialsAreValid':
      instance.presentationAndCredentialsAreValid,
};
