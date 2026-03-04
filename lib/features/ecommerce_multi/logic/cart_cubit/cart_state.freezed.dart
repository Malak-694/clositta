// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartState<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CartState<$T>()';
}


}

/// @nodoc
class $CartStateCopyWith<T,$Res>  {
$CartStateCopyWith(CartState<T> _, $Res Function(CartState<T>) __);
}


/// Adds pattern-matching-related methods to [CartState].
extension CartStatePatterns<T> on CartState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial<T> value)?  initial,TResult Function( Loading<T> value)?  loading,TResult Function( UpdateQuantityLoading<T> value)?  updateQuantityLoading,TResult Function( Success<T> value)?  success,TResult Function( Fail<T> value)?  fail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case UpdateQuantityLoading() when updateQuantityLoading != null:
return updateQuantityLoading(_that);case Success() when success != null:
return success(_that);case Fail() when fail != null:
return fail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial<T> value)  initial,required TResult Function( Loading<T> value)  loading,required TResult Function( UpdateQuantityLoading<T> value)  updateQuantityLoading,required TResult Function( Success<T> value)  success,required TResult Function( Fail<T> value)  fail,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case Loading():
return loading(_that);case UpdateQuantityLoading():
return updateQuantityLoading(_that);case Success():
return success(_that);case Fail():
return fail(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial<T> value)?  initial,TResult? Function( Loading<T> value)?  loading,TResult? Function( UpdateQuantityLoading<T> value)?  updateQuantityLoading,TResult? Function( Success<T> value)?  success,TResult? Function( Fail<T> value)?  fail,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case UpdateQuantityLoading() when updateQuantityLoading != null:
return updateQuantityLoading(_that);case Success() when success != null:
return success(_that);case Fail() when fail != null:
return fail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String productId)?  updateQuantityLoading,TResult Function( T data)?  success,TResult Function( String message)?  fail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case UpdateQuantityLoading() when updateQuantityLoading != null:
return updateQuantityLoading(_that.productId);case Success() when success != null:
return success(_that.data);case Fail() when fail != null:
return fail(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String productId)  updateQuantityLoading,required TResult Function( T data)  success,required TResult Function( String message)  fail,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case Loading():
return loading();case UpdateQuantityLoading():
return updateQuantityLoading(_that.productId);case Success():
return success(_that.data);case Fail():
return fail(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String productId)?  updateQuantityLoading,TResult? Function( T data)?  success,TResult? Function( String message)?  fail,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case UpdateQuantityLoading() when updateQuantityLoading != null:
return updateQuantityLoading(_that.productId);case Success() when success != null:
return success(_that.data);case Fail() when fail != null:
return fail(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial<T> implements CartState<T> {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CartState<$T>.initial()';
}


}




/// @nodoc


class Loading<T> implements CartState<T> {
  const Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CartState<$T>.loading()';
}


}




/// @nodoc


class UpdateQuantityLoading<T> implements CartState<T> {
  const UpdateQuantityLoading(this.productId);
  

 final  String productId;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateQuantityLoadingCopyWith<T, UpdateQuantityLoading<T>> get copyWith => _$UpdateQuantityLoadingCopyWithImpl<T, UpdateQuantityLoading<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateQuantityLoading<T>&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'CartState<$T>.updateQuantityLoading(productId: $productId)';
}


}

/// @nodoc
abstract mixin class $UpdateQuantityLoadingCopyWith<T,$Res> implements $CartStateCopyWith<T, $Res> {
  factory $UpdateQuantityLoadingCopyWith(UpdateQuantityLoading<T> value, $Res Function(UpdateQuantityLoading<T>) _then) = _$UpdateQuantityLoadingCopyWithImpl;
@useResult
$Res call({
 String productId
});




}
/// @nodoc
class _$UpdateQuantityLoadingCopyWithImpl<T,$Res>
    implements $UpdateQuantityLoadingCopyWith<T, $Res> {
  _$UpdateQuantityLoadingCopyWithImpl(this._self, this._then);

  final UpdateQuantityLoading<T> _self;
  final $Res Function(UpdateQuantityLoading<T>) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,}) {
  return _then(UpdateQuantityLoading<T>(
null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class Success<T> implements CartState<T> {
  const Success(this.data);
  

 final  T data;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessCopyWith<T, Success<T>> get copyWith => _$SuccessCopyWithImpl<T, Success<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Success<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'CartState<$T>.success(data: $data)';
}


}

/// @nodoc
abstract mixin class $SuccessCopyWith<T,$Res> implements $CartStateCopyWith<T, $Res> {
  factory $SuccessCopyWith(Success<T> value, $Res Function(Success<T>) _then) = _$SuccessCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$SuccessCopyWithImpl<T,$Res>
    implements $SuccessCopyWith<T, $Res> {
  _$SuccessCopyWithImpl(this._self, this._then);

  final Success<T> _self;
  final $Res Function(Success<T>) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(Success<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class Fail<T> implements CartState<T> {
  const Fail(this.message);
  

 final  String message;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailCopyWith<T, Fail<T>> get copyWith => _$FailCopyWithImpl<T, Fail<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Fail<T>&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'CartState<$T>.fail(message: $message)';
}


}

/// @nodoc
abstract mixin class $FailCopyWith<T,$Res> implements $CartStateCopyWith<T, $Res> {
  factory $FailCopyWith(Fail<T> value, $Res Function(Fail<T>) _then) = _$FailCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$FailCopyWithImpl<T,$Res>
    implements $FailCopyWith<T, $Res> {
  _$FailCopyWithImpl(this._self, this._then);

  final Fail<T> _self;
  final $Res Function(Fail<T>) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(Fail<T>(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
