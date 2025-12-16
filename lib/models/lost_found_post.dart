// lib/models/lost_found_post.dart
class LostFoundPost {
  final String id;
  final String postedBy;
  final String postType; // 'Lost' or 'Found'
  final String title;
  final String description;
  final String? location;
  final String? contactInfo;
  final String? imageUrl;
  final String status; // 'Active', 'Resolved', 'Closed'
  final DateTime createdAt;

  LostFoundPost({
    required this.id,
    required this.postedBy,
    required this.postType,
    required this.title,
    required this.description,
    this.location,
    this.contactInfo,
    this.imageUrl,
    required this.status,
    required this.createdAt,
  });

  factory LostFoundPost.fromMap(Map<String, dynamic> map) {
    return LostFoundPost(
      id: map['id'] as String,
      postedBy: map['posted_by'] as String,
      postType: map['post_type'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      location: map['location'] as String?,
      contactInfo: map['contact_info'] as String?,
      imageUrl: map['image_url'] as String?,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'posted_by': postedBy,
      'post_type': postType,
      'title': title,
      'description': description,
      'location': location,
      'contact_info': contactInfo,
      'image_url': imageUrl,
      'status': status,
    };
  }
}