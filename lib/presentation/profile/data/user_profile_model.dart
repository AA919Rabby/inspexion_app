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
    return UserProfileModel(
      id: json['id'] ?? 0,
      email: json['email']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? 'User',
      avatarUrl: json['avatar_url']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}