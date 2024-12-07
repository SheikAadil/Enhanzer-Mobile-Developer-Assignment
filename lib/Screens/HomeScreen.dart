import 'package:flutter/material.dart';
import 'package:mobile_developer_assignment/Widgets/LocationDateDisplay.dart';
import 'package:mobile_developer_assignment/Widgets/NetAmountDisplay.dart';
import 'package:mobile_developer_assignment/Widgets/PrimaryButton.dart';
import 'package:mobile_developer_assignment/Widgets/TabBar.dart';
import 'package:mobile_developer_assignment/Widgets/TabBarItem.dart';
import 'package:mobile_developer_assignment/Widgets/TableBody.dart';
import 'package:mobile_developer_assignment/Widgets/TableHeader.dart';
import 'package:mobile_developer_assignment/Services/DatabaseHelper.dart';
import 'package:provider/provider.dart';
import 'package:mobile_developer_assignment/ViewModel/ItemViewModel.dart';
import 'package:mobile_developer_assignment/Model/Item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController itemController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  List<Map<String, dynamic>> addedItems = [];
  List<Map<String, dynamic>> transactions = [];
  Item? selectedItem;
  double netTotal = 0.0;
  String selectedOffice = 'Auckland Office';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    fetchItems();
    fetchTransactions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    netTotal = addedItems.fold(
      0.0,
      (sum, item) => sum + (item['amount'] ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text(
          "Quotation",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.sticky_note_2,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.reply,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            LocationDateDisplay(
              selectedValue: selectedOffice,
              onChanged: onDropdownChanged,
            ),
            CustomTabBar(
              tabController: _tabController,
              tabs: const [
                TabBarItem(title: 'General'),
                TabBarItem(title: 'Items'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        NetAmountDisplay(netTotal: netTotal),
                        const SizedBox(height: 16),
                        Autocomplete<Item>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<Item>.empty();
                            }
                            return Provider.of<ItemViewModel>(context,
                                    listen: false)
                                .items
                                .where((item) => item.name
                                    .toLowerCase()
                                    .contains(
                                        textEditingValue.text.toLowerCase()));
                          },
                          displayStringForOption: (Item item) => item.name,
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted) {
                            itemController = fieldTextEditingController;
                            return TextField(
                              controller: itemController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                labelText: "Item",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue[900]!),
                                ),
                              ),
                            );
                          },
                          onSelected: (Item selected) {
                            setState(() {
                              selectedItem = selected;
                              priceController.text = selected.price.toString();
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: priceController,
                          decoration: const InputDecoration(labelText: "Price"),
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: quantityController,
                                decoration: const InputDecoration(
                                    labelText: "Quantity"),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: discountController,
                                decoration: const InputDecoration(
                                    labelText: "Discount (%)"),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            PrimaryButton(
                              onTap: addItemToTable,
                              text: 'ADD',
                              textColor: Colors.white,
                              fontSize: 15.0,
                              buttonColor: Colors.blue[900],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const TableHeader(),
                        TableBody(addedItems: addedItems),
                      ],
                    ),
                  ),
                  transactions.isEmpty
                      ? const Center(
                          child: Text(
                            "No saved records yet.",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )
                      : ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(transaction['name']),
                                subtitle: Text(
                                  'Price: ${transaction['price']}, Qty: ${transaction['quantity']}, Discount: ${transaction['discount']}%, Amount: ${transaction['amount']}',
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: addedItems.isNotEmpty
          ? FloatingActionButton(
              onPressed: saveTransaction,
              backgroundColor: Colors.blue[900],
              child: const Icon(
                Icons.save,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  void onDropdownChanged(String? newValue) {
    setState(() {
      selectedOffice = newValue ?? 'Auckland Office';
    });
  }

  void addItemToTable() {
    if (selectedItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an item!")),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final price = double.tryParse(priceController.text) ?? 0;
    final quantity = int.tryParse(quantityController.text) ?? 1;
    final discount = double.tryParse(discountController.text) ?? 0;
    final amount = (price * quantity) * (100 - discount) / 100;

    setState(() {
      addedItems.add({
        'name': selectedItem!.name,
        'price': price,
        'quantity': quantity,
        'discount': discount,
        'amount': amount,
      });

      itemController.clear();
      priceController.clear();
      quantityController.clear();
      discountController.clear();
      selectedItem = null;
    });
  }

  Future<void> saveTransaction() async {
    FocusScope.of(context).unfocus();

    for (var item in addedItems) {
      await DatabaseHelper.instance.saveTransaction({
        'name': item['name'],
        'price': item['price'],
        'quantity': item['quantity'],
        'discount': item['discount'],
        'amount': item['amount'],
      });
    }

    await fetchTransactions();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data saved successfully!")),
    );

    setState(() {
      addedItems.clear();
      itemController.clear();
      priceController.clear();
      quantityController.clear();
      discountController.clear();
      selectedItem = null;
    });
  }

  Future<void> fetchTransactions() async {
    final data = await DatabaseHelper.instance.getTransactions();
    setState(() {
      transactions = data;
    });
  }

  Future<void> fetchItems() async {
    final itemVM = Provider.of<ItemViewModel>(context, listen: false);
    await itemVM.fetchItems();
  }
}
