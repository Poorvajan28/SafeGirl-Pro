class Guardian {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String relationship;
  final String? email;
  final int priority;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  Guardian({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.relationship,
    this.email,
    required this.priority,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Guardian.fromJson(Map<String, dynamic> json) => Guardian(
    id: json['id'] as String,
    userId: json['userId'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
    relationship: json['relationship'] as String,
    email: json['email'] as String?,
    priority: json['priority'] as int,
    isVerified: json['isVerified'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'phone': phone,
    'relationship': relationship,
    'email': email,
    'priority': priority,
    'isVerified': isVerified,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  Guardian copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? relationship,
    String? email,
    int? priority,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Guardian(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    relationship: relationship ?? this.relationship,
    email: email ?? this.email,
    priority: priority ?? this.priority,
    isVerified: isVerified ?? this.isVerified,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
