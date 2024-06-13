import 'package:flutter/material.dart';

class ClientDropdown extends StatelessWidget {
  final ValueNotifier<String?> selectedClientNotifier;

  ClientDropdown({required this.selectedClientNotifier});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dropdownItems = [
      {
        'value': 'Entrepreneur',
        'text': 'Entrepreneur',
        'icon': Icons.business_center,
      },
      {
        'value': 'Client',
        'text': 'Client',
        'icon': Icons.person,
      },
    ];

    return ValueListenableBuilder<String?>(
      valueListenable: selectedClientNotifier,
      builder: (context, selectedClient, _) {
        return DropdownButtonFormField<String>(
          value: selectedClient,
          decoration: InputDecoration(
            labelText: 'Select Someone',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          items: dropdownItems.map((item) {
            return DropdownMenuItem<String>(
              value: item['value'],
              child: Row(
                children: [
                  Icon(item['icon']),
                  SizedBox(width: 8),
                  Text(item['text']),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            selectedClientNotifier.value = value;
          },
        );
      },
    );
  }
}
