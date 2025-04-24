// lib/screens/reset_password_page.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/colors.dart';
import '../constants/config.dart';

class ResetPasswordPage extends StatefulWidget {
  static const routeName = '/reset-password';
  @override _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late String email;
  List<String> otp = List.filled(6, '');
  final _new = TextEditingController();
  final _confirm = TextEditingController();
  bool verified = false;
  bool loading = false;
  List<FocusNode> fns = List.generate(6, (_) => FocusNode());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    email = ModalRoute.of(context)!.settings.arguments as String;
    fns[0].requestFocus();
  }

  void _verifyOTP() async {
    final code = otp.join();
    if (code.length < 6) return;
    setState(() => loading = true);
    final res = await http.post(Uri.parse('\$BASE_URL/api/v1/auth/verify-reset-otp'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({'email': email, 'otp': code}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode == 200) setState(() => verified = true);
    else _show('Lỗi', data['message']);
    setState(() => loading = false);
  }

  void _resetPass() async {
    if (_new.text != _confirm.text) return;
    setState(() => loading = true);
    final res = await http.post(Uri.parse('\$BASE_URL/api/v1/auth/reset-password'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({'email': email, 'newPassword': _new.text}),
    );
    if (res.statusCode==200) Navigator.pushReplacementNamed(context, '/login');
    else _show('Lỗi', jsonDecode(res.body)['message']);
    setState(() => loading = false);
  }

  void _show(String t, String m)=> showDialog(
    context: context, builder:(_)=> AlertDialog(title: Text(t),content:Text(m),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:Text('OK'))]),
  );

  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Đặt lại mật khẩu'), backgroundColor: AppColors.primary),
      body: Padding(
        padding:EdgeInsets.all(20),
        child: verified ? Column(
          children: [
            TextField(controller: _new, decoration: InputDecoration(hintText:'Mật khẩu mới')),
            TextField(controller: _confirm, decoration: InputDecoration(hintText:'Xác nhận mật khẩu')),
            SizedBox(height:20),
            ElevatedButton(onPressed:_resetPass, child:Text('Đặt lại'))
          ],
        ) : Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) => SizedBox(
                width:40,
                child: TextField(
                  focusNode: fns[i], maxLength:1,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged:(v){otp[i]=v; if(v.isNotEmpty && i<5) fns[i+1].requestFocus();},
                ),
              )),
            ),
            SizedBox(height:20),
            ElevatedButton(onPressed:_verifyOTP, child:Text('Xác thực OTP'))
          ],
        ),
      ),
    );
  }
}
