import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../style.dart';
import 'customButton.dart';

class CustomDatePicker extends StatefulWidget {
  final ValueChanged<DateTime?> selectedTime;
  final bool joinDate;

  const CustomDatePicker({
    required this.selectedTime,
    required this.joinDate,
    super.key,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime focusDate = DateTime.now();
  DateTime? selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  DateTime getNextMonday(DateTime dateTime) {
    return dateTime.add(Duration(days: (8 - dateTime.weekday) % 7));
  }

  DateTime getNextTuesday(DateTime dateTime) {
    return dateTime.add(Duration(days: (9 - dateTime.weekday) % 7));
  }

  Widget _buildShortcutButton(String title, DateTime? dateTime) {
    bool isSelected = dateTime == null ? selectedDate == null : isSameDay(selectedDate, dateTime);
    return InkWell(
      onTap: () => setState(() {
        selectedDate = dateTime;
        focusDate = dateTime ?? DateTime.now();
      }),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isSelected
              ? Theme.of(context).primaryColor
              : AppColors.buttonLight,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 12,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            child: widget.joinDate ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildShortcutButton(
                        'Today',
                        DateTime.now(),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _buildShortcutButton(
                        'Next Monday',
                        getNextMonday(
                          DateTime.now(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildShortcutButton(
                        'Next Tuesday',
                        getNextTuesday(
                          DateTime.now(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _buildShortcutButton(
                        'After 1 week',
                        DateTime.now().add(
                          const Duration(days: 7),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ) : Row(
              children: [
                Expanded(
                  child: _buildShortcutButton(
                    'No date',
                    null,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: _buildShortcutButton(
                    'Today',
                    DateTime.now(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          focusDate = DateTime(focusDate.year,
                              focusDate.month - 1, focusDate.day);
                        });
                      },
                      icon: Icon(
                        Icons.arrow_left,
                        size: 28,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(focusDate),
                      style: Theme.of(context).textTheme.bodySmall,
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: true,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          focusDate = DateTime(focusDate.year,
                              focusDate.month + 1, focusDate.day);
                        });
                      },
                      icon: Icon(
                        Icons.arrow_right,
                        size: 28,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TableCalendar(
                  focusedDay: focusDate,
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      selectedDate = selectedDay;
                      focusDate = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      focusDate = focusedDay;
                    });
                  },
                  headerVisible: false,
                  daysOfWeekHeight: 20,
                  rowHeight: 35,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: Theme.of(context).textTheme.labelMedium!,
                    weekendStyle: Theme.of(context).textTheme.labelMedium!,
                  ),
                  calendarStyle: CalendarStyle(
                    canMarkersOverflow: false,
                    outsideDaysVisible: false,
                    cellAlignment: Alignment.center,
                    markersAlignment: Alignment.center,
                    markersAnchor: 0.1,
                    markersAutoAligned: true,
                    cellMargin: EdgeInsets.zero,
                    selectedDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    todayTextStyle:
                        Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                    weekendTextStyle:
                        Theme.of(context).textTheme.labelMedium!.copyWith(),
                    selectedTextStyle:
                        Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: Colors.white,
                            ),
                    defaultTextStyle:
                        Theme.of(context).textTheme.labelMedium!.copyWith(),
                  ),
                  firstDay: DateTime.utc(
                    2010,
                    10,
                    16,
                  ),
                  lastDay: DateTime.utc(
                    2050,
                    12,
                    10,
                  ),
                  calendarFormat: _calendarFormat,
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black12,
                  width: 2,
                ),
              ),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.today,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          selectedDate == null ? 'No date' : DateFormat('dd MMM yyyy').format(selectedDate!),
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomButton(
                          buttonText: 'Cancel',
                          buttonColor: AppColors.buttonLight,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          textStyle:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: CustomButton(
                          buttonText: 'Save',
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          textStyle:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                          onPressed: () {
                            widget.selectedTime(selectedDate);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
