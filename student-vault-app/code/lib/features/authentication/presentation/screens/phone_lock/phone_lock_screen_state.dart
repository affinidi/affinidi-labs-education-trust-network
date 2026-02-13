import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_lock_screen_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
abstract class PhoneLockState with _$PhoneLockState {
  const factory PhoneLockState({
    @Default(false) bool isLoading,
    @Default(false) bool isError,
    @Default(true) bool isAppResumed,
    @Default(false) bool hasAttemptedAuth,
    String? error,
  }) = _PhoneLockState;
}
