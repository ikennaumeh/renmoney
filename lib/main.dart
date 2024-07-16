import 'package:flutter/material.dart';
import 'package:renmoney_test/app.dart';

import 'services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const WeatherApp());
}
