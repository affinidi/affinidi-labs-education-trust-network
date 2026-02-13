// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WebSocketMessage _$WebSocketMessageFromJson(Map<String, dynamic> json) {
  return _WebSocketMessage.fromJson(json);
}

/// @nodoc
mixin _$WebSocketMessage {
  String get type => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  int? get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  /// Serializes this WebSocketMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WebSocketMessageCopyWith<WebSocketMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebSocketMessageCopyWith<$Res> {
  factory $WebSocketMessageCopyWith(
    WebSocketMessage value,
    $Res Function(WebSocketMessage) then,
  ) = _$WebSocketMessageCopyWithImpl<$Res, WebSocketMessage>;
  @useResult
  $Res call({
    String type,
    String? message,
    int? timestamp,
    Map<String, dynamic>? data,
  });
}

/// @nodoc
class _$WebSocketMessageCopyWithImpl<$Res, $Val extends WebSocketMessage>
    implements $WebSocketMessageCopyWith<$Res> {
  _$WebSocketMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? message = freezed,
    Object? timestamp = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: freezed == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int?,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WebSocketMessageImplCopyWith<$Res>
    implements $WebSocketMessageCopyWith<$Res> {
  factory _$$WebSocketMessageImplCopyWith(
    _$WebSocketMessageImpl value,
    $Res Function(_$WebSocketMessageImpl) then,
  ) = __$$WebSocketMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String type,
    String? message,
    int? timestamp,
    Map<String, dynamic>? data,
  });
}

/// @nodoc
class __$$WebSocketMessageImplCopyWithImpl<$Res>
    extends _$WebSocketMessageCopyWithImpl<$Res, _$WebSocketMessageImpl>
    implements _$$WebSocketMessageImplCopyWith<$Res> {
  __$$WebSocketMessageImplCopyWithImpl(
    _$WebSocketMessageImpl _value,
    $Res Function(_$WebSocketMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? message = freezed,
    Object? timestamp = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _$WebSocketMessageImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: freezed == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int?,
        data: freezed == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WebSocketMessageImpl implements _WebSocketMessage {
  const _$WebSocketMessageImpl({
    required this.type,
    this.message,
    this.timestamp,
    final Map<String, dynamic>? data,
  }) : _data = data;

  factory _$WebSocketMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebSocketMessageImplFromJson(json);

  @override
  final String type;
  @override
  final String? message;
  @override
  final int? timestamp;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'WebSocketMessage(type: $type, message: $message, timestamp: $timestamp, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebSocketMessageImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    message,
    timestamp,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WebSocketMessageImplCopyWith<_$WebSocketMessageImpl> get copyWith =>
      __$$WebSocketMessageImplCopyWithImpl<_$WebSocketMessageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WebSocketMessageImplToJson(this);
  }
}

abstract class _WebSocketMessage implements WebSocketMessage {
  const factory _WebSocketMessage({
    required final String type,
    final String? message,
    final int? timestamp,
    final Map<String, dynamic>? data,
  }) = _$WebSocketMessageImpl;

  factory _WebSocketMessage.fromJson(Map<String, dynamic> json) =
      _$WebSocketMessageImpl.fromJson;

  @override
  String get type;
  @override
  String? get message;
  @override
  int? get timestamp;
  @override
  Map<String, dynamic>? get data;

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WebSocketMessageImplCopyWith<_$WebSocketMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OobUrlRefreshedMessage _$OobUrlRefreshedMessageFromJson(
  Map<String, dynamic> json,
) {
  return _OobUrlRefreshedMessage.fromJson(json);
}

/// @nodoc
mixin _$OobUrlRefreshedMessage {
  String get type => throw _privateConstructorUsedError;
  String get oobUrl => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this OobUrlRefreshedMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OobUrlRefreshedMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OobUrlRefreshedMessageCopyWith<OobUrlRefreshedMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OobUrlRefreshedMessageCopyWith<$Res> {
  factory $OobUrlRefreshedMessageCopyWith(
    OobUrlRefreshedMessage value,
    $Res Function(OobUrlRefreshedMessage) then,
  ) = _$OobUrlRefreshedMessageCopyWithImpl<$Res, OobUrlRefreshedMessage>;
  @useResult
  $Res call({String type, String oobUrl, String message});
}

/// @nodoc
class _$OobUrlRefreshedMessageCopyWithImpl<
  $Res,
  $Val extends OobUrlRefreshedMessage
>
    implements $OobUrlRefreshedMessageCopyWith<$Res> {
  _$OobUrlRefreshedMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OobUrlRefreshedMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? oobUrl = null,
    Object? message = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            oobUrl: null == oobUrl
                ? _value.oobUrl
                : oobUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OobUrlRefreshedMessageImplCopyWith<$Res>
    implements $OobUrlRefreshedMessageCopyWith<$Res> {
  factory _$$OobUrlRefreshedMessageImplCopyWith(
    _$OobUrlRefreshedMessageImpl value,
    $Res Function(_$OobUrlRefreshedMessageImpl) then,
  ) = __$$OobUrlRefreshedMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String oobUrl, String message});
}

/// @nodoc
class __$$OobUrlRefreshedMessageImplCopyWithImpl<$Res>
    extends
        _$OobUrlRefreshedMessageCopyWithImpl<$Res, _$OobUrlRefreshedMessageImpl>
    implements _$$OobUrlRefreshedMessageImplCopyWith<$Res> {
  __$$OobUrlRefreshedMessageImplCopyWithImpl(
    _$OobUrlRefreshedMessageImpl _value,
    $Res Function(_$OobUrlRefreshedMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OobUrlRefreshedMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? oobUrl = null,
    Object? message = null,
  }) {
    return _then(
      _$OobUrlRefreshedMessageImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        oobUrl: null == oobUrl
            ? _value.oobUrl
            : oobUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OobUrlRefreshedMessageImpl implements _OobUrlRefreshedMessage {
  const _$OobUrlRefreshedMessageImpl({
    required this.type,
    required this.oobUrl,
    required this.message,
  });

  factory _$OobUrlRefreshedMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$OobUrlRefreshedMessageImplFromJson(json);

  @override
  final String type;
  @override
  final String oobUrl;
  @override
  final String message;

  @override
  String toString() {
    return 'OobUrlRefreshedMessage(type: $type, oobUrl: $oobUrl, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OobUrlRefreshedMessageImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.oobUrl, oobUrl) || other.oobUrl == oobUrl) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, oobUrl, message);

  /// Create a copy of OobUrlRefreshedMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OobUrlRefreshedMessageImplCopyWith<_$OobUrlRefreshedMessageImpl>
  get copyWith =>
      __$$OobUrlRefreshedMessageImplCopyWithImpl<_$OobUrlRefreshedMessageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OobUrlRefreshedMessageImplToJson(this);
  }
}

abstract class _OobUrlRefreshedMessage implements OobUrlRefreshedMessage {
  const factory _OobUrlRefreshedMessage({
    required final String type,
    required final String oobUrl,
    required final String message,
  }) = _$OobUrlRefreshedMessageImpl;

  factory _OobUrlRefreshedMessage.fromJson(Map<String, dynamic> json) =
      _$OobUrlRefreshedMessageImpl.fromJson;

  @override
  String get type;
  @override
  String get oobUrl;
  @override
  String get message;

  /// Create a copy of OobUrlRefreshedMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OobUrlRefreshedMessageImplCopyWith<_$OobUrlRefreshedMessageImpl>
  get copyWith => throw _privateConstructorUsedError;
}

VdspResponseMessage _$VdspResponseMessageFromJson(Map<String, dynamic> json) {
  return _VdspResponseMessage.fromJson(json);
}

/// @nodoc
mixin _$VdspResponseMessage {
  String get status =>
      throw _privateConstructorUsedError; // 'success' or 'failure'
  bool get completed => throw _privateConstructorUsedError;
  String get channelDid => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  bool get presentationAndCredentialsAreValid =>
      throw _privateConstructorUsedError;

  /// Serializes this VdspResponseMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VdspResponseMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VdspResponseMessageCopyWith<VdspResponseMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VdspResponseMessageCopyWith<$Res> {
  factory $VdspResponseMessageCopyWith(
    VdspResponseMessage value,
    $Res Function(VdspResponseMessage) then,
  ) = _$VdspResponseMessageCopyWithImpl<$Res, VdspResponseMessage>;
  @useResult
  $Res call({
    String status,
    bool completed,
    String channelDid,
    String message,
    bool presentationAndCredentialsAreValid,
  });
}

/// @nodoc
class _$VdspResponseMessageCopyWithImpl<$Res, $Val extends VdspResponseMessage>
    implements $VdspResponseMessageCopyWith<$Res> {
  _$VdspResponseMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VdspResponseMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? completed = null,
    Object? channelDid = null,
    Object? message = null,
    Object? presentationAndCredentialsAreValid = null,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
            channelDid: null == channelDid
                ? _value.channelDid
                : channelDid // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            presentationAndCredentialsAreValid:
                null == presentationAndCredentialsAreValid
                ? _value.presentationAndCredentialsAreValid
                : presentationAndCredentialsAreValid // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VdspResponseMessageImplCopyWith<$Res>
    implements $VdspResponseMessageCopyWith<$Res> {
  factory _$$VdspResponseMessageImplCopyWith(
    _$VdspResponseMessageImpl value,
    $Res Function(_$VdspResponseMessageImpl) then,
  ) = __$$VdspResponseMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String status,
    bool completed,
    String channelDid,
    String message,
    bool presentationAndCredentialsAreValid,
  });
}

/// @nodoc
class __$$VdspResponseMessageImplCopyWithImpl<$Res>
    extends _$VdspResponseMessageCopyWithImpl<$Res, _$VdspResponseMessageImpl>
    implements _$$VdspResponseMessageImplCopyWith<$Res> {
  __$$VdspResponseMessageImplCopyWithImpl(
    _$VdspResponseMessageImpl _value,
    $Res Function(_$VdspResponseMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VdspResponseMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? completed = null,
    Object? channelDid = null,
    Object? message = null,
    Object? presentationAndCredentialsAreValid = null,
  }) {
    return _then(
      _$VdspResponseMessageImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
        channelDid: null == channelDid
            ? _value.channelDid
            : channelDid // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        presentationAndCredentialsAreValid:
            null == presentationAndCredentialsAreValid
            ? _value.presentationAndCredentialsAreValid
            : presentationAndCredentialsAreValid // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VdspResponseMessageImpl implements _VdspResponseMessage {
  const _$VdspResponseMessageImpl({
    required this.status,
    required this.completed,
    required this.channelDid,
    required this.message,
    required this.presentationAndCredentialsAreValid,
  });

  factory _$VdspResponseMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$VdspResponseMessageImplFromJson(json);

  @override
  final String status;
  // 'success' or 'failure'
  @override
  final bool completed;
  @override
  final String channelDid;
  @override
  final String message;
  @override
  final bool presentationAndCredentialsAreValid;

  @override
  String toString() {
    return 'VdspResponseMessage(status: $status, completed: $completed, channelDid: $channelDid, message: $message, presentationAndCredentialsAreValid: $presentationAndCredentialsAreValid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VdspResponseMessageImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.channelDid, channelDid) ||
                other.channelDid == channelDid) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(
                  other.presentationAndCredentialsAreValid,
                  presentationAndCredentialsAreValid,
                ) ||
                other.presentationAndCredentialsAreValid ==
                    presentationAndCredentialsAreValid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    completed,
    channelDid,
    message,
    presentationAndCredentialsAreValid,
  );

  /// Create a copy of VdspResponseMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VdspResponseMessageImplCopyWith<_$VdspResponseMessageImpl> get copyWith =>
      __$$VdspResponseMessageImplCopyWithImpl<_$VdspResponseMessageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VdspResponseMessageImplToJson(this);
  }
}

abstract class _VdspResponseMessage implements VdspResponseMessage {
  const factory _VdspResponseMessage({
    required final String status,
    required final bool completed,
    required final String channelDid,
    required final String message,
    required final bool presentationAndCredentialsAreValid,
  }) = _$VdspResponseMessageImpl;

  factory _VdspResponseMessage.fromJson(Map<String, dynamic> json) =
      _$VdspResponseMessageImpl.fromJson;

  @override
  String get status; // 'success' or 'failure'
  @override
  bool get completed;
  @override
  String get channelDid;
  @override
  String get message;
  @override
  bool get presentationAndCredentialsAreValid;

  /// Create a copy of VdspResponseMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VdspResponseMessageImplCopyWith<_$VdspResponseMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
