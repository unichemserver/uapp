import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Modern Date Range Picker Utils dengan desain yang lebih fresh dan contemporary
class DateRangePickerUtils {
  // Format untuk menampilkan tanggal
  static final DateFormat _displayFormat = DateFormat('dd MMM yyyy');
  // static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');
  
  // Modern color scheme dengan gradient dan shadows
  static const Color primaryColor = Color(0xFF0D47A1); // Indigo modern
  static const Color secondaryColor = Color(0xFF1E88E5); // Purple accent
  static const Color surfaceColor = Color(0xFFFAFAFA);
  static const Color onSurfaceColor = Color(0xFF1F2937);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color hoverColor = Color(0xFFF3F4F6);
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Menampilkan modern date range picker dengan custom styling
  static Future<DateTimeRange?> showModernDateRangePicker({
    required BuildContext context,
    required DateTimeRange initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
    String? cancelText,
    String? confirmText,
    bool useRootNavigator = true,
    Locale? locale,
  }) async {
    // Nilai default
    firstDate ??= DateTime.now().subtract(const Duration(days: 365 * 2));
    lastDate ??= DateTime.now().add(const Duration(days: 365));
    helpText ??= 'Pilih Rentang Tanggal';
    cancelText ??= 'Batal';
    confirmText ??= 'Pilih';
    
    return showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              secondary: secondaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: onSurfaceColor,
              outline: borderColor,
            ),
            dialogBackgroundColor: Colors.white,
            // useMaterial3: true,
            cardTheme: CardTheme(
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
      locale: locale,
      useRootNavigator: useRootNavigator,
    );
  }
  
  /// Format tanggal dengan style modern
  static String formatDate(DateTime date) {
    return _displayFormat.format(date);
  }
  
  /// Format rentang tanggal dengan pemisah yang lebih elegan
  static String formatDateRange(DateTimeRange dateRange) {
    return '${formatDate(dateRange.start)} → ${formatDate(dateRange.end)}';
  }
  
  /// Predefined date ranges dengan nama yang lebih deskriptif
  static DateTimeRange getLastWeekRange() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = end.subtract(const Duration(days: 6));
    return DateTimeRange(start: start, end: end);
  }
  
  static DateTimeRange getLastMonthRange() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = DateTime(now.year, now.month - 1, now.day);
    return DateTimeRange(start: start, end: end);
  }
  
  static DateTimeRange getLastQuarterRange() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = DateTime(now.year, now.month - 3, now.day);
    return DateTimeRange(start: start, end: end);
  }
  
  static DateTimeRange getYTDRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, 1, 1);
    final end = DateTime(now.year, now.month, now.day);
    return DateTimeRange(start: start, end: end);
  }
  
  static DateTimeRange getThisWeekRange() {
    final now = DateTime.now();
    final weekday = now.weekday;
    final start = now.subtract(Duration(days: weekday - 1));
    final end = now.add(Duration(days: 7 - weekday));
    return DateTimeRange(
      start: DateTime(start.year, start.month, start.day),
      end: DateTime(end.year, end.month, end.day),
    );
  }
  
  static DateTimeRange getThisMonthRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return DateTimeRange(start: start, end: end);
  }
  
  /// Modern date range selector dengan glassmorphism dan micro-interactions
  static Widget buildDateRangeSelector({
    required DateTimeRange dateRange,
    required Function(DateTimeRange) onDateRangeChanged,
    EdgeInsets padding = const EdgeInsets.all(16),
    bool showPresets = true,
    String? label,
  }) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label != null) ...[
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Expanded(
                    child: _buildDateRangeTile(
                      context: context,
                      dateRange: dateRange,
                      onTap: () async {
                        final result = await showModernDateRangePicker(
                          context: context,
                          initialDateRange: dateRange,
                          locale: Localizations.localeOf(context),
                        );
                        if (result != null) {
                          onDateRangeChanged(result);
                        }
                      },
                    ),
                  ),
                  if (showPresets) ...[
                    const SizedBox(width: 12),
                    _buildPresetsButton(
                      context: context,
                      onRangeSelected: onDateRangeChanged,
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Tile untuk menampilkan date range dengan desain modern
  static Widget _buildDateRangeTile({
    required BuildContext context,
    required DateTimeRange dateRange,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: surfaceColor,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatDateRange(dateRange),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: onSurfaceColor,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${dateRange.durationInDays} hari',
                      style: TextStyle(
                        fontSize: 12,
                        color: onSurfaceColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: onSurfaceColor.withOpacity(0.6),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Button untuk menampilkan preset date ranges
  static Widget _buildPresetsButton({
    required BuildContext context,
    required Function(DateTimeRange) onRangeSelected,
  }) {
    return PopupMenuButton<DateTimeRange>(
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.tune_rounded,
          color: onSurfaceColor.withOpacity(0.7),
          size: 20,
        ),
      ),
      tooltip: 'Pilihan Cepat',
      onSelected: onRangeSelected,
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      itemBuilder: (context) => [
        _buildPopupMenuItem('Hari Ini', _getTodayRange(), Icons.today_rounded),
        _buildPopupMenuItem('Minggu Ini', getThisWeekRange(), Icons.view_week_rounded),
        _buildPopupMenuItem('Bulan Ini', getThisMonthRange(), Icons.calendar_view_month_rounded),
        const PopupMenuDivider(),
        _buildPopupMenuItem('7 Hari Terakhir', getLastWeekRange(), Icons.history_rounded),
        _buildPopupMenuItem('30 Hari Terakhir', getLastMonthRange(), Icons.history_rounded),
        _buildPopupMenuItem('3 Bulan Terakhir', getLastQuarterRange(), Icons.history_rounded),
        _buildPopupMenuItem('Tahun Berjalan', getYTDRange(), Icons.calendar_today_rounded),
      ],
    );
  }
  
  /// Helper untuk membuat popup menu item dengan icon
  static PopupMenuItem<DateTimeRange> _buildPopupMenuItem(
    String title,
    DateTimeRange range,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: range,
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: onSurfaceColor.withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Helper untuk mendapatkan range hari ini
  static DateTimeRange _getTodayRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTimeRange(start: today, end: today);
  }
  
  /// Widget untuk menampilkan quick presets dalam bentuk chips
  static Widget buildQuickPresets({
    required Function(DateTimeRange) onRangeSelected,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16),
  }) {
    final presets = [
      {'title': 'Hari Ini', 'range': _getTodayRange()},
      {'title': '7 Hari', 'range': getLastWeekRange()},
      {'title': '30 Hari', 'range': getLastMonthRange()},
      {'title': 'YTD', 'range': getYTDRange()},
    ];
    
    return Padding(
      padding: padding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: presets.map((preset) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Text(
                  preset['title'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () => onRangeSelected(preset['range'] as DateTimeRange),
                backgroundColor: surfaceColor,
                side: const BorderSide(color: borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Extension dengan method tambahan untuk functionality yang lebih lengkap
extension ModernDateTimeRangeExtension on DateTimeRange {
  /// Durasi rentang tanggal dalam hari
  int get durationInDays => end.difference(start).inDays + 1;
  
  /// Menghasilkan list tanggal dalam rentang
  List<DateTime> get daysInRange {
    final days = <DateTime>[];
    for (int i = 0; i < durationInDays; i++) {
      days.add(DateTime(
        start.year,
        start.month,
        start.day + i,
      ));
    }
    return days;
  }
  
  /// Memeriksa apakah sebuah tanggal dalam rentang ini
  bool containsDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    return (d.isAtSameMomentAs(s) || d.isAfter(s)) && 
           (d.isAtSameMomentAs(e) || d.isBefore(e));
  }
  
  /// Menampilkan format range sebagai string dengan style modern
  String formatModern() {
    return DateRangePickerUtils.formatDateRange(this);
  }
  
  /// Mendapatkan deskripsi range yang user-friendly
  String get friendlyDescription {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (start.isAtSameMomentAs(today) && end.isAtSameMomentAs(today)) {
      return 'Hari ini';
    } else if (durationInDays == 7) {
      return '7 hari';
    } else if (durationInDays == 30) {
      return '30 hari';
    } else if (durationInDays <= 7) {
      return '$durationInDays hari';
    } else if (durationInDays <= 30) {
      return '${(durationInDays / 7).round()} minggu';
    } else {
      return '${(durationInDays / 30).round()} bulan';
    }
  }
}