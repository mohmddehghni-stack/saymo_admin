import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'services/api_service.dart'; // ← اضافه کن (اگر ایمپورت نشده)

void main() {
  ApiService.loadToken(); // ← این خط رو اضافه کن
  runApp(MaterialApp(home: LoginPage(), debugShowCheckedModeBanner: false));
}
