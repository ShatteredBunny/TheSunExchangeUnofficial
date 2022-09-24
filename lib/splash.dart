import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:the_sun_exchange_unofficial/login.dart';
import 'package:the_sun_exchange_unofficial/home.dart';

import 'api.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(), _init);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
          child: Text(
        "The Sun Exchange Unofficial",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 40),
      )),
    );
  }

  _init() async {
    const storage = FlutterSecureStorage();
    String? email = await storage.read(key: "email");
    String? password = await storage.read(key: "password");
    if (email == null || password == null) {
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginWidget()));
      }
    } else {
      String? token = await storage.read(key: "token");
      if (token != null) {
        // TODO: check token validity
        Api.get().setToken(token);
      } else {
        await Api.get().login(email, password);
      }
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeWidget()));
      }
    }
  }
}
