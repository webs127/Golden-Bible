import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/core/models/home_option.dart';
import 'package:bible/core/router/route_names.dart';
import 'package:bible/providers/devotional_provider.dart';
import 'package:bible/ui/widgets/devotional_card.dart';
import 'package:bible/ui/widgets/home_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _weekdays = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];
  static const List<String> _months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEPT',
    'OCT',
    'NOV',
    'DEC',
  ];

  String get _formattedDate {
    final now = DateTime.now();
    return '${_weekdays[now.weekday - 1]}, ${_months[now.month - 1]} ${now.day}';
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<HomeOptionObj> options = [
      HomeOptionObj(
        title: "Read",
        icon: MdiIcons.bookOpenBlankVariant,
        onTap: () => context.go(RouteNames.bibleHome),
      ),
      HomeOptionObj(
        title: "Search",
        icon: Icons.search,
        onTap: () => context.go(RouteNames.bibleSearch),
      ),
      HomeOptionObj(
        title: "Saved",
        icon: MdiIcons.bookmarkOutline,
        onTap: () => context.go(RouteNames.bibleSaved),
      ),
      HomeOptionObj(
        title: "Notes",
        icon: MdiIcons.noteOutline,
        onTap: () => context.go(RouteNames.bibleSaved, extra: 2),
      ),
    ];
    return SafeArea(
      child: Scaffold(
        body: Consumer<DevotionalProvider>(
          builder: (context, state, __) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  toolbarHeight: 70,
                  title: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formattedDate,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: ColorManager.grey,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        _greeting,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () => context.push(RouteNames.settings),
                      icon: const Icon(Icons.person),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 28),
                        Row(
                          spacing: 5,
                          children: [
                            Icon(MdiIcons.twitter, color: ColorManager.primary),
                            Text(
                              "VERSE OF THE DAY",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "\"${state.devotion?.verse.text}\"",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                "${state.devotion?.verse.ref}",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: ColorManager.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 48),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            4,
                            (i) => HomeOption(homeOptionObj: options[i]),
                          ),
                        ),
                        SizedBox(height: 36),
                        Text("Daily Devotional", style: theme.textTheme.titleLarge),
                        SizedBox(height: 10),
                        DevotionalCard(theme: theme),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
