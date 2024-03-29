import 'dart:convert';

class MockApi {
  static Future<Map<String, dynamic>> getComplaintListAPI() async {
    // Mock response similar to the actual API response
    const mockResponse = '''
    {
      "code": "200",
      "message": "Complaint Type List!!",
      "data": [
        {
          "_id": "64e50cc6ff40899d681fdf6b",
          "name": "RPM issue",
          "__v": 0
        },
        {
          "_id": "64e50d0b1c462d26a9cb9f39",
          "name": "LDA reading issue"
        },
        {
          "_id": "64e50d0b1c462d26a9cb9f3a",
          "name": "MGA not powering on"
        }
      ]
    }
    ''';

    return json.decode(mockResponse);
  }
}