// lib/screens/register_page.dart

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/colors.dart';
import '../constants/config.dart';
import 'email_verification_page.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _phone = TextEditingController();
  final _birth = TextEditingController();
  bool _showPass = false;
  bool _loading = false;

  String _parseBirth(String s) {
    final parts = s.split('-');
    if (parts.length != 3) return '';
    return '${parts[2]}-${parts[1]}-${parts[0]}T00:00:00.000Z';
  }

  Future<void> _register() async {
    if (_pass.text != _confirm.text) {
      _alert('Lỗi', 'Mật khẩu không khớp');
      return;
    }
    final iso = _parseBirth(_birth.text);
    if (iso.isEmpty) {
      _alert('Lỗi', 'Ngày sinh sai định dạng (dd-mm-yyyy)');
      return;
    }

    setState(() => _loading = true);

    try {
      final res = await http.post(
        Uri.parse('$BASE_URL/api/v1/auth/regist'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _email.text.trim(),
          'password': _pass.text,
          'first_name': _first.text.trim(),
          'last_name': _last.text.trim(),
          'phone': _phone.text.trim(),
          'birth': iso,
        }),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _alert('Thông báo', 'OTP đã được gửi đến email');
        Navigator.pushNamed(
          context,
          EmailVerificationPage.routeName,
          arguments: _email.text.trim(),
        );
      } else {
        _alert('Lỗi', data['message'] ?? 'Đăng ký thất bại');
      }
    } catch (e) {
      _alert('Lỗi', 'Có lỗi xảy ra, vui lòng thử lại');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _alert(String title, String msg) {
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

  String _hintFor(TextEditingController c) {
    if (c == _email) return 'Email';
    if (c == _pass) return 'Mật khẩu';
    if (c == _confirm) return 'Xác nhận mật khẩu';
    if (c == _last) return 'Họ';
    if (c == _first) return 'Tên';
    if (c == _phone) return 'Số điện thoại';
    return 'Ngày sinh (dd-mm-yyyy)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: BackButton(color: AppColors.black),
              ),
              SizedBox(height: 8),
              Text(
                'Đăng ký',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              ...[_email, _pass, _confirm, _last, _first, _phone, _birth].map(
                (ctrl) {
                  final isPassword = ctrl == _pass || ctrl == _confirm;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: ctrl,
                      obscureText: isPassword && !_showPass,
                      keyboardType: ctrl == _phone ? TextInputType.phone : TextInputType.text,
                      decoration: InputDecoration(
                        hintText: _hintFor(ctrl),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: isPassword
                            ? IconButton(
                                icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _showPass = !_showPass),
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bạn đã có tài khoản? '),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Đăng nhập', style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: Size(double.infinity, 50),
                        shape: StadiumBorder(),
                      ),
                      child: Text('Đăng ký'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
