enum ZoneType { safe, danger }

class SafeZone {
  final String id;
  final String userId;
  final String name;
  final ZoneType type;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final bool notifyOnEntry;
  final bool notifyOnExit;
  final DateTime createdAt;
  final DateTime updatedAt;

  SafeZone({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    this.notifyOnEntry = false,
    this.notifyOnExit = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SafeZone.fromJson(Map<String, dynamic> json) => SafeZone(
    id: json['id'] as String,
    userId: json['userId'] as String,
    name: json['name'] as String,
    type: ZoneType.values.firstWhere((e) => e.name == json['type']),
    latitude: json['latitude'] as double,
    longitude: json['longitude'] as double,
    radiusMeters: json['radiusMeters'] as double,
    notifyOnEntry: json['notifyOnEntry'] as bool? ?? false,
    notifyOnExit: json['notifyOnExit'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'type': type.name,
    'latitude': latitude,
    'longitude': longitude,
    'radiusMeters': radiusMeters,
    'notifyOnEntry': notifyOnEntry,
    'notifyOnExit': notifyOnExit,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  SafeZone copyWith({
    String? id,
    String? userId,
    String? name,
    ZoneType? type,
    double? latitude,
    double? longitude,
    double? radiusMeters,
    bool? notifyOnEntry,
    bool? notifyOnExit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SafeZone(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    type: type ?? this.type,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    radiusMeters: radiusMeters ?? this.radiusMeters,
    notifyOnEntry: notifyOnEntry ?? this.notifyOnEntry,
    notifyOnExit: notifyOnExit ?? this.notifyOnExit,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
