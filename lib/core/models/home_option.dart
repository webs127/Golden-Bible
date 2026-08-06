import 'package:flutter/material.dart';

class HomeOptionObj {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  HomeOptionObj({required this.title, required this.icon, this.onTap});
}
