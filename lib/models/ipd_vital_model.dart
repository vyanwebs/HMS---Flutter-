class IPDVitalModel {
  final String room;
  final String bedNo;
  final String pulse;
  final String temp;
  final String spo2;
  final bool isCritical;

  IPDVitalModel({
    required this.room,
    required this.bedNo,
    required this.pulse,
    required this.temp,
    required this.spo2,
    this.isCritical = false,
  });
}
