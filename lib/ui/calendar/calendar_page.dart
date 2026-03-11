import 'package:diary/app/app_state.dart';
import 'package:diary/app/i18n.dart';
import 'package:diary/data/models/diary_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({required this.onOpen, super.key});

  final ValueChanged<DiaryEntry> onOpen;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final localeTag = isZh(context) ? 'zh_CN' : 'en_US';
    return Consumer<DiaryAppState>(
      builder: (context, appState, _) {
        final dayEntries = appState.entriesOfDay(_selectedDay);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Card(
                child: TableCalendar<DiaryEntry>(
                  locale: localeTag,
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  eventLoader: appState.entriesOfDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                  calendarStyle: const CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    DateFormat('yyyy-MM-dd').format(_selectedDay),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tr(
                      context,
                      zh: '共 ${dayEntries.length} 条',
                      en: '${dayEntries.length} entries',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: dayEntries.isEmpty
                  ? Center(
                      child: Text(
                        tr(
                          context,
                          zh: '这一天还没有记录',
                          en: 'No entries on this day',
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 96),
                      itemBuilder: (context, index) {
                        final entry = dayEntries[index];
                        return ListTile(
                          tileColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerLow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          title: Text(
                            entry.summary.isEmpty
                                ? tr(context, zh: '空白日记', en: 'Empty entry')
                                : entry.summary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            DateFormat('HH:mm').format(entry.eventAt),
                          ),
                          trailing: entry.mood.trim().isEmpty
                              ? null
                              : Text(entry.mood),
                          onTap: () => widget.onOpen(entry),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemCount: dayEntries.length,
                    ),
            ),
          ],
        );
      },
    );
  }
}
