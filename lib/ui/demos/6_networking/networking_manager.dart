import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NetworkingManager {
  final catNotifier = ValueNotifier('');

  Future<void> getRequest() async {
    try {
      final uri = Uri.parse(
        'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/eur.json',
      );
      final response = await get(uri);
      final jsonString = response.body;
      final map = jsonDecode(jsonString);

      catNotifier.value = '${map['eur']['mnt'].toInt()} tugrik';
    } on ClientException catch (e) {
      catNotifier.value = 'Your Internet has a problem';
    }
  }

  Future<void> postRequest() async {}
}
