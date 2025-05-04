import 'package:flight_delay_app/src/constants/variables.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// This function shows the calendar as a dialog with action buttons
Future<DateTime?> showCalendar(
  BuildContext context, {
  DateTime? minDate,
  DateTime? maxDate,
  bool maxDateEndOfYear = false,
}) async {
  DateTime? selectedDate;
  return await showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: CalendarWidget(
          minDate: minDate ?? DateTime(2022, 1, 1),
          maxDate: maxDate,
          maxDateEndOfYear: maxDateEndOfYear,
          showActionButtons: true,
          onDateSelected: (date) {
            selectedDate = date;
          },
          onSubmit: () {
            Navigator.of(context).pop(selectedDate);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      );
    },
  );
}

class CalendarWidget extends StatefulWidget {
  final DateTime minDate;
  final DateTime? maxDate;
  final bool maxDateEndOfYear;
  final Function(DateTime) onDateSelected;
  final bool showActionButtons;
  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;
  final bool showNavigationArrow;

  const CalendarWidget({
    super.key,
    required this.minDate,
    this.maxDate,
    this.maxDateEndOfYear = false,
    required this.onDateSelected,
    this.showActionButtons = false,
    this.onSubmit,
    this.onCancel,
    this.showNavigationArrow = true,
  });

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime effectiveMaxDate = widget.maxDateEndOfYear
        ? DateTime(DateTime.now().year, 12, 31)
        : widget.maxDate ?? DateTime(DateTime.now().year, 12, 31);

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfDateRangePicker(
          initialSelectedDate: _selectedDate,
          minDate: widget.minDate,
          maxDate: effectiveMaxDate,
          todayHighlightColor: Colors.transparent,
          backgroundColor: Colors.white,
          selectionColor: Variables.primaryColor,
          selectionTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          monthViewSettings: const DateRangePickerMonthViewSettings(
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
              textStyle: TextStyle(color: Variables.primaryColor),
            ),
          ),
          monthCellStyle: const DateRangePickerMonthCellStyle(
            textStyle: TextStyle(
              color: Variables.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            disabledDatesTextStyle: TextStyle(
              color: Colors.grey,
            ),
            todayTextStyle: TextStyle(
              color: Variables.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          yearCellStyle: const DateRangePickerYearCellStyle(
            disabledDatesTextStyle: TextStyle(color: Colors.white24),
          ),
          headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: Colors.white,
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: Variables.responsiveFontSize(context, 20),
            ),
          ),
          headerHeight: 60,
          showNavigationArrow: widget.showNavigationArrow,
          showActionButtons: widget.showActionButtons,
          onCancel: widget.onCancel,
          onSubmit: (_) {
            if (_selectedDate != null) {
              widget.onDateSelected(_selectedDate!);
            }
            if (widget.onSubmit != null) {
              widget.onSubmit!();
            }
          },
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            if (args.value is DateTime) {
              setState(() {
                _selectedDate = args.value;
              });
              widget.onDateSelected(_selectedDate!);
            }
          },
        ),
      ),
    );
  }
}
