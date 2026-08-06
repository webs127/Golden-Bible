import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/core/models/save.dart';
import 'package:bible/providers/saved_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      initialIndex: widget.initialTab,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Saved", style: theme.textTheme.headlineMedium),
          bottom: TabBar(
            tabs: const [
              Tab(text: "Bookmarks"),
              Tab(text: "Highlights"),
              Tab(text: "Notes"),
            ],
          ),
        ),
        body: Consumer<SavedProvider>(
          builder: (context, state, __) {
            return TabBarView(
              children: [
                state.isBookmarkEmpty
                    ? Center(
                        child: Text(
                          "Bookmark is empty.",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.bookmarkLength,
                        itemBuilder: (context, i) =>
                            BookmarkWiget(bookmark: state.bookmarks[i]),
                      ),
                state.isHighlightsEmpty
                    ? Center(
                        child: Text(
                          "Highlights is empty.",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.highlightsLength,
                        itemBuilder: (context, i) =>
                            HighlightWidget(highlight: state.highlights[i]),
                      ),

                state.isNotesEmpty
                    ? Center(
                        child: Text(
                          "Notes is empty.",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.notesLength,
                        itemBuilder: (context, i) =>
                            NoteWidget(note: state.notes[i]),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BookmarkWiget extends StatelessWidget {
  final Bookmark bookmark;
  const BookmarkWiget({super.key, required this.bookmark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String book = "${bookmark.book} ${bookmark.chapter}:${bookmark.verse}";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [
                  Icon(
                    Icons.bookmark_outline_outlined,
                    color: ColorManager.primary1,
                  ),
                  Text(
                    book,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: ColorManager.primary,
                    ),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            ],
          ),
          Text(
            "\"${bookmark.value}\"",
            textAlign: TextAlign.justify,
            style: theme.textTheme.titleLarge?.copyWith(
              fontFamily: "Times",
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Added on ${bookmark.date}",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorManager.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class HighlightWidget extends StatelessWidget {
  final Highlight highlight;
  const HighlightWidget({super.key, required this.highlight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String book = "${highlight.book} ${highlight.chapter}:${highlight.verse}";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [
                  Icon(Icons.highlight_outlined, color: ColorManager.primary1),
                  Text(
                    book,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: ColorManager.primary,
                    ),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            ],
          ),
          Text(
            "\"${highlight.value}\"",
            textAlign: TextAlign.justify,
            style: theme.textTheme.titleLarge?.copyWith(
              fontFamily: "Times",
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Added on ${highlight.date}",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorManager.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class NoteWidget extends StatelessWidget {
  final Notes note;
  const NoteWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String book = "${note.book} ${note.chapter}:${note.verse}";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [
                  Icon(Icons.note_add_outlined, color: ColorManager.primary1),
                  Text(
                    book,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: ColorManager.primary,
                    ),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            ],
          ),
          Text(
            note.text,
            textAlign: TextAlign.justify,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Added on ${note.date}",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorManager.grey,
            ),
          ),
        ],
      ),
    );
  }
}
