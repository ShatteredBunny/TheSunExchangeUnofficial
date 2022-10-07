// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:the_sun_exchange_unofficial/splash.dart';
import 'package:the_sun_exchange_unofficial/home.dart';

import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Solar Cells',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(255, 250, 182, 0),
            secondary: const Color.fromARGB(255, 70, 70, 70)),
            backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      ),
      routes: <String, WidgetBuilder>{
        'login': (BuildContext context) => const LoginWidget(),
        'user': (BuildContext context) => const HomeWidget(),
      },
      home: const SplashWidget(),
    );
  }
}
