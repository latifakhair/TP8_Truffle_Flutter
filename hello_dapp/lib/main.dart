// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart';
import 'helloUI.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContractLinking>(
      create: (_) => ContractLinking(),
      child: MaterialApp(
        title: 'Hello DApp',
        theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.teal),
        home: HelloUI(),
      ),
    );
  }
}
