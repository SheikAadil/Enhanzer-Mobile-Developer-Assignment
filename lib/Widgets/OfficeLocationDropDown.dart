import 'package:flutter/material.dart';

class OfficeLocationDropdown extends StatelessWidget {
  final String selectedValue;
  final Function(String?) onChanged;

  OfficeLocationDropdown(
      {required this.selectedValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: <String>[
        'Auckland Office',
        'Wellington Office',
        'Christchurch Office'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: Colors.blue[900]),
          ),
        );
      }).toList(),
      underline: const SizedBox(),
      iconEnabledColor: Colors.blue[900],
    );
  }
}
