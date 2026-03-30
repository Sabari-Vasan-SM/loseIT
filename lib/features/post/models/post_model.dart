enum ItemStatus { lost, found, police }

class PostModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final String contactInfo;
  final String imageUrl;
  final ItemStatus status;
  final String userId;
  final String userName;
  final String userAvatar;
  final DateTime createdAt;

  const PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.contactInfo,
    required this.imageUrl,
    required this.status,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.createdAt,
  });

  PostModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? contactInfo,
    String? imageUrl,
    ItemStatus? status,
    String? userId,
    String? userName,
    String? userAvatar,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      contactInfo: contactInfo ?? this.contactInfo,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get statusLabel {
    switch (status) {
      case ItemStatus.lost:
        return 'Lost';
      case ItemStatus.found:
        return 'Found';
      case ItemStatus.police:
        return 'Given to Police';
    }
  }
}
