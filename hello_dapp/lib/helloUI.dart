// lib/helloUI.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart';

class HelloUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contractLink = Provider.of<ContractLinking>(context);

    final TextEditingController yourNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Hello World DApp"), centerTitle: true),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: contractLink.isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Hello ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 42)),
                          Text(contractLink.deployedName,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 42, color: Colors.tealAccent)),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: TextFormField(
                          controller: yourNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Your Name",
                            hintText: "What is your name?",
                            icon: Icon(Icons.drive_file_rename_outline),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          child: Text('Set Name', style: TextStyle(fontSize: 20)),
                          onPressed: () {
                            final name = yourNameController.text.trim();
                            if (name.isNotEmpty) {
                              contractLink.setName(name);
                              yourNameController.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
