// ignore_for_file: file_names

class MobileVarify {
  dynamic status;
  dynamic sessionId;
  dynamic timestamp;
  dynamic deviceInfo;

  MobileVarify({this.status, this.sessionId, this.timestamp});

  MobileVarify.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    sessionId = json['session_id'];
    timestamp = json['timestamp'];
    deviceInfo = json['device_info'];
  }

  Map<dynamic, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<dynamic, dynamic> data = Map<dynamic, dynamic>();
    data['status'] = status;
    data['session_id'] = sessionId;
    data['timestamp'] = timestamp;
    data['device_info'] = deviceInfo;
    return data;
  }
}

//user
class LoginResponse {
  dynamic token;
  dynamic message;
  dynamic status;
  dynamic userid;

  LoginResponse({this.token, this.message, this.status, this.userid});

  LoginResponse.fromJson(Map<dynamic, dynamic> json) {
    token = json['token'];
    message = json['message'];
    status = json['status'];
    userid = json['userid'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = Map<dynamic, dynamic>();
    data['token'] = token;
    data['message'] = message;
    data['status'] = status;
    data['userid'] = userid;
    return data;
  }
}
