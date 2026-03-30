class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String bio;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.bio = '',
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? bio,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
    );
  }
}
