enum EmergencyStatus { active, resolved, cancelled }

class EmergencySession {
  final String id;
  final String userId;
  final EmergencyStatus status;
  final double latitude;
  final double longitude;
  final String? address;
  final List<String> notifiedGuardians;
  final bool policeNotified;
  final String? notes;
  final DateTime startedAt;
  final DateTime? endedAt;
  final DateTime updatedAt;

  EmergencySession({
    required this.id,
    required this.userId,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.address,
    this.notifiedGuardians = const [],
    this.policeNotified = false,
    this.notes,
    required this.startedAt,
    this.endedAt,
    required this.updatedAt,
  });

  factory EmergencySession.fromJson(Map<String, dynamic> json) => EmergencySession(
    id: json['id'] as String,
    userId: json['userId'] as String,
    status: EmergencyStatus.values.firstWhere((e) => e.name == json['status']),
    latitude: json['latitude'] as double,
    longitude: json['longitude'] as double,
    address: json['address'] as String?,
    notifiedGuardians: (json['notifiedGuardians'] as List<dynamic>).cast<String>(),
    policeNotified: json['policeNotified'] as bool? ?? false,
    notes: json['notes'] as String?,
    startedAt: DateTime.parse(json['startedAt'] as String),
    endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt'] as String) : null,
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'status': status.name,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'notifiedGuardians': notifiedGuardians,
    'policeNotified': policeNotified,
    'notes': notes,
    'startedAt': startedAt.toIso8601String(),
    'endedAt': endedAt?.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  EmergencySession copyWith({
    String? id,
    String? userId,
    EmergencyStatus? status,
    double? latitude,
    double? longitude,
    String? address,
    List<String>? notifiedGuardians,
    bool? policeNotified,
    String? notes,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? updatedAt,
  }) => EmergencySession(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    status: status ?? this.status,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    address: address ?? this.address,
    notifiedGuardians: notifiedGuardians ?? this.notifiedGuardians,
    policeNotified: policeNotified ?? this.policeNotified,
    notes: notes ?? this.notes,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
