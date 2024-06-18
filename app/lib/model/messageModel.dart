// ignore_for_file: public_member_api_docs, sort_constructors_first
class Messagemodel {
  String type;
  String message;
  String time;
  Messagemodel({required this.type, required this.message, required this.time});
}

class MassageWithData {
  String message;
  dynamic data;
  String type;
  String time;
  MassageWithData({
    required this.message,
    required this.data,
    required this.type,
    required this.time,
  });
}
