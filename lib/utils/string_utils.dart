String extractBedNumber(String? value) {
  if (value == null || value.isEmpty) return "-";

  // Find pattern like B05 → extract 05
  final match = RegExp(r'B(\d+)').firstMatch(value);

  return match?.group(1) ?? "-";
}

String extractWardFromBedAssign(String? bedAssign) {
  if (bedAssign == null || bedAssign.isEmpty) return "Others";

  final parts = bedAssign.split("-");

  if (parts.length < 2) return "Others";

  final wardCode = parts[1].toUpperCase();

  switch (wardCode) {
    case "EMR":
      return "Emergency";

    case "GEN":
      return "General";

    case "OPD":
      return "OPD";

    case "IPD":
      return "IPD";

    default:
      return "Others";
  }
}
