import 'package:flight_delay_app/src/constants/variables.dart';
import 'package:flight_delay_app/src/screens/flight_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calendar.dart';

class FlightSearchBar extends StatefulWidget {
  final Function(String flightNumber, DateTime? date) onSearch;

  const FlightSearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  _FlightSearchBarState createState() => _FlightSearchBarState();
}

class _FlightSearchBarState extends State<FlightSearchBar> {
  final TextEditingController _flightNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  final FocusNode _flightNumberFocus = FocusNode();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showCalendar(
      context,
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 14)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMM dd, yyyy').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _flightNumberController.dispose();
    _dateController.dispose();
    _flightNumberFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double smallSizedBoxHeight(height) => height < 600 ? 5 : 8;
    double bigSizedBoxHeight(height) => height < 600 ? 20 : 30;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search Flights',
                style: TextStyle(
                  fontSize: Variables.responsiveFontSize(context, 25),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.flight,
                          color: Colors.black,
                          size: Variables.responsiveIconSize(context, 30),
                        ),
                        SizedBox(height: smallSizedBoxHeight(screenHeight)),
                        Text(
                          'Flight Number',
                          style: TextStyle(
                            fontSize: Variables.responsiveFontSize(context, 18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: smallSizedBoxHeight(screenHeight)),
                        TextField(
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          controller: _flightNumberController,
                          focusNode: _flightNumberFocus,
                          decoration: InputDecoration(
                            hintText: 'e.g. AK6118',
                            hintStyle: Variables.hintStyle(context),
                            fillColor: Colors.grey[200],
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => _selectDate(context),
                          onChanged: (value) {
                            String upper = value.toUpperCase();

                            if (value != upper) {
                              _flightNumberController.value = TextEditingValue(
                                text: upper,
                                selection: TextSelection.collapsed(
                                    offset: upper
                                        .length), // Preserve cursor position
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 60),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                        SizedBox(height: smallSizedBoxHeight(screenHeight)),
                        Text(
                          'Date',
                          style: TextStyle(
                            fontSize: Variables.responsiveFontSize(context, 18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: smallSizedBoxHeight(screenHeight)),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: IgnorePointer(
                            // Prevents focus when tapped
                            child: TextField(
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              controller: _dateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: _selectedDate == null
                                    ? DateFormat('MMM dd, yyyy')
                                        .format(DateTime.now())
                                    : DateFormat('MMM dd, yyyy')
                                        .format(_selectedDate!),
                                hintStyle: Variables.hintStyle(context),
                                fillColor: Colors.grey[200],
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: bigSizedBoxHeight(screenHeight)),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            onPressed: () {
              if (_flightNumberController.text.isNotEmpty &&
                  _dateController.text.isNotEmpty) {
                print('DEBUG: Input validation passed, performing search');

                // Call the search function and get the result
                final flightData = widget.onSearch(
                    _flightNumberController.text, _selectedDate);

                print('DEBUG: Search result returned: $flightData');

                // Unfocus the current field
                FocusScope.of(context).unfocus();

                // If the flight was found, navigate to the FlightInfo screen
                if (flightData != null) {
                  print('DEBUG: Flight found, navigating to details screen');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlightInfo(
                        flight: flightData,
                      ),
                    ),
                  );
                } else {
                  // Show an error message if the flight wasn't found
                  print('DEBUG: Flight not found, showing error message');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Flight not found. Please check the flight number and date.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                _flightNumberController.clear();
                _dateController.clear();
                _selectedDate = null; // Reset the selected date
              } else {
                _flightNumberFocus.requestFocus();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Variables.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 2,
            ),
            child: Text(
              'C O N N E C T',
              style: TextStyle(
                fontSize: Variables.responsiveFontSize(context, 20),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
