import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/core/models/bible.dart';
import 'package:bible/providers/tts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:provider/provider.dart';

class PlayVerse extends StatelessWidget {
  final CurrentBook currentBook;
  const PlayVerse({super.key, required this.currentBook});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tts = context.watch<TtsProvider>();

    final isPlaying = tts.isPlaying;
    final verseText =
        tts.currentVerseText.isNotEmpty
            ? tts.currentVerseText
            : currentBook.verses.isNotEmpty
            ? currentBook.verses.first
            : '';
    final verseRef = tts.currentVerseReference.isNotEmpty
        ? tts.currentVerseReference
        : '${currentBook.name} ${currentBook.chapter}:1';

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
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(
                            verseRef,
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
                const SizedBox(height: 16),
                Text(
                  verseText,
                  textAlign: TextAlign.justify,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: ColorManager.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${tts.currentVerseIndex + 1} of ${tts.totalVerses}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: ColorManager.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: tts.currentVerseIndex > 0
                          ? () => tts.prevVerse()
                          : null,
                      icon: Icon(
                        MdiIcons.skipPrevious,
                        color: tts.currentVerseIndex > 0
                            ? ColorManager.black
                            : ColorManager.grey,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    FloatingActionButton(
                      backgroundColor: ColorManager.button,
                      shape: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: () {
                        tts.togglePlayPause(currentBook);
                      },
                      child: Icon(
                        isPlaying ? MdiIcons.pause : MdiIcons.play,
                        color: ColorManager.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: tts.currentVerseIndex < tts.totalVerses - 1
                          ? () => tts.nextVerse()
                          : null,
                      icon: Icon(
                        MdiIcons.skipNext,
                        color: tts.currentVerseIndex < tts.totalVerses - 1
                            ? ColorManager.black
                            : ColorManager.grey,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => tts.decreaseSpeed(),
                      icon: Icon(
                        Icons.remove,
                        color: ColorManager.grey,
                        size: 20,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.button,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${tts.speechRate.toStringAsFixed(1)}x',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ColorManager.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => tts.increaseSpeed(),
                      icon: Icon(
                        Icons.add,
                        color: ColorManager.grey,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => tts.togglePlayMode(),
                  child: Text(
                    tts.playMode == PlayMode.chapter
                        ? 'Playing Chapter'
                        : 'Playing Single Verse',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ColorManager.primary,
                      fontWeight: FontWeight.w600,
                    ),
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
