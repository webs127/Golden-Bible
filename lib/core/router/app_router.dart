import 'package:bible/core/models/bible.dart';
import 'package:bible/core/router/route_names.dart';
import 'package:bible/ui/bible/bible.dart';
import 'package:bible/ui/bible/chapters.dart';
import 'package:bible/ui/bible/verse.dart';
import 'package:bible/ui/home/home.dart';
import 'package:bible/ui/saved/saved.dart';
import 'package:bible/ui/search/search.dart';
import 'package:bible/ui/settings/settings.dart';
import 'package:bible/ui/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _bibleSectionNavigatorKey = GlobalKey<NavigatorState>();
final _bibleNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      name: 'Splash',
      builder: (context, state) => SplashScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNavBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _bibleSectionNavigatorKey,
          routes: [
            GoRoute(
              path: RouteNames.landing,
              name: 'Landing',
              builder: (context, state) => HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _bibleNavigatorKey,
          routes: [
            GoRoute(
              path: RouteNames.bibleHome,
              name: 'Bible',
              builder: (context, state) => BibleScreen(),
              routes: [
                GoRoute(
                  path: RouteNames.bibleChapters,
                  name: 'Chapters',
                  builder: (context, state) {
                    final book = state.extra as Book;
                    return ChaptersScreen(book: book);
                  },
                ),
                GoRoute(
                  path: RouteNames.bibleVerse,
                  name: 'Verses',
                  builder: (context, state) {
                    final verses = state.extra as CurrentBook;
                    return VerseScreen(currentBook: verses);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.bibleSearch,
              name: 'Search',
              builder: (context, state) => SearchScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.bibleSaved,
              name: 'Saved',
              builder: (context, state) =>
                  SavedScreen(initialTab: state.extra as int? ?? 0),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.settings,
      name: 'Settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.homeOutline),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.bookOpenBlankVariant),
            label: "Bible",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.bookmarkOutline),
            label: "Saved",
          ),
        ],
      ),
    );
  }

  void _onTap(int index) {
    // Close any open popup menus before switching branches to avoid
    // "Looking up a deactivated widget's ancestor is unsafe" errors.
    try {
      _bibleNavigatorKey.currentState?.popUntil((route) {
        final rt = route.runtimeType.toString();
        // Pop any internal PopupMenuRoute entries.
        if (rt.contains('PopupMenuRoute')) {
          return false; // keep popping
        }
        return true; // stop popping
      });
    } catch (_) {
      // ignore any errors while attempting to close transient routes
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
