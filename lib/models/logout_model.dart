class LogOutModel {
  bool? status;
  String? message;
  DataModel? data;

  LogOutModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataModel.fromJson(json['data']) : null;
  }
}

class DataModel {
  String? token;

  DataModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }
}
