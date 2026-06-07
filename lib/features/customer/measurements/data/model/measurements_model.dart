class MeasurementsModel {
  final String id;
  final String userId;
  final double chest;
  final double waist;
  final double hips;
  final double shoulders;
  final double armLength;
  final double inseam;
  final double height;
  final String unit;

  const MeasurementsModel({
    required this.id,
    required this.userId,
    required this.chest,
    required this.waist,
    required this.hips,
    required this.shoulders,
    required this.armLength,
    required this.inseam,
    required this.height,
    this.unit = 'cm',
  });

  MeasurementsModel copyWith({
    String? id,
    String? userId,
    double? chest,
    double? waist,
    double? hips,
    double? shoulders,
    double? armLength,
    double? inseam,
    double? height,
    String? unit,
  }) {
    return MeasurementsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      hips: hips ?? this.hips,
      shoulders: shoulders ?? this.shoulders,
      armLength: armLength ?? this.armLength,
      inseam: inseam ?? this.inseam,
      height: height ?? this.height,
      unit: unit ?? this.unit,
    );
  }

  factory MeasurementsModel.fromJson(Map<String, dynamic> json) {
    return MeasurementsModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      chest: (json['chest'] as num).toDouble(),
      waist: (json['waist'] as num).toDouble(),
      hips: (json['hips'] as num).toDouble(),
      shoulders: (json['shoulders'] as num).toDouble(),
      armLength: (json['armLength'] as num).toDouble(),
      inseam: (json['inseam'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      unit: json['unit'] as String? ?? 'cm',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'chest': chest,
        'waist': waist,
        'hips': hips,
        'shoulders': shoulders,
        'armLength': armLength,
        'inseam': inseam,
        'height': height,
        'unit': unit,
      };
}

class MeasurementsRequest {
  final double? chest;
  final double? waist;
  final double? hips;
  final double? shoulders;
  final double? armLength;
  final double? inseam;
  final double? height;
  final String? unit;

  const MeasurementsRequest({
    this.chest,
    this.waist,
    this.hips,
    this.shoulders,
    this.armLength,
    this.inseam,
    this.height,
    this.unit,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (chest != null) map['chest'] = chest;
    if (waist != null) map['waist'] = waist;
    if (hips != null) map['hips'] = hips;
    if (shoulders != null) map['shoulders'] = shoulders;
    if (armLength != null) map['armLength'] = armLength;
    if (inseam != null) map['inseam'] = inseam;
    if (height != null) map['height'] = height;
    if (unit != null) map['unit'] = unit;
    return map;
  }
}

class GetMeasurementsResponse {
  final MeasurementsModel? measurements;

  const GetMeasurementsResponse({this.measurements});

  factory GetMeasurementsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['measurements'];
    return GetMeasurementsResponse(
      measurements: data == null
          ? null
          : MeasurementsModel.fromJson(data as Map<String, dynamic>),
    );
  }
}

class SaveMeasurementsResponse {
  final String message;
  final MeasurementsModel measurements;

  const SaveMeasurementsResponse({
    required this.message,
    required this.measurements,
  });

  factory SaveMeasurementsResponse.fromJson(Map<String, dynamic> json) {
    return SaveMeasurementsResponse(
      message: json['message'] as String,
      measurements: MeasurementsModel.fromJson(
        json['measurements'] as Map<String, dynamic>,
      ),
    );
  }
}

class DeleteMeasurementsResponse {
  final String message;

  const DeleteMeasurementsResponse({required this.message});

  factory DeleteMeasurementsResponse.fromJson(Map<String, dynamic> json) {
    return DeleteMeasurementsResponse(message: json['message'] as String);
  }
}
