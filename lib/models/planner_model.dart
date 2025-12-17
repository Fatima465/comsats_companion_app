class PlannerModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime planDate;
  final String planTime;
  final bool isCompleted;

  PlannerModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.planDate,
    required this.planTime,
    this.isCompleted = false,
  });

  factory PlannerModel.fromMap(Map<String, dynamic> map) {
    return PlannerModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'] ?? 'No Title',
      description: map['description'] ?? '',
      planDate: map['plan_date'] != null ? DateTime.parse(map['plan_date']) : DateTime.now(),
      planTime: map['plan_time'] ?? '',
      isCompleted: map['is_completed'] ?? false,
    );
  }
}