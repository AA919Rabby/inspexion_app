class UserProfileModel {
  final int id;
  final String email;
  final String fullName;
  final String avatarUrl;
  final String createdAt;

  UserProfileModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
    required this.createdAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Gracefully handle nested API responses (e.g., json['data'] or json['user'])
    final data = json['data'] ?? json['user'] ?? json;

    return UserProfileModel(
      id: data['id'] ?? 0,
      email: data['email']?.toString() ?? '',
      fullName: data['full_name']?.toString() ?? 'User',
      avatarUrl: data['avatar_url']?.toString() ?? '',
      createdAt: data['created_at']?.toString() ?? '',
    );
  }
}