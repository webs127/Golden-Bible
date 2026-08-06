import 'package:bible/core/managers/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AutoCloseSheet extends StatefulWidget {
  final String text;
  const AutoCloseSheet({super.key, required this.text});

  @override
  State<AutoCloseSheet> createState() => _AutoCloseSheetState();
}

class _AutoCloseSheetState extends State<AutoCloseSheet> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (mounted && context.canPop()) {
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.primary,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            widget.text,
            style: TextStyle(
              color: ColorManager.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
