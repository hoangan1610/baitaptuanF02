import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/forgot_password_page.dart';
import 'screens/reset_password_page.dart';
import 'screens/email_verification_page.dart';
import 'screens/phone_verification_page.dart';
import 'screens/main_page.dart';  // TODO: Tạo MainPage tương ứng

void main() {
  runApp(HQAApp());
}

class HQAApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HQA App',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          color: AppColors.primary,
          iconTheme: IconThemeData(color: AppColors.black),
        ),
      ),
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (_) => LoginPage(),
        RegisterPage.routeName: (_) => RegisterPage(),
        ForgotPasswordPage.routeName: (_) => ForgotPasswordPage(),
        ResetPasswordPage.routeName: (_) => ResetPasswordPage(),
        EmailVerificationPage.routeName: (_) => EmailVerificationPage(),
        PhoneVerificationPage.routeName: (_) => PhoneVerificationPage(),
        MainPage.routeName: (_) => MainPage(),
      },
    );
  }
}
