class LocationRecord {
  final String id;
  final String userId;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final String? address;
  final DateTime timestamp;

  LocationRecord({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.address,
    required this.timestamp,
  });

  factory LocationRecord.fromJson(Map<String, dynamic> json) => LocationRecord(
    id: json['id'] as String,
    userId: json['userId'] as String,
    latitude: json['latitude'] as double,
    longitude: json['longitude'] as double,
    accuracy: json['accuracy'] as double?,
    address: json['address'] as String?,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'latitude': latitude,
    'longitude': longitude,
    'accuracy': accuracy,
    'address': address,
    'timestamp': timestamp.toIso8601String(),
  };

  LocationRecord copyWith({
    String? id,
    String? userId,
    double? latitude,
    double? longitude,
    double? accuracy,
    String? address,
    DateTime? timestamp,
  }) => LocationRecord(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    accuracy: accuracy ?? this.accuracy,
    address: address ?? this.address,
    timestamp: timestamp ?? this.timestamp,
  );
}
