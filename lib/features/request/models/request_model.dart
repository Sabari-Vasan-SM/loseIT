enum RequestStatus { pending, accepted, rejected }

class RequestModel {
  final String id;
  final String postId;
  final String postTitle;
  final String postImage;
  final String requesterId;
  final String requesterName;
  final String requesterAvatar;
  final RequestStatus status;
  final DateTime createdAt;

  const RequestModel({
    required this.id,
    required this.postId,
    required this.postTitle,
    required this.postImage,
    required this.requesterId,
    required this.requesterName,
    required this.requesterAvatar,
    required this.status,
    required this.createdAt,
  });

  RequestModel copyWith({
    String? id,
    String? postId,
    String? postTitle,
    String? postImage,
    String? requesterId,
    String? requesterName,
    String? requesterAvatar,
    RequestStatus? status,
    DateTime? createdAt,
  }) {
    return RequestModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      postTitle: postTitle ?? this.postTitle,
      postImage: postImage ?? this.postImage,
      requesterId: requesterId ?? this.requesterId,
      requesterName: requesterName ?? this.requesterName,
      requesterAvatar: requesterAvatar ?? this.requesterAvatar,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get statusLabel {
    switch (status) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.accepted:
        return 'Accepted';
      case RequestStatus.rejected:
        return 'Rejected';
    }
  }
}
