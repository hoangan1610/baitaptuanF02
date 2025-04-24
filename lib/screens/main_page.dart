// lib/screens/main_page.dart
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class MainPage extends StatelessWidget {
  static const routeName = '/main';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HQA Home'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Chào mừng bạn đến với HQA App!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      // Ví dụ: có thể thêm BottomNavigationBar hoặc Drawer ở đây
      
    );
  }
}
