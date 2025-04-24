// lib/screens/phone_verification_page.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/colors.dart';
import '../constants/config.dart';

class PhoneVerificationPage extends StatefulWidget {
  static const routeName = '/verify-phone';
  @override _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  late String phone;
  final _otp = TextEditingController();
  bool loading = false;
  String? error, message;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    phone = ModalRoute.of(context)!.settings.arguments as String;
  }

  Future<void> _verify() async {
    if (_otp.text.isEmpty) return;
    setState(() => loading = true);
    final res = await http.post(Uri.parse('\$BASE_URL/api/v1/auth/verify-phone'), headers:{'Content-Type':'application/json'}, body: jsonEncode({'phone':phone,'otp':_otp.text}));
    final data=jsonDecode(res.body);
    setState(() {error=null;});
    if(res.statusCode==200) {message=data['message']; Navigator.pushNamed(context,'/login');}
    else setState(()=> error=data['message']);
    setState(()=>loading=false);
  }

  Future<void> _resend() async {
    await http.post(Uri.parse('\$BASE_URL/api/v1/auth/resend-otp'), headers:{'Content-Type':'application/json'}, body: jsonEncode({'phone':phone}));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP đã được gửi lại')));
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title:Text('Xác thực số điện thoại'),backgroundColor:AppColors.primary),
      body: Padding(
        padding:EdgeInsets.all(20),child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text('Đã gửi đến: \$phone'),
            TextField(controller:_otp, keyboardType:TextInputType.number, decoration:InputDecoration(hintText:'Nhập OTP')),            
            if(error!=null) Text(error!, style:TextStyle(color:Colors.red)),
            if(message!=null) Text(message!, style:TextStyle(color:Colors.green)),
            SizedBox(height:20),
            loading? CircularProgressIndicator(): ElevatedButton(onPressed:_verify, child:Text('Xác thực'), style:ElevatedButton.styleFrom(backgroundColor: AppColors.primary)),
            TextButton(onPressed:_resend, child:Text('Gửi lại OTP', style:TextStyle(color:AppColors.primary)))
          ]
        )
      )
    );
  }
}