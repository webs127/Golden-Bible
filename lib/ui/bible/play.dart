import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/core/models/bible.dart';
import 'package:bible/providers/bible_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:provider/provider.dart';

class PlayVerse extends StatelessWidget {
  final CurrentBook currentBook;
  const PlayVerse({super.key, required this.currentBook});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verseTitle = "${currentBook.name} ${currentBook.chapter}";
    final verseText = currentBook.verses.isNotEmpty
        ? currentBook.verses.first
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: SizedBox(
                    height: 150,
                    child: Card(
                      color: ColorManager.primary,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(
                            verseTitle,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: ColorManager.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22),
                Text(
                  verseText,
                  textAlign: TextAlign.justify,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: ColorManager.grey,
                  ),
                ),
                SizedBox(height: 32),
                FloatingActionButton(
                  backgroundColor: ColorManager.button,
                  shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    context.read<BibleProvider>().onPlayChanged();
                  },
                  child: Icon(
                    context.watch<BibleProvider>().play
                        ? MdiIcons.pause
                        : MdiIcons.play,
                    color: ColorManager.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
