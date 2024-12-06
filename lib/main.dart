import 'package:flutter/material.dart';
import 'package:mobile_developer_assignment/Screens/HomeScreen.dart';
import 'package:mobile_developer_assignment/ViewModel/ItemViewModel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.blue[900]),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[900]!),
            ),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
