// lib/screens/email_verification_page.dart

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/colors.dart';
import '../constants/config.dart';
import 'login_page.dart';

class EmailVerificationPage extends StatefulWidget {
  static const routeName = '/verify-email';
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late String email;
  final _otp = TextEditingController();
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    email = ModalRoute.of(context)!.settings.arguments as String;
  }

  Future<void> _verify() async {
    if (_otp.text.isEmpty) return;
    setState(() => _loading = true);

    try {
      final res = await http.post(
        Uri.parse('$BASE_URL/api/v1/auth/verify-register-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': _otp.text}),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      } else {
        _show('Lỗi', data['message'] ?? 'Xác thực thất bại');
      }
    } catch (e) {
      _show('Lỗi', 'Có lỗi xảy ra, vui lòng thử lại');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _show(String title, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Xác thực Email'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Đã gửi mã OTP tới: $email'),
            SizedBox(height: 16),
            TextField(
              controller: _otp,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Nhập OTP',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: Size(double.infinity, 50),
                      shape: StadiumBorder(),
                    ),
                    child: Text('Xác thực'),
                  ),
          ],
        ),
      ),
    );
  }
}
