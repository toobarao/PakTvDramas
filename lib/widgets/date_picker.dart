import 'package:flutter/material.dart';



class DatePickerScreen extends StatefulWidget {
  @override
  _DatePickerScreenState createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.red, // Header background color
            hintColor: Colors.red, // Calendar active dates
            colorScheme: ColorScheme.light(
              primary: Colors.red, // Selected date & active elements
              onPrimary: Colors.white, // Text on top of primary color
              onSurface: Colors.black, // Text on calendar
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Red Themed Date Picker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedDate == null
                  ? "Select a Date"
                  : "Selected Date: ${selectedDate!.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button color
                foregroundColor: Colors.white, // Text color
              ),
              child: Text("Pick a Date"),
            ),
          ],
        ),
      ),
    );
  }
}
