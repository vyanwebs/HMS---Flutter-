String? doubleValidator(
  String? value, {
  required String label,
  double? min,
  double? max,
}) {
  if (value == null || value.trim().isEmpty) {
    return '$label is required';
  }

  final parsed = double.tryParse(value);
  if (parsed == null) {
    return 'Enter a valid number';
  }

  if (min != null && parsed < min) {
    return '$label must be ≥ $min';
  }

  if (max != null && parsed > max) {
    return '$label must be ≤ $max';
  }

  return null;
}

String? bpValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'BP is required';
  }

  final parts = value.split('/');

  if (parts.length != 2) {
    return 'Enter BP as systolic/diastolic';
  }

  final systolic = int.tryParse(parts[0]);
  final diastolic = int.tryParse(parts[1]);

  if (systolic == null || diastolic == null) {
    return 'BP must be numeric';
  }

  if (systolic < 50 || systolic > 250) {
    return 'Invalid systolic value';
  }

  if (diastolic < 30 || diastolic > 150) {
    return 'Invalid diastolic value';
  }

  if (systolic <= diastolic) {
    return 'Systolic must be greater than diastolic';
  }

  return null;
}
