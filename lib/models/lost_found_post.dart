class LostFoundPost {
  final String id;
  final String postedBy;
  final String postType;
  final String title;
  final String description;
  final String? location;
  final String? contactInfo;
  final String? imageUrl;
  final String status;
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
      // Use .toString() and ?? to prevent casting errors
      id: map['id']?.toString() ?? '',
      postedBy: map['posted_by']?.toString() ?? '',
      postType: map['post_type']?.toString() ?? 'lost',
      title: map['title']?.toString() ?? 'No Title',
      description: map['description']?.toString() ?? '',
      location: map['location']?.toString(),
      contactInfo: map['contact_info']?.toString(),
      imageUrl: map['image_url']?.toString(),
      status: map['status']?.toString() ?? 'Active',
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']).toLocal() 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'posted_by': postedBy,
      'post_type': postType.toLowerCase(), // Ensure lowercase for DB consistency
      'title': title,
      'description': description,
      'location': location,
      'contact_info': contactInfo,
      'image_url': imageUrl,
      'status': status,
    };
  }
}