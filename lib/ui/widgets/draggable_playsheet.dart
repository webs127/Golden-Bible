
import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/core/models/bible.dart';
import 'package:bible/providers/tts_provider.dart';
import 'package:bible/ui/bible/play.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:provider/provider.dart';

class DraggablePlaySheet extends StatefulWidget {
  final CurrentBook currentBook;
  const DraggablePlaySheet({super.key, required this.currentBook});

  @override
  State<DraggablePlaySheet> createState() => _DraggablePlaySheetState();
}

class _DraggablePlaySheetState extends State<DraggablePlaySheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verseTitle =
        "${widget.currentBook.name} ${widget.currentBook.chapter}";
    final screenHeight = MediaQuery.of(context).size.height;
    final handleHeight = 16.0;
    final miniHeight = 72.0;

    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        final t = _expandAnimation.value;
        final currentHeight =
            handleHeight + miniHeight + (screenHeight * 0.6 - handleHeight - miniHeight) * t;

        return GestureDetector(
          onVerticalDragUpdate: (details) {
            final delta = -details.primaryDelta! / (screenHeight * 0.85);
            final newValue = (_animController.value + delta).clamp(0.0, 1.0);
            _animController.value = newValue;
          },
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity == null) return;
            if (details.primaryVelocity! < -200 ||
                _animController.value > 0.3) {
              _animController.animateTo(1.0);
            } else {
              _animController.animateTo(0.0);
            }
          },
          child: Container(
            height: currentHeight,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: ColorManager.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 4),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ColorManager.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Opacity(
                  opacity: (1.0 - t * 2).clamp(0.0, 1.0),
                  child: IgnorePointer(
                    ignoring: t > 0.5,
                    child: SizedBox(
                      height: miniHeight * (1.0 - t),
                      child: _buildMiniPlayer(theme, verseTitle),
                    ),
                  ),
                ),
                Expanded(
                  child: Opacity(
                    opacity: (t * 2 - 0.3).clamp(0.0, 1.0),
                    child: IgnorePointer(
                      ignoring: t < 0.5,
                      child: PlayVerse(currentBook: widget.currentBook),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniPlayer(ThemeData theme, String verseTitle) {
    return ClipRect(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(MdiIcons.bookOpenPageVariant, color: ColorManager.primary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          verseTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: ColorManager.primary,
                          ),
                        ),
                        Consumer<TtsProvider>(
                          builder: (context, tts, _) {
                            if (tts.currentVerseReference.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              tts.currentVerseReference,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: ColorManager.grey,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
            ),
          ),
          Consumer<TtsProvider>(
            builder: (context, tts, _) {
              return IconButton(
                onPressed: () {
                  tts.togglePlayPause(widget.currentBook);
                },
                icon: Icon(
                  tts.isPlaying ? MdiIcons.pause : MdiIcons.play,
                  color: ColorManager.primary1,
                ),
              );
            },
          ),
        ],
      ),
    ));
  }
}
