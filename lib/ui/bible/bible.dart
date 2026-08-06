import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/providers/bible_provider.dart';
import 'package:bible/ui/widgets/theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Books", style: theme.textTheme.headlineMedium),
          actions: [ThemeSwitch()],
          bottom: TabBar(
            tabs: const [
              Tab(text: "Old Testament"),
              Tab(text: "New Testament"),
            ],
          ),
        ),
        body: Consumer<BibleProvider>(
          builder: (context, state, __) {
            if (state.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: ColorManager.primary),
              );
            }

            final books = state.bible?.books ?? [];
            return TabBarView(
              children: [
                ListView.builder(
                  itemCount: 39,
                  itemBuilder: (context, i) {
                    final book = books[i];
                    return ListTile(
                      title: Text(
                        book.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      leading: Text(
                        book.abbrev.toUpperCase(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        book.chapters.length == 1
                            ? '${book.chapters.length} chapter'
                            : '${book.chapters.length} chapters',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: ColorManager.grey,
                        ),
                      ),
                      onTap: () {
                        context.pushNamed('Chapters', extra: book);
                      },
                    );
                  },
                ),
                ListView.builder(
                  itemCount: 27,
                  itemBuilder: (context, i) {
                    final book = books[i + 39];
                    return ListTile(
                      title: Text(
                        book.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      leading: Text(
                        book.abbrev.toUpperCase(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        book.chapters.length == 1
                            ? '${book.chapters.length} chapter'
                            : '${book.chapters.length} chapters',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: ColorManager.grey,
                        ),
                      ),
                      onTap: () {
                        context.pushNamed('Chapters', extra: book);
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
