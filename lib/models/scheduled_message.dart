class ScheduledMessage {
  final String id;
  final String userId;
  final String message;
  final bool includeLocation;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScheduledMessage({
    required this.id,
    required this.userId,
    required this.message,
    this.includeLocation = true,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScheduledMessage.fromJson(Map<String, dynamic> json) => ScheduledMessage(
    id: json['id'] as String,
    userId: json['userId'] as String,
    message: json['message'] as String,
    includeLocation: json['includeLocation'] as bool? ?? true,
    isActive: json['isActive'] as bool? ?? true,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'message': message,
    'includeLocation': includeLocation,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  ScheduledMessage copyWith({
    String? id,
    String? userId,
    String? message,
    bool? includeLocation,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ScheduledMessage(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    message: message ?? this.message,
    includeLocation: includeLocation ?? this.includeLocation,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
