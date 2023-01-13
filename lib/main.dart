import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'firebase_options.dart';

// firebase cli

// flutterfire_cli

// https://firebase.google.com/docs/flutter/setup?authuser=0&hl=en&platform=ios 
// flutter di firebasege bailady

// https://firebase.google.com/docs/firestore/quickstart?authuser=0&hl=en
// read data
// add data
// update data
// delete data

// CRUD: create, read, update, delete

// flash chat, bloc, context try catch, stream,

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
