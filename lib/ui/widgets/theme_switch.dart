
import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSwitch extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;
  const ThemeSwitch({super.key, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton.icon(
      onPressed: onTap ?? () {
        context.read<ThemeProvider>().onThemeChanged();
      },
      label: Text(
        context.read<ThemeProvider>().light ? "Dark" : "Light",
        style: theme.textTheme.titleMedium?.copyWith(
          color: color
        ),
      ),
      icon: Icon(
        context.read<ThemeProvider>().light
            ? Icons.dark_mode_outlined
            : Icons.light_mode_outlined,
        color: color ?? (context.read<ThemeProvider>().light
            ? ColorManager.black
            : ColorManager.white),
      ),
    );
  }
}
