class PendingTaskModel {
  final String id;              // _id
  final String title;           // title
  final String priority;        // LOW / MEDIUM / HIGH
  final int priorityOrder;      // 1 / 2 / 3
  final String staffId;         // staffId
  final DateTime createdAt;     // createdAt
  final DateTime updatedAt;     // updatedAt

  /// UI-only (computed)
  final String timeAgo;

  PendingTaskModel({
    required this.id,
    required this.title,
    required this.priority,
    required this.priorityOrder,
    required this.staffId,
    required this.createdAt,
    required this.updatedAt,
    required this.timeAgo,
  });

  // ================= FROM JSON =================
  factory PendingTaskModel.fromJson(Map<String, dynamic> json) {
    final updated = DateTime.parse(json['updatedAt']);

    return PendingTaskModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      priority: json['priority'] ?? 'LOW',
      priorityOrder: json['priorityOrder'] ?? 0,
      staffId: json['staffId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: updated,
      timeAgo: _timeAgo(updated),
    );
  }

  // ================= TO JSON =================
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'priority': priority,
      'priorityOrder': priorityOrder,
      'staffId': staffId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // ================= COPY WITH =================
  PendingTaskModel copyWith({
    String? id,
    String? title,
    String? priority,
    int? priorityOrder,
    String? staffId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? timeAgo,
  }) {
    return PendingTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      priorityOrder: priorityOrder ?? this.priorityOrder,
      staffId: staffId ?? this.staffId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      timeAgo: timeAgo ?? this.timeAgo,
    );
  }

  // ================= TIME AGO HELPER =================
  static String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays == 1) return '1 day ago';

    return '${diff.inDays} days ago';
  }
}
