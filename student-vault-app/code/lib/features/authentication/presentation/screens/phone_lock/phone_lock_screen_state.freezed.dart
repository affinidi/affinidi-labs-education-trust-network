// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_lock_screen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PhoneLockState {

 bool get isLoading; bool get isError; bool get isAppResumed; bool get hasAttemptedAuth; String? get error;
/// Create a copy of PhoneLockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneLockStateCopyWith<PhoneLockState> get copyWith => _$PhoneLockStateCopyWithImpl<PhoneLockState>(this as PhoneLockState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneLockState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.isAppResumed, isAppResumed) || other.isAppResumed == isAppResumed)&&(identical(other.hasAttemptedAuth, hasAttemptedAuth) || other.hasAttemptedAuth == hasAttemptedAuth)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isError,isAppResumed,hasAttemptedAuth,error);

@override
String toString() {
  return 'PhoneLockState(isLoading: $isLoading, isError: $isError, isAppResumed: $isAppResumed, hasAttemptedAuth: $hasAttemptedAuth, error: $error)';
}


}

/// @nodoc
abstract mixin class $PhoneLockStateCopyWith<$Res>  {
  factory $PhoneLockStateCopyWith(PhoneLockState value, $Res Function(PhoneLockState) _then) = _$PhoneLockStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isError, bool isAppResumed, bool hasAttemptedAuth, String? error
});




}
/// @nodoc
class _$PhoneLockStateCopyWithImpl<$Res>
    implements $PhoneLockStateCopyWith<$Res> {
  _$PhoneLockStateCopyWithImpl(this._self, this._then);

  final PhoneLockState _self;
  final $Res Function(PhoneLockState) _then;

/// Create a copy of PhoneLockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isError = null,Object? isAppResumed = null,Object? hasAttemptedAuth = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,isAppResumed: null == isAppResumed ? _self.isAppResumed : isAppResumed // ignore: cast_nullable_to_non_nullable
as bool,hasAttemptedAuth: null == hasAttemptedAuth ? _self.hasAttemptedAuth : hasAttemptedAuth // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhoneLockState].
extension PhoneLockStatePatterns on PhoneLockState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhoneLockState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhoneLockState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhoneLockState value)  $default,){
final _that = this;
switch (_that) {
case _PhoneLockState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhoneLockState value)?  $default,){
final _that = this;
switch (_that) {
case _PhoneLockState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isError,  bool isAppResumed,  bool hasAttemptedAuth,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhoneLockState() when $default != null:
return $default(_that.isLoading,_that.isError,_that.isAppResumed,_that.hasAttemptedAuth,_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isError,  bool isAppResumed,  bool hasAttemptedAuth,  String? error)  $default,) {final _that = this;
switch (_that) {
case _PhoneLockState():
return $default(_that.isLoading,_that.isError,_that.isAppResumed,_that.hasAttemptedAuth,_that.error);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isError,  bool isAppResumed,  bool hasAttemptedAuth,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _PhoneLockState() when $default != null:
return $default(_that.isLoading,_that.isError,_that.isAppResumed,_that.hasAttemptedAuth,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _PhoneLockState implements PhoneLockState {
  const _PhoneLockState({this.isLoading = false, this.isError = false, this.isAppResumed = true, this.hasAttemptedAuth = false, this.error});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isError;
@override@JsonKey() final  bool isAppResumed;
@override@JsonKey() final  bool hasAttemptedAuth;
@override final  String? error;

/// Create a copy of PhoneLockState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneLockStateCopyWith<_PhoneLockState> get copyWith => __$PhoneLockStateCopyWithImpl<_PhoneLockState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneLockState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.isAppResumed, isAppResumed) || other.isAppResumed == isAppResumed)&&(identical(other.hasAttemptedAuth, hasAttemptedAuth) || other.hasAttemptedAuth == hasAttemptedAuth)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isError,isAppResumed,hasAttemptedAuth,error);

@override
String toString() {
  return 'PhoneLockState(isLoading: $isLoading, isError: $isError, isAppResumed: $isAppResumed, hasAttemptedAuth: $hasAttemptedAuth, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PhoneLockStateCopyWith<$Res> implements $PhoneLockStateCopyWith<$Res> {
  factory _$PhoneLockStateCopyWith(_PhoneLockState value, $Res Function(_PhoneLockState) _then) = __$PhoneLockStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isError, bool isAppResumed, bool hasAttemptedAuth, String? error
});




}
/// @nodoc
class __$PhoneLockStateCopyWithImpl<$Res>
    implements _$PhoneLockStateCopyWith<$Res> {
  __$PhoneLockStateCopyWithImpl(this._self, this._then);

  final _PhoneLockState _self;
  final $Res Function(_PhoneLockState) _then;

/// Create a copy of PhoneLockState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isError = null,Object? isAppResumed = null,Object? hasAttemptedAuth = null,Object? error = freezed,}) {
  return _then(_PhoneLockState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,isAppResumed: null == isAppResumed ? _self.isAppResumed : isAppResumed // ignore: cast_nullable_to_non_nullable
as bool,hasAttemptedAuth: null == hasAttemptedAuth ? _self.hasAttemptedAuth : hasAttemptedAuth // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
