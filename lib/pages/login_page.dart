import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'tickets_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  void _login() async {
    final ok = await ApiService.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TicketsPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ورود ناموفق')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'پنل ادمین',
                style: TextStyle(fontSize: 24, fontFamily: 'Vazir'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(labelText: 'ایمیل'),
              ),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: InputDecoration(labelText: 'رمز'),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _login, child: Text('ورود')),
            ],
          ),
        ),
      ),
    );
  }
}
