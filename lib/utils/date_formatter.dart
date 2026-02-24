/// Convert ISO string → `10:45 AM`
String timeOnly(String? isoString) {
  if (isoString == null || isoString.isEmpty) return '--';

  try {
    final dateTime = DateTime.parse(isoString).toLocal();
    return _formatTime(dateTime);
  } catch (_) {
    return '--';
  }
}

/// Convert DateTime → `10:45 AM`
String timeFromDateTime(DateTime? dateTime) {
  if (dateTime == null) return '--';
  return _formatTime(dateTime.toLocal());
}

/// Convert ISO string → `03 Feb 2026`
String dateOnly(String? isoString) {
  if (isoString == null || isoString.isEmpty) return '--';

  try {
    final dateTime = DateTime.parse(isoString).toLocal();
    return _formatDate(dateTime);
  } catch (_) {
    return '--';
  }
}

/// Convert DateTime → `03 Feb 2026`
String dateFromDateTime(DateTime? dateTime) {
  if (dateTime == null) return '--';
  return _formatDate(dateTime.toLocal());
}

/// Convert ISO string → `03 Feb 2026, 10:45 AM`
String dateTime(String? isoString) {
  if (isoString == null || isoString.isEmpty) return '--';

  try {
    final dateTime = DateTime.parse(isoString).toLocal();
    return '${_formatDate(dateTime)}, ${_formatTime(dateTime)}';
  } catch (_) {
    return '--';
  }
}

// ================= PRIVATE HELPERS =================

String _formatTime(DateTime dateTime) {
  final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
  final displayHour = hour == 0 ? 12 : hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour >= 12 ? 'PM' : 'AM';

  return '$displayHour:$minute $period';
}

String _formatDate(DateTime dateTime) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  final day = dateTime.day.toString().padLeft(2, '0');
  final month = months[dateTime.month - 1];
  final year = dateTime.year;

  return '$day $month $year';
}