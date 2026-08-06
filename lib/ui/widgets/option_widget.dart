import 'package:bible/core/managers/color_manager.dart';
import 'package:flutter/material.dart';

class OptionWidget extends StatelessWidget {
  final VoidCallback? highlight;
  final VoidCallback? bookmark;
  final VoidCallback? addnote;
  final VoidCallback? share;
  const OptionWidget({
    super.key,
    this.highlight,
    this.bookmark,
    this.addnote,
    this.share,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        TextButton.icon(
          icon: Icon(Icons.highlight_outlined, color: ColorManager.grey1),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(ColorManager.button),
            elevation: WidgetStatePropertyAll(20),
          ),
          onPressed: highlight,
          label: Text(
            style: TextStyle(
              color: ColorManager.grey1,
              fontWeight: FontWeight.w700,
            ),
            "Highlight",
          ),
        ),
        TextButton.icon(
          icon: Icon(Icons.bookmark_outline, color: ColorManager.grey1),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(ColorManager.button),
            elevation: WidgetStatePropertyAll(20),
          ),
          onPressed: bookmark,
          label: Text(
            style: TextStyle(
              color: ColorManager.grey1,
              fontWeight: FontWeight.w700,
            ),
            "Bookmark",
          ),
        ),
        TextButton.icon(
          icon: Icon(Icons.note_add_outlined, color: ColorManager.grey1),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(ColorManager.button),
            elevation: WidgetStatePropertyAll(20),
          ),
          onPressed: addnote,
          label: Text(
            style: TextStyle(
              color: ColorManager.grey1,
              fontWeight: FontWeight.w700,
            ),
            "Add Note",
          ),
        ),
        TextButton.icon(
          icon: Icon(Icons.share_outlined, color: ColorManager.grey1),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(ColorManager.button),
            elevation: WidgetStatePropertyAll(20),
          ),
          onPressed: share,
          label: Text(
            style: TextStyle(
              color: ColorManager.grey1,
              fontWeight: FontWeight.w700,
            ),
            "Share",
          ),
        ),
      ],
    );
  }
}
