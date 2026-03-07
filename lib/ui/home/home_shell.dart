import 'package:diary/app/app_state.dart';
import 'package:diary/app/i18n.dart';
import 'package:diary/data/models/diary_entry.dart';
import 'package:diary/ui/calendar/calendar_page.dart';
import 'package:diary/ui/editor/editor_page.dart';
import 'package:diary/ui/home/home_page.dart';
import 'package:diary/ui/preview/entry_preview_page.dart';
import 'package:diary/ui/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const _tabletBreakpoint = 840.0;
  int _index = 0;

  Future<void> _openEditor([DiaryEntry? entry]) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => EditorPage(initialEntry: entry)),
    );
    if (!mounted) {
      return;
    }
    await context.read<DiaryAppState>().refreshEntries();
  }

  Future<void> _openPreview(DiaryEntry entry) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => EntryPreviewPage(entry: entry)),
    );
    if (!mounted) {
      return;
    }
    await context.read<DiaryAppState>().refreshEntries();
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      tr(context, zh: '日记', en: 'Diary'),
      tr(context, zh: '回顾', en: 'Calendar'),
      tr(context, zh: '设置', en: 'Settings'),
    ];
    final pages = [
      HomePage(onCreate: () => _openEditor(), onOpen: _openPreview),
      CalendarPage(onOpen: _openPreview),
      const SettingsPage(),
    ];
    final destinations = [
      NavigationDestination(
        icon: const Icon(Icons.grid_view_rounded),
        label: tr(context, zh: '首页', en: 'Home'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.calendar_month_outlined),
        label: tr(context, zh: '回顾', en: 'Calendar'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.settings_outlined),
        label: tr(context, zh: '设置', en: 'Settings'),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= _tabletBreakpoint;
        return Scaffold(
          appBar: AppBar(title: Text(titles[_index])),
          body: isTablet
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _index,
                      onDestinationSelected: (value) =>
                          setState(() => _index = value),
                      labelType: NavigationRailLabelType.all,
                      destinations: destinations
                          .map(
                            (item) => NavigationRailDestination(
                              icon: item.icon,
                              selectedIcon: item.selectedIcon,
                              label: Text(item.label),
                            ),
                          )
                          .toList(),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: IndexedStack(index: _index, children: pages),
                    ),
                  ],
                )
              : IndexedStack(index: _index, children: pages),
          floatingActionButton: _index == 0
              ? FloatingActionButton.extended(
                  onPressed: () => _openEditor(),
                  icon: const Icon(Icons.edit),
                  label: Text(tr(context, zh: '写日记', en: 'Write')),
                )
              : null,
          bottomNavigationBar: isTablet
              ? null
              : NavigationBar(
                  selectedIndex: _index,
                  onDestinationSelected: (value) =>
                      setState(() => _index = value),
                  destinations: destinations,
                ),
        );
      },
    );
  }
}
