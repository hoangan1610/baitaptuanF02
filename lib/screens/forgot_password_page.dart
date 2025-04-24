// lib/screens/forgot_password_page.dart
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = '/forgot';
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _sendOTP() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      _showDialog('Lỗi', 'Vui lòng nhập email');
      return;
    }
    setState(() => _loading = true);
    try {
      final res = await http.post(
        Uri.parse('\$BASE_URL/api/v1/auth/request-reset-password'.replaceFirst(r'$BASE_URL', BASE_URL)),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _showDialog('Thành công', data['message']);
        Navigator.pushNamed(context, ResetPasswordPage.routeName, arguments: email);
      } else {
        _showDialog('Lỗi', data['message'] ?? 'Có lỗi xảy ra');
      }
    } catch (e) {
      _showDialog('Lỗi', 'Có lỗi xảy ra, vui lòng thử lại');
    }
    setState(() => _loading = false);
  }

  void _showDialog(String title, String msg) {
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
      appBar: AppBar(title: Text('Quên mật khẩu'), backgroundColor: AppColors.primary),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: InputDecoration(
                hintText: 'Nhập email của bạn',
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            _loading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _sendOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: StadiumBorder(),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Gửi OTP', style: TextStyle(fontSize: 16)),
                ),
          ],
        ),
      ),
    );
  }
}
