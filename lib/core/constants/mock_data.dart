import 'package:lose_it/features/post/models/post_model.dart';
import 'package:lose_it/features/request/models/request_model.dart';
import 'package:lose_it/features/auth/models/user_model.dart';

class MockData {
  static const currentUser = UserModel(
    id: 'user_1',
    name: 'Alex Johnson',
    email: 'alex@example.com',
    avatarUrl: 'https://i.pravatar.cc/300?img=12',
    bio: 'Helping people find their lost belongings 🔍',
    contactNumber: '+1 (555) 0123',
    isProfileComplete: true,
  );

  static final List<PostModel> posts = [
    PostModel(
      id: 'post_1',
      title: 'Lost iPhone 15 Pro Max',
      description:
          'Lost my iPhone 15 Pro Max in Natural Titanium near Central Park. '
          'It has a clear case with a photo card inside. Last seen around 3 PM '
          'near the Bethesda Fountain. If found, please contact me immediately. '
          'Offering a reward.',
      location: 'Central Park, New York',
      contactInfo: '+1 (555) 0123',
      imageUrl: 'https://picsum.photos/seed/phone1/600/400',
      status: ItemStatus.lost,
      userId: 'user_1',
      userName: 'Alex Johnson',
      userAvatar: 'https://i.pravatar.cc/300?img=12',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    PostModel(
      id: 'post_2',
      title: 'Found AirPods Pro Case',
      description:
          'Found a white AirPods Pro case on the bench near the subway station. '
          'The case has some scratches on the right side. Contact me with proof '
          'of ownership to claim.',
      location: 'Times Square Station, NYC',
      contactInfo: '+1 (555) 0456',
      imageUrl: 'https://picsum.photos/seed/airpods2/600/400',
      status: ItemStatus.found,
      userId: 'user_2',
      userName: 'Sarah Chen',
      userAvatar: 'https://i.pravatar.cc/300?img=5',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    PostModel(
      id: 'post_3',
      title: 'Lost Golden Retriever — "Buddy"',
      description:
          'Our beloved Golden Retriever, Buddy, went missing from our backyard. '
          'He is 3 years old, wearing a blue collar with a name tag. Very friendly. '
          'Last seen near Riverside Drive. Please help us bring him home!',
      location: 'Riverside Drive, Manhattan',
      contactInfo: '+1 (555) 0789',
      imageUrl: 'https://picsum.photos/seed/dog3/600/400',
      status: ItemStatus.lost,
      userId: 'user_3',
      userName: 'Mike Torres',
      userAvatar: 'https://i.pravatar.cc/300?img=8',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    PostModel(
      id: 'post_4',
      title: 'Wallet Handed to Police',
      description:
          'Found a brown leather wallet near the coffee shop on 5th Avenue. '
          'Contains several cards and some cash. I handed it to the NYPD '
          '19th Precinct. Ask for Officer Davis to claim.',
      location: '5th Avenue Police Station',
      contactInfo: 'NYPD 19th Precinct',
      imageUrl: 'https://picsum.photos/seed/wallet4/600/400',
      status: ItemStatus.police,
      userId: 'user_4',
      userName: 'Emma Wilson',
      userAvatar: 'https://i.pravatar.cc/300?img=1',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    PostModel(
      id: 'post_5',
      title: 'Lost Car Keys — Toyota',
      description:
          'Lost my Toyota car keys somewhere between the parking lot and the mall '
          'entrance. Black key fob with a small keychain. If anyone found them '
          'please reach out.',
      location: 'Westfield Mall, Brooklyn',
      contactInfo: '+1 (555) 1122',
      imageUrl: 'https://picsum.photos/seed/keys5/600/400',
      status: ItemStatus.lost,
      userId: 'user_1',
      userName: 'Alex Johnson',
      userAvatar: 'https://i.pravatar.cc/300?img=12',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    PostModel(
      id: 'post_6',
      title: 'Found Prescription Glasses',
      description:
          'Found a pair of prescription glasses in a black case at the library. '
          'Round frame, tortoiseshell pattern. Left on the second floor reading area. '
          'Currently at the front desk.',
      location: 'Brooklyn Public Library',
      contactInfo: '+1 (555) 3344',
      imageUrl: 'https://picsum.photos/seed/glasses6/600/400',
      status: ItemStatus.found,
      userId: 'user_5',
      userName: 'David Kim',
      userAvatar: 'https://i.pravatar.cc/300?img=15',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
    ),
    PostModel(
      id: 'post_7',
      title: 'Lost Backpack — North Face',
      description:
          'Left my black North Face backpack on the A-train heading downtown. '
          'Contains a laptop, notebooks, and a water bottle. Really need the '
          'laptop for work. Any help appreciated!',
      location: 'A-Train, Downtown Manhattan',
      contactInfo: '+1 (555) 5566',
      imageUrl: 'https://picsum.photos/seed/backpack7/600/400',
      status: ItemStatus.lost,
      userId: 'user_6',
      userName: 'Lisa Park',
      userAvatar: 'https://i.pravatar.cc/300?img=9',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    PostModel(
      id: 'post_8',
      title: 'Found Watch at Gym',
      description:
          'Found a silver watch in the locker room at Planet Fitness. '
          'Looks like a nice chronograph. Turned it in to the front desk '
          'but posting here too in case the owner sees this.',
      location: 'Planet Fitness, Queens',
      contactInfo: '+1 (555) 7788',
      imageUrl: 'https://picsum.photos/seed/watch8/600/400',
      status: ItemStatus.found,
      userId: 'user_1',
      userName: 'Alex Johnson',
      userAvatar: 'https://i.pravatar.cc/300?img=12',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  static final List<RequestModel> requests = [
    RequestModel(
      id: 'req_1',
      postId: 'post_2',
      postTitle: 'Found AirPods Pro Case',
      postImage: 'https://picsum.photos/seed/airpods2/600/400',
      requesterId: 'user_7',
      requesterName: 'Tom Baker',
      requesterAvatar: 'https://i.pravatar.cc/300?img=3',
      status: RequestStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    RequestModel(
      id: 'req_2',
      postId: 'post_6',
      postTitle: 'Found Prescription Glasses',
      postImage: 'https://picsum.photos/seed/glasses6/600/400',
      requesterId: 'user_8',
      requesterName: 'Amy Liu',
      requesterAvatar: 'https://i.pravatar.cc/300?img=16',
      status: RequestStatus.accepted,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    RequestModel(
      id: 'req_3',
      postId: 'post_8',
      postTitle: 'Found Watch at Gym',
      postImage: 'https://picsum.photos/seed/watch8/600/400',
      requesterId: 'user_9',
      requesterName: 'John Doe',
      requesterAvatar: 'https://i.pravatar.cc/300?img=11',
      status: RequestStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    RequestModel(
      id: 'req_4',
      postId: 'post_4',
      postTitle: 'Wallet Handed to Police',
      postImage: 'https://picsum.photos/seed/wallet4/600/400',
      requesterId: 'user_10',
      requesterName: 'Rachel Green',
      requesterAvatar: 'https://i.pravatar.cc/300?img=20',
      status: RequestStatus.rejected,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
}
