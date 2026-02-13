/// Trust Registry DIDComm Protocol Message Types
/// Based on https://affinidi.com/didcomm/protocols/tr-admin/1.0/
class TrAdminMessageTypes {
  static const String createRecord =
      'https://affinidi.com/didcomm/protocols/tr-admin/1.0/create-record';

  static const String createRecordResponse =
      'https://affinidi.com/didcomm/protocols/tr-admin/1.0/create-record/response';

  static const String updateRecord =
      'https://affinidi.com/didcomm/protocols/tr-admin/1.0/update-record';

  static const String updateRecordResponse =
      'https://affinidi.com/didcomm/protocols/tr-admin/1.0/update-record/response';

  static const String deleteRecord =
      'https://affinidi.com/didcomm/protocols/tr-admin/1.0/delete-record';

  static const String deleteRecordResponse =
      'https://affinidi.com/didcomm/protocols/tr-admin/1.0/delete-record/response';

  static const String readRecord =
      'https://affinidi.com/didcomm/protocols/tr-admin/1.0/read-record';

  static const String readRecordResponse =
      'https://affinidi.com/didcomm/protocols/tr-admin/1.0/read-record/response';

  static const String listRecords =
      'https://affinidi.com/didcomm/protocols/tr-admin/1.0/list-records';

  static const String listRecordsResponse =
      'https://affinidi.com/didcomm/protocols/tr-admin/1.0/list-records/response';

  /// Get response type for a given request type
  static String getResponseType(String requestType) {
    return '$requestType/response';
  }

  /// Check if a message type is a response
  static bool isResponseType(String messageType) {
    return messageType.endsWith('/response');
  }

  /// Get request type from response type
  static String getRequestType(String responseType) {
    if (responseType.endsWith('/response')) {
      return responseType.substring(0, responseType.length - 9);
    }
    return responseType;
  }
}
