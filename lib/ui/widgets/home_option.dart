import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/core/models/home_option.dart';
import 'package:flutter/material.dart';

class HomeOption extends StatelessWidget {
  final HomeOptionObj homeOptionObj;
  const HomeOption({super.key, required this.homeOptionObj});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: homeOptionObj.onTap,
        child: Column(
          spacing: 4,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: ColorManager.white,
              child: Icon(homeOptionObj.icon, color: ColorManager.black),
            ),
            Text(homeOptionObj.title, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
