import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lose_it/features/request/models/request_model.dart';
import 'package:lose_it/core/constants/mock_data.dart';

final requestsProvider =
    StateNotifierProvider<RequestsNotifier, List<RequestModel>>((ref) {
  return RequestsNotifier();
});

class RequestsNotifier extends StateNotifier<List<RequestModel>> {
  RequestsNotifier() : super(MockData.requests);

  void addRequest(RequestModel request) {
    state = [request, ...state];
  }

  void acceptRequest(String id) {
    state = state.map((r) {
      if (r.id == id) {
        return r.copyWith(status: RequestStatus.accepted);
      }
      return r;
    }).toList();
  }

  void rejectRequest(String id) {
    state = state.map((r) {
      if (r.id == id) {
        return r.copyWith(status: RequestStatus.rejected);
      }
      return r;
    }).toList();
  }

  void removeRequest(String id) {
    state = state.where((r) => r.id != id).toList();
  }
}
