import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/data/models/slot.dart';
import 'package:sanam_laundry/presentation/index.dart';

class MonthsDateListing extends StatefulWidget {
  final List<SlotModel?> slots;
  final Function(DateTime) onDateSelected;
  final Function(String) onSlotSelected;
  final String heading;
  final int disabledExtraDays;
  final DateTime?
  baseDate; // if provided, disabledExtraDays counted after this date
  final bool showSlots;

  const MonthsDateListing({
    super.key,
    required this.slots,
    this.heading = "Select Pick-up Date & Time",
    required this.onDateSelected,
    required this.onSlotSelected,
    this.disabledExtraDays = 0,
    this.baseDate,
    this.showSlots = false,
  });

  @override
  State<MonthsDateListing> createState() => _MonthsDateListingState();
}

class _MonthsDateListingState extends State<MonthsDateListing> {
  DateTime _selectedMonth = DateTime.now();
  DateTime? _selectedDate;
  final ScrollController _dateScrollController = ScrollController();
  String selectedSlotId = '';
  @override
  void initState() {
    super.initState();
    // Scroll to current date after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDate();
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void dispose() {
    _dateScrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentDate() {
    final now = DateTime.now();
    final dates = _getDatesInMonth(_selectedMonth);
    final currentDateIndex = dates.indexWhere(
      (date) =>
          date.day == now.day &&
          date.month == now.month &&
          date.year == now.year,
    );

    if (currentDateIndex != -1 && _dateScrollController.hasClients) {
      // Calculate the scroll position (each item is approximately 80 width + 16 margin)
      final scrollPosition = currentDateIndex * 96.0;
      _dateScrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  DateTime get _selectedNextMonth {
    return DateTime(_selectedMonth.year, _selectedMonth.month + 1);
  }

  List<String> get _availableMonths {
    final List<String> months = [];
    final now = DateTime.now();
    // Generate only 2 months (current month and next month)
    for (int i = 0; i < 2; i++) {
      final month = DateTime(now.year, now.month + i);
      months.add(DateFormat('MMMM yyyy').format(month));
    }
    return months;
  }

  String get _currentMonthString {
    final monthString = DateFormat('MMMM yyyy').format(_selectedMonth);
    // If current month is not in available months, return the first available month
    if (!_availableMonths.contains(monthString)) {
      return _availableMonths.first;
    }
    return monthString;
  }

  // List<DateTime> _getDatesInMonth(DateTime month) {
  //   final lastDay = DateTime(month.year, month.month + 1, 0);

  //   return List.generate(
  //     lastDay.day,
  //     (index) => DateTime(month.year, month.month, index + 1),
  //   );
  // }

  List<DateTime> _getDatesInMonth(DateTime month) {
    final now = DateTime.now();
    final lastDay = DateTime(month.year, month.month + 1, 0);

    return List.generate(
      lastDay.day,
      (index) => DateTime(
        month.year,
        month.month,
        index + 1,
        now.hour,
        now.minute,
        now.second,
        now.millisecond,
        now.microsecond,
      ),
    );
  }

  bool _isPastDate(DateTime date) {
    // Use baseDate (e.g., pickup date) if provided; otherwise use today.
    final base = widget.baseDate ?? DateTime.now();
    final baseline = DateTime(
      base.year,
      base.month,
      base.day,
    ).add(Duration(days: widget.disabledExtraDays));
    final checkDate = DateTime(date.year, date.month, date.day);
    return checkDate.isBefore(baseline);
  }

  void _goToNextMonth() {
    setState(() {
      final now = DateTime.now();
      final nextMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
      final maxAllowedMonth = DateTime(now.year, now.month + 1);

      // Only navigate if next month is not beyond the max allowed (current + 1 month)
      if (nextMonth.year < maxAllowedMonth.year ||
          (nextMonth.year == maxAllowedMonth.year &&
              nextMonth.month <= maxAllowedMonth.month)) {
        _selectedMonth = nextMonth;
        // Scroll to beginning of new month
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_dateScrollController.hasClients) {
            _dateScrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  void _onMonthSelected(String? monthString) {
    if (monthString != null) {
      final selectedDate = DateFormat('MMMM yyyy').parse(monthString);
      setState(() {
        _selectedMonth = selectedDate;
      });
      // Scroll based on whether it's current month or not
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final now = DateTime.now();
        if (selectedDate.month == now.month && selectedDate.year == now.year) {
          _scrollToCurrentDate();
        } else if (_dateScrollController.hasClients) {
          _dateScrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spacingM,
      children: [
        AppText(
          widget.heading,
          textAlign: TextAlign.center,
          style: context.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        // Month Navigation
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AppDropdown<String>(
                items: _availableMonths,
                value: _currentMonthString,
                onChanged: _onMonthSelected,
                showBorder: false,
                itemTextStyle: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppText(
                    DateFormat('MMM yyyy').format(_selectedNextMonth),
                    style: context.textTheme.titleMedium!.copyWith(
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppIcon(
                    icon: Icons.chevron_right,
                    color: AppColors.primary,
                    onTap: _goToNextMonth,
                  ),
                ],
              ),
            ),
          ],
        ),

        // Dates with Weekday Names
        SizedBox(
          height: 80,
          child: ListView.builder(
            controller: _dateScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _getDatesInMonth(_selectedMonth).length,
            itemBuilder: (context, index) {
              final date = _getDatesInMonth(_selectedMonth)[index];
              final isPast = _isPastDate(date);
              final isSelected =
                  _selectedDate != null &&
                  _selectedDate!.day == date.day &&
                  _selectedDate!.month == date.month &&
                  _selectedDate!.year == date.year;

              return GestureDetector(
                onTap: isPast
                    ? null
                    : () {
                        setState(() {
                          _selectedDate = date;
                        });
                        widget.onDateSelected(date);
                      },
                child: Opacity(
                  opacity: isPast ? 0.4 : 1.0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimens.spacingXS),
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.spacingXL,
                      vertical: Dimens.spacingS,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isPast
                          ? AppColors.lightGrey.withValues(alpha: 0.3)
                          : AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimens.radiusM),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : isPast
                            ? AppColors.lightGrey
                            : AppColors.border,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          date.day.toString(),
                          style: context.textTheme.headlineMedium!.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : isPast
                                ? AppColors.darkGrey
                                : AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AppText(
                          DateFormat('EEE').format(date),
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : isPast
                                ? AppColors.darkGrey
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        if (widget.showSlots)
          SizedBox(
            height: 50,
            child: ListView.separated(
              separatorBuilder: (context, index) =>
                  SizedBox(width: Dimens.spacingS),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.slots.length,
              itemBuilder: (context, index) {
                final slot = widget.slots[index];
                final id = slot?.id ?? "";
                bool isDisabled = false;

                if (slot == null) {
                  return const SizedBox.shrink();
                }
                // Hide elapsed slots only when selected date is today: compare slot end time mapped onto selected day.
                if (_selectedDate != null) {
                  final selected = DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                  );
                  final isTodaySelected = _isSameDay(selected, DateTime.now());
                  if (isTodaySelected) {
                    final endIso = slot.endTime;

                    DateTime? parseTime12(String timeString) {
                      try {
                        final formatter = DateFormat("h:mm a");
                        return formatter.parse(timeString);
                      } catch (e) {
                        return null;
                      }
                    }

                    if (endIso != null) {
                      final parsed = parseTime12(endIso)?.toLocal();
                      if (parsed != null) {
                        final endOnSelected = DateTime(
                          selected.year,
                          selected.month,
                          selected.day,
                          parsed.hour,
                          parsed.minute,
                          parsed.second,
                        );
                        if (endOnSelected.isBefore(DateTime.now())) {
                          isDisabled = true;
                        }
                      }
                    }
                  }
                }
                return AppButton(
                  title: Utils.capitalize(
                    '${slot.title} ( ${slot.startTime} - ${slot.endTime} )',
                  ),
                  type: selectedSlotId == id || isDisabled
                      ? AppButtonType.elevated
                      : AppButtonType.outlined,
                  width: 0.5,
                  isEnabled: !isDisabled,
                  onPressed: isDisabled
                      ? null
                      : () {
                          setState(() => selectedSlotId = id);
                          widget.onSlotSelected(id);
                        },
                );
              },
            ),
          ),
      ],
    );
  }
}
