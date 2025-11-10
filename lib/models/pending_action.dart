enum PendingActionType { sms, call }

class PendingAction {
  final String id;
  final PendingActionType type;
  final String phone;
  final String? message;
  final DateTime createdAt;
  final int attempts;
  final DateTime? lastAttemptAt;

  PendingAction({
    required this.id,
    required this.type,
    required this.phone,
    this.message,
    required this.createdAt,
    this.attempts = 0,
    this.lastAttemptAt,
  });

  factory PendingAction.fromJson(Map<String, dynamic> json) => PendingAction(
        id: json['id'] as String,
        type: PendingActionType.values.firstWhere((e) => e.name == json['type']),
        phone: json['phone'] as String,
        message: json['message'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        attempts: (json['attempts'] as int?) ?? 0,
        lastAttemptAt: json['lastAttemptAt'] != null
            ? DateTime.parse(json['lastAttemptAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'phone': phone,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
        'attempts': attempts,
        'lastAttemptAt': lastAttemptAt?.toIso8601String(),
      };

  PendingAction copyWith({
    String? id,
    PendingActionType? type,
    String? phone,
    String? message,
    DateTime? createdAt,
    int? attempts,
    DateTime? lastAttemptAt,
  }) =>
      PendingAction(
        id: id ?? this.id,
        type: type ?? this.type,
        phone: phone ?? this.phone,
        message: message ?? this.message,
        createdAt: createdAt ?? this.createdAt,
        attempts: attempts ?? this.attempts,
        lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      );
}
