class RequestIdsService {
  static RequestIdsService? _instance;
  Map<String, String> _state = {};

  RequestIdsService._();

  static RequestIdsService get instance {
    _instance ??= RequestIdsService._();
    return _instance!;
  }

  Map<String, String> get state => _state;

  void updateRequest({required String challenge, required String clientId}) {
    _state = {challenge: clientId};
  }

  void removeRequest({required String challenge}) {
    final newState = Map<String, String>.from(_state);
    newState.remove(challenge);
    _state = newState;
  }

  String? getClientId({required String challenge}) {
    return _state[challenge];
  }

  String? operator [](String challenge) => _state[challenge];
}
