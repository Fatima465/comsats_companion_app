// lib/models/event.dart
import 'package:flutter/material.dart';

class Event {
  final String id;
  final String? createdBy; // UUID of admin user
  final String title;
  final String description;
  final DateTime eventDate;
  final TimeOfDay? eventTime;
  final String? location;
  final String? category;
  final String? imageUrl;
  final String? registrationLink;
  final bool isFeatured;
  final String status; // 'Upcoming', 'Ongoing', 'Completed', 'Cancelled'
  final DateTime createdAt;

  Event({
    required this.id,
    this.createdBy,
    required this.title,
    required this.description,
    required this.eventDate,
    this.eventTime,
    this.location,
    this.category,
    this.imageUrl,
    this.registrationLink,
    required this.isFeatured,
    required this.status,
    required this.createdAt,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      createdBy: map['created_by'] as String?,
      title: map['title'] as String,
      description: map['description'] as String,
      eventDate: DateTime.parse(map['event_date'] as String),
      eventTime: map['event_time'] != null
?     TimeOfDay.fromDateTime(DateTime.parse('2024-01-01 ${map['event_time']}'))          : null,
      location: map['location'] as String?,
      category: map['category'] as String?,
      imageUrl: map['image_url'] as String?,
      registrationLink: map['registration_link'] as String?,
      isFeatured: map['is_featured'] as bool,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'created_by': createdBy,
      'title': title,
      'description': description,
      'event_date': eventDate.toIso8601String().split('T').first,
      'event_time': eventTime != null ? '${eventTime!.hour.toString().padLeft(2, '0')}:${eventTime!.minute.toString().padLeft(2, '0')}:00' : null,
      'location': location,
      'category': category,
      'image_url': imageUrl,
      'registration_link': registrationLink,
      'is_featured': isFeatured,
      'status': status,
    };
  }
}