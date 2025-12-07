// lib/contract_linking.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart'; // pour Web3Client http backend
import 'package:web3dart/web3dart.dart';

class ContractLinking extends ChangeNotifier {
  // RPC URL de Ganache (GUI)
  final String _rpcUrl = "http://127.0.0.1:7545";
  // Si tu utilises ws, tu peux mettre ws://127.0.0.1:7545/ mais Web3Client http suffit pour les appels simples
  final String _privateKey =
      "0x9d0fa8f5b1386db36128f9e6b3b475dd22aa614bd964dfd324216b84be33c593"; // <-- remplace par la clé privée d'un compte Ganache

  late Web3Client _client;
  bool isLoading = true;

  late String _abiCode;
  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;

  late ContractFunction _yourName;
  late ContractFunction _setName;

  String deployedName = "";

  ContractLinking() {
    initialSetup();
  }

  Future<void> initialSetup() async {
    // client HTTP (fonctionne pour Flutter Web)
    _client = Web3Client(_rpcUrl, Client());
    await _getAbi();
    await _getCredentials();
    await _getDeployedContract();
  }

  Future<void> _getAbi() async {
    String abiStringFile = await rootBundle.loadString(
      "src/artifacts/HelloWorld.json",
    );
    final jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);

    // networks key: use Ganache network id (usually "5777") — Truffle wrote l'adresse ici
    final network = jsonAbi["networks"].keys.first;
    final addressHex = jsonAbi["networks"][network]["address"] as String;
    _contractAddress = EthereumAddress.fromHex(addressHex);
  }

  Future<void> _getCredentials() async {
    // Warning: garder la clé privée secrète. Ici seulement pour dev local.
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> _getDeployedContract() async {
    _contract = DeployedContract(
      ContractAbi.fromJson(_abiCode, "HelloWorld"),
      _contractAddress,
    );

    _yourName = _contract.function("yourName");
    _setName = _contract.function("setName");

    await getName();
  }

  Future<void> getName() async {
    try {
      final result = await _client.call(
        contract: _contract,
        function: _yourName,
        params: [],
      );
      deployedName = result[0] as String;
    } catch (e) {
      deployedName = "Error";
      debugPrint("getName error: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> setName(String nameToSet) async {
    isLoading = true;
    notifyListeners();

    try {
      // Envoie transaction signée (client local Ganache traite la transaction)
      await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _setName,
          parameters: [nameToSet],
        ),
        chainId: 1337, // ⚠️ CHAINE GANACHE (très important)
      );

      await getName();
    } catch (e) {
      debugPrint("setName error: $e");
      isLoading = false;
      notifyListeners();
    }
  }
}
