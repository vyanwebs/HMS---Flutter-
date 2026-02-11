import 'enums.dart';

String vitalLabel(VitalType v) {
  switch (v) {
    case VitalType.temperature:
      return "Temperature";
    case VitalType.pulse:
      return "Pulse";
    case VitalType.bp:
      return "Blood Pressure";
    case VitalType.spo2:
      return "SpO₂";
    case VitalType.respiration:
      return "Respiration Rate";
    case VitalType.sugar:
      return "Blood Sugar";
    case VitalType.weight:
      return "Weight";
  }
}

String timeRangeLabel(TimeRange r) {
  switch (r) {
    case TimeRange.days7:
      return "7 Days";
    case TimeRange.days14:
      return "14 Days";
    case TimeRange.days30:
      return "30 Days";
    case TimeRange.all:
      return "All Records";
  }
}
