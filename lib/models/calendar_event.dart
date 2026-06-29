class CalendarEventModel {
  const CalendarEventModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.amount,
  });

  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime eventDate;
  final double? amount;

  CalendarEventModel copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    DateTime? eventDate,
    double? amount,
  }) {
    return CalendarEventModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'amount': amount,
    };
  }

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      eventDate: DateTime.parse(json['eventDate'] as String),
      amount: (json['amount'] as num?)?.toDouble(),
    );
  }
}
