import 'dart:async';

import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/core/models/match.dart';
import 'package:bible/providers/bible_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController search = TextEditingController();
  Timer? _debounce;
  bool _isSearching = false;

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    setState(() {
      _isSearching = true;
    });
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      context.read<BibleProvider>().searchWord(value);
      setState(() {
        _isSearching = false;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<BibleProvider>(
      builder: (context, state, __) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 120,
            title: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Search", style: theme.textTheme.headlineMedium),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: search,
                        style: theme.textTheme.titleMedium,
                        onChanged: _onSearchChanged,
                        cursorColor: ColorManager.primary,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search_outlined,
                            color: ColorManager.grey,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _debounce?.cancel();
                              search.clear();
                              setState(() {
                                _isSearching = false;
                              });
                              state.searchWord('');
                            },
                            icon: Icon(
                              Icons.cancel_outlined,
                              color: ColorManager.grey,
                            ),
                          ),
                          hintText: "Search",
                          hintStyle: theme.textTheme.titleMedium,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.grey),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _isSearching
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 22,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorManager.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Searching...",
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: ColorManager.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : state.searchResults.isEmpty
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 22,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${state.searchResults.length} results found for \"${search.text}\"",
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: ColorManager.grey,
                                  ),
                                ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: state.currentPage > 0
                                      ? () => state.onPageSelected(state.currentPage - 1)
                                      : null,
                                  child: Text(
                                    "Previous",
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: state.currentPage > 0
                                          ? ColorManager.grey
                                          : ColorManager.grey.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                        state.totalPages,
                                        (i) => InkWell(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          onTap: () {
                                            state.onPageSelected(i);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              (i + 1).toString(),

                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                    color:
                                                        state.currentPage == i
                                                        ? ColorManager.primary
                                                        : ColorManager.grey,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                TextButton(
                                  onPressed: state.currentPage < state.totalPages - 1
                                      ? () => state.onPageSelected(state.currentPage + 1)
                                      : null,
                                  child: Text(
                                    "Next",
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: state.currentPage < state.totalPages - 1
                                          ? ColorManager.grey
                                          : ColorManager.grey.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),

              state.searchResults.isEmpty
                  ? SliverToBoxAdapter(child: SizedBox())
                  : Builder(
                      builder: (context) {
                        final pageStart = state.currentPage * state.tilePerPage;
                        final pageEnd = pageStart + state.tilePerPage;
                        final pageResults = state.searchResults.sublist(
                          pageStart,
                          pageEnd > state.searchResults.length
                              ? state.searchResults.length
                              : pageEnd,
                        );

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                SearchTile(match: pageResults[index]),
                            childCount: pageResults.length,
                          ),
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}

class SearchTile extends StatelessWidget {
  final SearchMatch match;

  const SearchTile({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${match.book} ${match.chapter}:${match.verseIndex}",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primary,
                ),
              ),
              Text(
                match.bookIndex < 40 ? "Old Testament" : "New Testament",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: ColorManager.grey,
                ),
              ),
            ],
          ),
          Text(
            "\"${match.verse}\"",
            textAlign: TextAlign.justify,
            style: theme.textTheme.titleLarge?.copyWith(
              fontFamily: "Times",
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
