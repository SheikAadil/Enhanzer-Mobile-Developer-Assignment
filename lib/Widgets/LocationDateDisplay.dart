import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_developer_assignment/Widgets/OfficeLocationDropDown.dart';

class LocationDateDisplay extends StatelessWidget {
  final String selectedValue;
  final Function(String?) onChanged;

  LocationDateDisplay({required this.selectedValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OfficeLocationDropdown(
            selectedValue: selectedValue,
            onChanged: onChanged,
          ),
          Text(
            DateFormat('yyyy-MM-dd').format(DateTime.now()),
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
