class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String bio;
  final String contactNumber;
  final bool isProfileComplete;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.bio = '',
    this.contactNumber = '',
    this.isProfileComplete = false,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? bio,
    String? contactNumber,
    bool? isProfileComplete,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      contactNumber: contactNumber ?? this.contactNumber,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}
