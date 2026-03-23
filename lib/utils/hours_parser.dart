/// Parses the free-text hours strings stored in the restaurants table and
/// determines whether a restaurant is currently open.
///
/// Supported formats (all present in the seed data):
///   "Monday - Friday: 8:00 AM - 3:00 PM"
///   "Monday - Friday 10:30 AM - 5:00 PM"          (no colon after day range)
///   "Sunday - Thursday: 11:00 AM - 10:00 PM"
///   "Tuesday - Friday: 7:00 AM - 6:00 PM, Saturday - Sunday: 8:00 AM - 4:00 PM"
///   "Monday, Wednesday, Thursday: 9:00 AM - 5:00 PM, Tuesday: 9:00 AM - 7:00 PM, ..."
///   "Monday - Thursday: 11:00 AM - 10:00 PM, Friday - Saturday: 11:00 AM - 12:00 AM, ..."
///
/// Midnight-crossing ranges (e.g. 11:00 AM - 2:00 AM) are handled correctly.
class HoursParser {
  static const _dayNames = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  /// Returns true if [hoursString] indicates the restaurant is open at [now].
  /// Returns false if [hoursString] is empty, null, or cannot be parsed.
  static bool isOpenAt(String hoursString, DateTime now) {
    if (hoursString.isEmpty) return false;

    // Split into segments on commas that are followed by a day name.
    // We can't blindly split on all commas because "Monday, Wednesday, Thursday: ..."
    // uses commas to list individual days within one segment.
    final segments = _splitSegments(hoursString);

    for (final segment in segments) {
      if (_segmentCoversNow(segment.trim(), now)) return true;
    }
    return false;
  }

  // -------------------------------------------------------------------------
  // Segment splitting
  // -------------------------------------------------------------------------

  /// Splits the hours string into independent day-range + time segments.
  /// Example: "Mon - Fri: 9-5, Sat - Sun: 10-4" → ["Mon - Fri: 9-5", "Sat - Sun: 10-4"]
  ///
  /// The tricky case is "Mon, Wed, Thu: 9-5, Tue: 9-7" — commas here separate
  /// both individual days in a list AND different segments. We detect a new
  /// segment boundary when a comma is followed (possibly after whitespace) by
  /// a capitalised day token that is itself followed by more content.
  static List<String> _splitSegments(String hoursString) {
    // Regex: comma followed by optional spaces and a day name (case-insensitive)
    // followed by something (space, comma, colon, or end) — indicating a new segment.
    final segmentBoundary = RegExp(
      r',\s*(?=(?:monday|tuesday|wednesday|thursday|friday|saturday|sunday)'
      r'(?:\s*[-,:]|\s*$))',
      caseSensitive: false,
    );
    return hoursString.split(segmentBoundary);
  }

  // -------------------------------------------------------------------------
  // Per-segment evaluation
  // -------------------------------------------------------------------------

  static bool _segmentCoversNow(String segment, DateTime now) {
    // A segment has the shape:  <days part>  <time range>
    // We detect the boundary between days and time by finding the first
    // time-like token (digit followed by colon or AM/PM pattern).
    final timeStartMatch = RegExp(
      r'(\d{1,2}(?::\d{2})?\s*[aApP][mM])',
    ).firstMatch(segment);
    if (timeStartMatch == null) return false;

    final daysRaw = segment.substring(0, timeStartMatch.start);
    final timeRaw = segment.substring(timeStartMatch.start);

    final days = _parseDays(daysRaw);
    if (days.isEmpty) return false;

    final todayIndex = now.weekday - 1; // DateTime.monday == 1
    if (!days.contains(todayIndex)) return false;

    return _timeRangeCoversNow(timeRaw, now);
  }

  // -------------------------------------------------------------------------
  // Day parsing
  // -------------------------------------------------------------------------

  /// Returns a set of day indices (0=Monday … 6=Sunday) covered by [daysRaw].
  static Set<int> _parseDays(String daysRaw) {
    // Strip trailing colon / whitespace
    final cleaned = daysRaw.replaceAll(RegExp(r'[:\s]+$'), '').trim();

    if (cleaned.isEmpty) return {};

    // Check for a range: "Monday - Friday"
    final rangeMatch = RegExp(
      r'^(monday|tuesday|wednesday|thursday|friday|saturday|sunday)'
      r'\s*[-–]\s*'
      r'(monday|tuesday|wednesday|thursday|friday|saturday|sunday)$',
      caseSensitive: false,
    ).firstMatch(cleaned);

    if (rangeMatch != null) {
      final start = _dayIndex(rangeMatch.group(1)!);
      final end = _dayIndex(rangeMatch.group(2)!);
      if (start == null || end == null) return {};
      // Handle wrap-around (e.g. Sunday - Thursday)
      final days = <int>{};
      if (start <= end) {
        for (var d = start; d <= end; d++) {
          days.add(d);
        }
      } else {
        for (var d = start; d <= 6; d++) {
          days.add(d);
        }
        for (var d = 0; d <= end; d++) {
          days.add(d);
        }
      }
      return days;
    }

    // Check for a comma-separated list: "Monday, Wednesday, Thursday"
    if (cleaned.contains(',')) {
      final days = <int>{};
      for (final part in cleaned.split(',')) {
        final idx = _dayIndex(part.trim());
        if (idx != null) days.add(idx);
      }
      return days;
    }

    // Single day
    final idx = _dayIndex(cleaned);
    return idx != null ? {idx} : {};
  }

  static int? _dayIndex(String name) {
    final lower = name.toLowerCase().trim();
    final idx = _dayNames.indexWhere(
      (d) => lower.startsWith(d.substring(0, 3)),
    );
    return idx == -1 ? null : idx;
  }

  // -------------------------------------------------------------------------
  // Time range parsing
  // -------------------------------------------------------------------------

  /// Returns true if [now] falls within the time range described by [timeRaw].
  /// Handles midnight-crossing ranges (e.g. "11:00 AM - 2:00 AM").
  static bool _timeRangeCoversNow(String timeRaw, DateTime now) {
    final timePattern = RegExp(r'(\d{1,2}(?::\d{2})?\s*[aApP][mM])');
    final matches = timePattern.allMatches(timeRaw).toList();
    if (matches.length < 2) return false;

    final openMinutes = _parseTimeToMinutes(matches[0].group(1)!);
    final closeMinutes = _parseTimeToMinutes(matches[1].group(1)!);
    final nowMinutes = now.hour * 60 + now.minute;

    if (openMinutes == null || closeMinutes == null) return false;

    if (closeMinutes > openMinutes) {
      // Normal range: e.g. 8:00 AM (480) - 10:00 PM (1320)
      return nowMinutes >= openMinutes && nowMinutes < closeMinutes;
    } else {
      // Midnight-crossing: e.g. 11:00 PM (1380) - 2:00 AM (120)
      return nowMinutes >= openMinutes || nowMinutes < closeMinutes;
    }
  }

  /// Converts a time string like "10:30 AM" or "9 PM" to minutes since midnight.
  static int? _parseTimeToMinutes(String timeStr) {
    final match = RegExp(
      r'(\d{1,2})(?::(\d{2}))?\s*([aApP][mM])',
    ).firstMatch(timeStr.trim());
    if (match == null) return null;

    int hour = int.parse(match.group(1)!);
    final int minute = int.tryParse(match.group(2) ?? '0') ?? 0;
    final String meridiem = match.group(3)!.toLowerCase();

    if (meridiem == 'am') {
      if (hour == 12) hour = 0; // 12:xx AM → 0:xx
    } else {
      if (hour != 12) hour += 12; // 1-11 PM → 13-23
    }

    return hour * 60 + minute;
  }
}
