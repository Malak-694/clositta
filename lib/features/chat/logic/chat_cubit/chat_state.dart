
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/chat_message_model.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState<T> with _$ChatState<T> {
  const factory ChatState.initial()                  = _Initial;
  const factory ChatState.loading()                  = _Loading;
  const factory ChatState.success(T data)            = _Success<T>;
  const factory ChatState.fail(String message)       = _Fail;
}