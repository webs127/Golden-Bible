import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/core/models/bible.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChaptersScreen extends StatelessWidget {
  const ChaptersScreen({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: Column(
          spacing: 8,
          children: [
          Text(book.name, style: theme.textTheme.headlineMedium),

            Text(
              "${book.chapters.length} Chapters",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorManager.grey
              )
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                CurrentBook currentBook = CurrentBook(
                  name: book.name,
                  chapter: index + 1,
                  verses: book.chapters[index].verses,
                );
                context.pushNamed('Verses', extra: currentBook);
              },
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            );
          },
          itemCount: book.chapters.length,
        ),
      ),
    );
  }
}
