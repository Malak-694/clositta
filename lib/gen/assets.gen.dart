// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/AI.svg
  String get ai => 'assets/images/AI.svg';

  /// File path: assets/images/Person.svg
  String get person => 'assets/images/Person.svg';

  /// File path: assets/images/Scissors.svg
  String get scissors => 'assets/images/Scissors.svg';

  /// File path: assets/images/Untitled design.png
  AssetGenImage get untitledDesign =>
      const AssetGenImage('assets/images/Untitled design.png');

  /// File path: assets/images/Vector.svg
  String get vector => 'assets/images/Vector.svg';

  /// File path: assets/images/Wardrobe.svg
  String get wardrobe => 'assets/images/Wardrobe.svg';

  /// File path: assets/images/clothes1.jpg
  AssetGenImage get clothes1 =>
      const AssetGenImage('assets/images/clothes1.jpg');

  /// File path: assets/images/clothes2.jpg
  AssetGenImage get clothes2 =>
      const AssetGenImage('assets/images/clothes2.jpg');

  /// File path: assets/images/dress.png
  AssetGenImage get dress => const AssetGenImage('assets/images/dress.png');

  /// File path: assets/images/email.png
  AssetGenImage get email => const AssetGenImage('assets/images/email.png');

  /// File path: assets/images/home.svg
  String get home => 'assets/images/home.svg';

  /// File path: assets/images/lock.png
  AssetGenImage get lock => const AssetGenImage('assets/images/lock.png');

  /// File path: assets/images/login.png
  AssetGenImage get login => const AssetGenImage('assets/images/login.png');

  /// File path: assets/images/logo-removebg.png
  AssetGenImage get logoRemovebg =>
      const AssetGenImage('assets/images/logo-removebg.png');

  /// File path: assets/images/password.png
  AssetGenImage get password =>
      const AssetGenImage('assets/images/password.png');

  /// File path: assets/images/recovery.png
  AssetGenImage get recovery =>
      const AssetGenImage('assets/images/recovery.png');

  /// File path: assets/images/sign_up.png
  AssetGenImage get signUp => const AssetGenImage('assets/images/sign_up.png');

  /// List of all assets
  List<dynamic> get values => [
    ai,
    person,
    scissors,
    untitledDesign,
    vector,
    wardrobe,
    clothes1,
    clothes2,
    dress,
    email,
    home,
    lock,
    login,
    logoRemovebg,
    password,
    recovery,
    signUp,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
