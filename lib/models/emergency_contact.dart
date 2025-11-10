class EmergencyContact {
  final String id;
  final String name;
  final String phone;
  final String type;
  final String? address;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
    this.address,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) => EmergencyContact(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
    type: json['type'] as String,
    address: json['address'] as String?,
    latitude: json['latitude'] as double?,
    longitude: json['longitude'] as double?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'type': type,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  EmergencyContact copyWith({
    String? id,
    String? name,
    String? phone,
    String? type,
    String? address,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => EmergencyContact(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    type: type ?? this.type,
    address: address ?? this.address,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
