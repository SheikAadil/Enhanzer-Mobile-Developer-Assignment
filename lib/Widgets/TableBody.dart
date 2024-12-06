import 'package:flutter/material.dart';

class TableBody extends StatelessWidget {
  final List<Map<String, dynamic>> addedItems;

  const TableBody({super.key, required this.addedItems});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: addedItems.length,
        itemBuilder: (context, index) {
          final item = addedItems[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text(item['name'], textAlign: TextAlign.center)),
                Expanded(
                    flex: 2,
                    child:
                        Text('${item['price']}', textAlign: TextAlign.center)),
                Expanded(
                    flex: 2,
                    child: Text('${item['quantity']}',
                        textAlign: TextAlign.center)),
                Expanded(
                    flex: 2,
                    child: Text('${item['discount']}%',
                        textAlign: TextAlign.center)),
                Expanded(
                    flex: 2,
                    child:
                        Text('${item['amount']}', textAlign: TextAlign.center)),
              ],
            ),
          );
        },
      ),
    );
  }
}
