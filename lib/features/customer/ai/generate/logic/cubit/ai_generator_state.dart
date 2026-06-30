import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_generator_state.freezed.dart';

@freezed
abstract class AiGeneratorState<T> with _$AiGeneratorState<T> {
  const factory AiGeneratorState.initial() = _Initial;
  const factory AiGeneratorState.loading() = Loading;
  const factory AiGeneratorState.success(T data) = Success<T>;
  const factory AiGeneratorState.fail(String message) = Fail;
}
