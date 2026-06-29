import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:chicora/features/notifications/data/models/notification_model.dart';

part 'notification_state.freezed.dart';

@freezed
class NotificationState<T> with _$NotificationState<T> {
  const factory NotificationState.initial()            = _Initial;
  const factory NotificationState.loading()            = _Loading;
  const factory NotificationState.success(T data)      = _Success<T>;
  const factory NotificationState.fail(String message) = _Fail;
}