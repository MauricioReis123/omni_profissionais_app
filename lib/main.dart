import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fixar status bar com transparência e estilo dark neon
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF07090C),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const OmniMarketplaceApp());
}
