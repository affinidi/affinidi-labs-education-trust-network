// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dcql_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DcqlRequest _$DcqlRequestFromJson(Map<String, dynamic> json) {
  return _DcqlRequest.fromJson(json);
}

/// @nodoc
mixin _$DcqlRequest {
  String get clientId => throw _privateConstructorUsedError;
  String get holderChannelDid => throw _privateConstructorUsedError;
  String get payloadId => throw _privateConstructorUsedError;
  Map<String, dynamic> get dcqlQuery => throw _privateConstructorUsedError;

  /// Serializes this DcqlRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DcqlRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DcqlRequestCopyWith<DcqlRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DcqlRequestCopyWith<$Res> {
  factory $DcqlRequestCopyWith(
    DcqlRequest value,
    $Res Function(DcqlRequest) then,
  ) = _$DcqlRequestCopyWithImpl<$Res, DcqlRequest>;
  @useResult
  $Res call({
    String clientId,
    String holderChannelDid,
    String payloadId,
    Map<String, dynamic> dcqlQuery,
  });
}

/// @nodoc
class _$DcqlRequestCopyWithImpl<$Res, $Val extends DcqlRequest>
    implements $DcqlRequestCopyWith<$Res> {
  _$DcqlRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DcqlRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? holderChannelDid = null,
    Object? payloadId = null,
    Object? dcqlQuery = null,
  }) {
    return _then(
      _value.copyWith(
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            holderChannelDid: null == holderChannelDid
                ? _value.holderChannelDid
                : holderChannelDid // ignore: cast_nullable_to_non_nullable
                      as String,
            payloadId: null == payloadId
                ? _value.payloadId
                : payloadId // ignore: cast_nullable_to_non_nullable
                      as String,
            dcqlQuery: null == dcqlQuery
                ? _value.dcqlQuery
                : dcqlQuery // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DcqlRequestImplCopyWith<$Res>
    implements $DcqlRequestCopyWith<$Res> {
  factory _$$DcqlRequestImplCopyWith(
    _$DcqlRequestImpl value,
    $Res Function(_$DcqlRequestImpl) then,
  ) = __$$DcqlRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String clientId,
    String holderChannelDid,
    String payloadId,
    Map<String, dynamic> dcqlQuery,
  });
}

/// @nodoc
class __$$DcqlRequestImplCopyWithImpl<$Res>
    extends _$DcqlRequestCopyWithImpl<$Res, _$DcqlRequestImpl>
    implements _$$DcqlRequestImplCopyWith<$Res> {
  __$$DcqlRequestImplCopyWithImpl(
    _$DcqlRequestImpl _value,
    $Res Function(_$DcqlRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DcqlRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? holderChannelDid = null,
    Object? payloadId = null,
    Object? dcqlQuery = null,
  }) {
    return _then(
      _$DcqlRequestImpl(
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        holderChannelDid: null == holderChannelDid
            ? _value.holderChannelDid
            : holderChannelDid // ignore: cast_nullable_to_non_nullable
                  as String,
        payloadId: null == payloadId
            ? _value.payloadId
            : payloadId // ignore: cast_nullable_to_non_nullable
                  as String,
        dcqlQuery: null == dcqlQuery
            ? _value._dcqlQuery
            : dcqlQuery // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DcqlRequestImpl implements _DcqlRequest {
  const _$DcqlRequestImpl({
    required this.clientId,
    required this.holderChannelDid,
    required this.payloadId,
    required final Map<String, dynamic> dcqlQuery,
  }) : _dcqlQuery = dcqlQuery;

  factory _$DcqlRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$DcqlRequestImplFromJson(json);

  @override
  final String clientId;
  @override
  final String holderChannelDid;
  @override
  final String payloadId;
  final Map<String, dynamic> _dcqlQuery;
  @override
  Map<String, dynamic> get dcqlQuery {
    if (_dcqlQuery is EqualUnmodifiableMapView) return _dcqlQuery;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dcqlQuery);
  }

  @override
  String toString() {
    return 'DcqlRequest(clientId: $clientId, holderChannelDid: $holderChannelDid, payloadId: $payloadId, dcqlQuery: $dcqlQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DcqlRequestImpl &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.holderChannelDid, holderChannelDid) ||
                other.holderChannelDid == holderChannelDid) &&
            (identical(other.payloadId, payloadId) ||
                other.payloadId == payloadId) &&
            const DeepCollectionEquality().equals(
              other._dcqlQuery,
              _dcqlQuery,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    clientId,
    holderChannelDid,
    payloadId,
    const DeepCollectionEquality().hash(_dcqlQuery),
  );

  /// Create a copy of DcqlRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DcqlRequestImplCopyWith<_$DcqlRequestImpl> get copyWith =>
      __$$DcqlRequestImplCopyWithImpl<_$DcqlRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DcqlRequestImplToJson(this);
  }
}

abstract class _DcqlRequest implements DcqlRequest {
  const factory _DcqlRequest({
    required final String clientId,
    required final String holderChannelDid,
    required final String payloadId,
    required final Map<String, dynamic> dcqlQuery,
  }) = _$DcqlRequestImpl;

  factory _DcqlRequest.fromJson(Map<String, dynamic> json) =
      _$DcqlRequestImpl.fromJson;

  @override
  String get clientId;
  @override
  String get holderChannelDid;
  @override
  String get payloadId;
  @override
  Map<String, dynamic> get dcqlQuery;

  /// Create a copy of DcqlRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DcqlRequestImplCopyWith<_$DcqlRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DcqlResponse _$DcqlResponseFromJson(Map<String, dynamic> json) {
  return _DcqlResponse.fromJson(json);
}

/// @nodoc
mixin _$DcqlResponse {
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this DcqlResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DcqlResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DcqlResponseCopyWith<DcqlResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DcqlResponseCopyWith<$Res> {
  factory $DcqlResponseCopyWith(
    DcqlResponse value,
    $Res Function(DcqlResponse) then,
  ) = _$DcqlResponseCopyWithImpl<$Res, DcqlResponse>;
  @useResult
  $Res call({String status, String message});
}

/// @nodoc
class _$DcqlResponseCopyWithImpl<$Res, $Val extends DcqlResponse>
    implements $DcqlResponseCopyWith<$Res> {
  _$DcqlResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DcqlResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? message = null}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
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
abstract class _$$DcqlResponseImplCopyWith<$Res>
    implements $DcqlResponseCopyWith<$Res> {
  factory _$$DcqlResponseImplCopyWith(
    _$DcqlResponseImpl value,
    $Res Function(_$DcqlResponseImpl) then,
  ) = __$$DcqlResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, String message});
}

/// @nodoc
class __$$DcqlResponseImplCopyWithImpl<$Res>
    extends _$DcqlResponseCopyWithImpl<$Res, _$DcqlResponseImpl>
    implements _$$DcqlResponseImplCopyWith<$Res> {
  __$$DcqlResponseImplCopyWithImpl(
    _$DcqlResponseImpl _value,
    $Res Function(_$DcqlResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DcqlResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? message = null}) {
    return _then(
      _$DcqlResponseImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
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
class _$DcqlResponseImpl implements _DcqlResponse {
  const _$DcqlResponseImpl({required this.status, required this.message});

  factory _$DcqlResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DcqlResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String message;

  @override
  String toString() {
    return 'DcqlResponse(status: $status, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DcqlResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, message);

  /// Create a copy of DcqlResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DcqlResponseImplCopyWith<_$DcqlResponseImpl> get copyWith =>
      __$$DcqlResponseImplCopyWithImpl<_$DcqlResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DcqlResponseImplToJson(this);
  }
}

abstract class _DcqlResponse implements DcqlResponse {
  const factory _DcqlResponse({
    required final String status,
    required final String message,
  }) = _$DcqlResponseImpl;

  factory _DcqlResponse.fromJson(Map<String, dynamic> json) =
      _$DcqlResponseImpl.fromJson;

  @override
  String get status;
  @override
  String get message;

  /// Create a copy of DcqlResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DcqlResponseImplCopyWith<_$DcqlResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
