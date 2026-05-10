import 'package:freezed_annotation/freezed_annotation.dart';
part 'conversations_state.freezed.dart';

@freezed
class ConversationsState<T> with _$ConversationsState<T> {
  const factory ConversationsState.initial()        = _Initial;
  const factory ConversationsState.loading()        = _Loading;
  const factory ConversationsState.success(T data)  = _Success;
  const factory ConversationsState.fail(String msg) = _Fail;
}