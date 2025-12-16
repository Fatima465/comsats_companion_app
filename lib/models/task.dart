// lib/models/task.dart
import 'package:flutter/material.dart';

class Task {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String taskType;
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final String priority;
  final bool isCompleted;
  final bool reminderEnabled;
  final DateTime? reminderTime;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.taskType,
    this.dueDate,
    this.dueTime,
    required this.priority,
    required this.isCompleted,
    required this.reminderEnabled,
    this.reminderTime,
    required this.createdAt,
  });
  
  // Implementation of fromMap/toMap for local storage (e.g., Hive/SharedPrefs) or Supabase sync
}