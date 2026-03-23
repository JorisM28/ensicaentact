import 'package:flutter/material.dart';
import '/View/widget/custom_app_bar.dart';
import '/View/widget/custom_drawer.dart';

class BaseLayout extends StatelessWidget {
  final Widget body; 
  final Color backgroundColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const BaseLayout({
    super.key, 
    required this.body,
    this.backgroundColor = const Color(0xFFF8F9FA),
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width <= 1320;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(),
      endDrawer: isMobile ? const CustomDrawer() : null,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: body,
    );
  }
}