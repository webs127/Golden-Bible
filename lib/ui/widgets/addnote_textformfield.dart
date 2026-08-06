
import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/core/models/bible.dart';
import 'package:bible/core/models/save.dart';
import 'package:bible/providers/saved_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNoteTextFormField extends StatelessWidget {
  const AddNoteTextFormField({
    super.key,
    required this.addNote,
    required this.activeBook,
    required this.pageIndex,
    required this.i,
  });

  final TextEditingController addNote;
  final Book? activeBook;
  final int pageIndex;
  final int i;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: ColorManager.background1,
      padding: EdgeInsets.all(8),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: TextFormField(
              controller: addNote,
              minLines: 1,
              maxLines: 5,
              cursorColor: ColorManager.black,
              decoration: InputDecoration(
                hintText: "Add Note",
                hintStyle: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorManager.primary,
                ),

                border: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorManager.primary),
                  borderRadius: BorderRadius.circular(24),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorManager.primary),
                  borderRadius: BorderRadius.circular(24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorManager.primary),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          IconButton.filled(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(ColorManager.primary),
            ),
            onPressed: () {
              final Notes note = Notes(
                book: activeBook?.name ?? "",
                chapter: pageIndex + 1,
                verse: i + 1,
                text: addNote.text,
              );
              context.read<SavedProvider>().addNote(note);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
