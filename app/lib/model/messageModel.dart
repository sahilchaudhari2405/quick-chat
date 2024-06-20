class Messagemodel {
  String type;
  String message;
  String data; // Optional field for image data
  String time;
  String way;

  Messagemodel({
    required this.type,
    required this.message,
    required this.time,
    required this.way,
    this.data = '',
  });
}
