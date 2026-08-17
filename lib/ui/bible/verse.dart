import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/core/models/bible.dart';
import 'package:bible/core/models/save.dart';
import 'package:bible/providers/bible_provider.dart';
import 'package:bible/providers/saved_provider.dart';
import 'package:bible/providers/theme_provider.dart';
import 'package:bible/providers/tts_provider.dart';
import 'package:bible/ui/widgets/addnote_textformfield.dart';
import 'package:bible/ui/widgets/auto_close_widget.dart';
import 'package:bible/ui/widgets/draggable_playsheet.dart';
import 'package:bible/ui/widgets/highlight_pill.dart';
import 'package:bible/ui/widgets/option_widget.dart';
import 'package:bible/ui/widgets/theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class VerseScreen extends StatefulWidget {
  final CurrentBook currentBook;
  const VerseScreen({super.key, required this.currentBook});

  @override
  State<VerseScreen> createState() => _VerseScreenState();
}

class _VerseScreenState extends State<VerseScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentBook.chapter - 1;
    _pageController = PageController(initialPage: _currentPage);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BibleProvider>(context, listen: false);
      final activeBook = provider.getActiveBook(widget.currentBook);
      if (activeBook != null &&
          _currentPage >= 0 &&
          _currentPage < activeBook.chapters.length) {
        provider.versesLength = activeBook.chapters[_currentPage].verses.length;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<BibleProvider>(
      builder: (context, state, __) {
        final activeBook = state.getActiveBook(widget.currentBook);
        if (activeBook == null) {
          return Scaffold(
            backgroundColor: ColorManager.background1,
            body: const Center(child: Text('Book not found in selected Bible')),
          );
        }

        final pageCount = activeBook.chapters.length;
        final currentPageIndex = _currentPage.clamp(0, pageCount - 1);

        return SafeArea(
          child: Scaffold(
            floatingActionButton: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: currentPageIndex > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: ColorManager.grey,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<TtsProvider>().togglePlayPause(
                      widget.currentBook,
                    );
                    showModalBottomSheet(
                      isScrollControlled: true,
                      shape: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none,
                      ),
                      backgroundColor: ColorManager.background,
                      context: context,
                      builder: (context) =>
                          DraggablePlaySheet(currentBook: widget.currentBook),
                    );
                  },
                  icon: Icon(
                    context.watch<TtsProvider>().isPlaying
                        ? MdiIcons.pause
                        : MdiIcons.play,
                    color: ColorManager.primary1,
                  ),
                ),
                IconButton(
                  onPressed: currentPageIndex < pageCount - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  icon: Icon(Icons.arrow_forward_ios, color: ColorManager.grey),
                ),
              ],
            ),
            body: Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${activeBook.name} ${currentPageIndex + 1}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Row(
                          children: [
                            DropdownButton<int>(
                              dropdownColor: ColorManager.background1,
                              value: state.currentBible,
                              selectedItemBuilder: (context) => [
                                SizedBox(
                                  height: 24,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'KJV',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 24,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'BBE',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ),
                                ),
                              ],
                              items: [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text(
                                    'KJV',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(color: ColorManager.grey1),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text(
                                    'BBE',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(color: ColorManager.grey1),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                state.onBibleChanged(value, widget.currentBook);
                                final newBook = state.getActiveBook(
                                  widget.currentBook,
                                );
                                if (newBook != null &&
                                    _currentPage >= newBook.chapters.length) {
                                  _currentPage = newBook.chapters.length - 1;
                                  _pageController.jumpToPage(_currentPage);
                                }
                              },
                            ),
                            PopupMenuButton<int>(
                              color: ColorManager.background1,
                              icon: Icon(Icons.more_vert_outlined),
                              itemBuilder: (context) => [
                                PopupMenuItem<int>(
                                  value: 0,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => Consumer<BibleProvider>(
                                      builder: (context, textsize, __) {
                                        return Dialog(
                                          backgroundColor:
                                              ColorManager.background1,
                                          shape: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          child: Card(
                                            color: ColorManager.background1,
                                            margin: EdgeInsets.zero,
                                            shape: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                        16,
                                                        16,
                                                        16,
                                                        0,
                                                      ),
                                                  child: Text(
                                                    'Text Settings',
                                                    style: theme
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: ColorManager
                                                              .black,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(height: 6),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 16,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 16,
                                                            ),
                                                        child: Text(
                                                          'Font Size:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Slider.adaptive(
                                                              activeColor:
                                                                  ColorManager
                                                                      .primary,
                                                              value: textsize
                                                                  .textSize,
                                                              max: 30,
                                                              min: 10,
                                                              onChanged: textsize
                                                                  .onTextSizeChanged,
                                                            ),
                                                          ),
                                                          Text(
                                                            textsize.textSize
                                                                .toStringAsFixed(
                                                                  0,
                                                                ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 16,
                                                        bottom: 20,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 16,
                                                            ),
                                                        child: Row(
                                                          spacing: 6,
                                                          children: [
                                                            Text(
                                                              'Font Weight:',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: DropdownButtonFormField<FontWeight>(
                                                                initialValue:
                                                                    textsize
                                                                        .fontWeight,
                                                                dropdownColor:
                                                                    ColorManager
                                                                        .background1,
                                                                decoration: InputDecoration(
                                                                  focusedBorder: UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                          color:
                                                                              ColorManager.primary,
                                                                        ),
                                                                  ),
                                                                ),
                                                                items: [
                                                                  DropdownMenuItem(
                                                                    value:
                                                                        FontWeight
                                                                            .w200,
                                                                    child: Text(
                                                                      "Light",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: ColorManager
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  DropdownMenuItem(
                                                                    value: FontWeight
                                                                        .normal,
                                                                    child: Text(
                                                                      "Regular",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: ColorManager
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  DropdownMenuItem(
                                                                    value:
                                                                        FontWeight
                                                                            .w600,
                                                                    child: Text(
                                                                      "Bold",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: ColorManager
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  DropdownMenuItem(
                                                                    value:
                                                                        FontWeight
                                                                            .bold,
                                                                    child: Text(
                                                                      "Extra Bold",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: ColorManager
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                                onChanged: textsize
                                                                    .onFontWeightChanged,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  child: Text(
                                    'Text Settings',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: ColorManager.black,
                                        ),
                                  ),
                                ),
                                //playVersePopUp(context, theme),
                                PopupMenuItem(
                                  value: 1,
                                  onTap: () => context
                                      .read<ThemeProvider>()
                                      .onThemeChanged(),
                                  child: ThemeSwitch(color: ColorManager.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pageCount,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                      state.versesLength =
                          activeBook.chapters[index].verses.length;
                    },
                    itemBuilder: (context, pageIndex) {
                      final chapter = activeBook.chapters[pageIndex];
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        itemCount: chapter.verses.length,
                        itemBuilder: (context, i) {
                          final highlights = context
                              .watch<SavedProvider>()
                              .highlights;
                          final existingHighlightIndex = highlights.indexWhere(
                            (h) =>
                                h.book == activeBook.name &&
                                h.chapter == pageIndex + 1 &&
                                h.verse == i + 1,
                          );
                          final existingHighlight = existingHighlightIndex != -1
                              ? highlights[existingHighlightIndex]
                              : null;
                          return ListTile(
                            visualDensity: const VisualDensity(
                              vertical: -4,
                              horizontal: -4,
                            ),
                            titleAlignment: ListTileTitleAlignment.titleHeight,
                            minVerticalPadding: 3,
                            leading: Text(
                              (i + 1).toString(),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: ColorManager.primary,
                              ),
                            ),
                            minLeadingWidth: 15,
                            title: Container(
                              decoration: existingHighlight != null
                                  ? BoxDecoration(
                                      color: Color(
                                        existingHighlight.color,
                                      ).withAlpha(60),
                                      borderRadius: BorderRadius.circular(4),
                                    )
                                  : null,
                              padding: existingHighlight != null
                                  ? EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    )
                                  : null,
                              child: Text(
                                chapter.verses[i],
                                textAlign: TextAlign.justify,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontSize: state.textSize,
                                  fontWeight: state.fontWeight,
                                ),
                              ),
                            ),
                            onTap: () {
                              state.changeVerseOptionState(i);
                            },
                            subtitle:
                                (i < state.versesOptions.length &&
                                    state.versesOptions[i])
                                ? OptionWidget(
                                    isHighlighted: existingHighlight != null,
                                    highlight: () {
                                      if (existingHighlight != null) {
                                        showDialog(
                                          context: context,
                                          builder: (dialogCtx) => Dialog(
                                            backgroundColor:
                                                ColorManager.background1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Remove highlight?",
                                                    style: theme
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: ColorManager
                                                              .black,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    spacing: 12,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              dialogCtx,
                                                            ),
                                                        child: Text("Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          context
                                                              .read<
                                                                SavedProvider
                                                              >()
                                                              .removeHighlight(
                                                                existingHighlightIndex,
                                                              );
                                                          Navigator.pop(
                                                            dialogCtx,
                                                          );
                                                          showBottomSheet(
                                                            context: context,
                                                            builder: (ctx) =>
                                                                AutoCloseSheet(
                                                                  text:
                                                                      "Highlight removed",
                                                                ),
                                                          );
                                                        },
                                                        child: Text(
                                                          "Remove",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (dialogCtx) => Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                HighlightPill(
                                                  onColorSelected: (color) {
                                                    final highlight = Highlight(
                                                      book: activeBook.name,
                                                      chapter: pageIndex + 1,
                                                      verse: i + 1,
                                                      value: chapter.verses[i],
                                                      color: color,
                                                    );
                                                    context
                                                        .read<SavedProvider>()
                                                        .addHighlight(
                                                          highlight,
                                                        );
                                                    Navigator.pop(dialogCtx);
                                                    showBottomSheet(
                                                      context: context,
                                                      builder: (ctx) =>
                                                          AutoCloseSheet(
                                                            text:
                                                                "Verse highlighted",
                                                          ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    bookmark: () {
                                      final bookmark = Bookmark(
                                        book: activeBook.name,
                                        chapter: pageIndex + 1,
                                        verse: i + 1,
                                        value: chapter.verses[i],
                                      );
                                      context.read<SavedProvider>().addBookmark(
                                        bookmark,
                                      );
                                      showBottomSheet(
                                        context: context,
                                        builder: (context) => AutoCloseSheet(
                                          text: "Verse bookmarked succesfully",
                                        ),
                                      );
                                    },
                                    share: () {
                                      SharePlus.instance.share(
                                        ShareParams(
                                          text: '"${chapter.verses[i]}" — ${activeBook.name} ${pageIndex + 1}:${i + 1}',
                                        ),
                                      );
                                    },
                                    addnote: () {
                                      final TextEditingController addNote =
                                          TextEditingController();
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            AddNoteTextFormField(
                                              addNote: addNote,
                                              activeBook: activeBook,
                                              pageIndex: pageIndex,
                                              i: i,
                                            ),
                                      );
                                    },
                                  )
                                : null,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
