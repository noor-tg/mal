import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mal/constants.dart';
import 'package:table_calendar/table_calendar.dart' as calendar;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Transaction>> _selectedTransactions;
  calendar.CalendarFormat _calendarFormat = calendar.CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Sample data - replace with your actual data source
  final Map<DateTime, List<Transaction>> _transactions = transactionsSeeds;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedTransactions = ValueNotifier(
      _getTransactionsForDay(_selectedDay!),
    );
  }

  @override
  void dispose() {
    _selectedTransactions.dispose();
    super.dispose();
  }

  List<Transaction> _getTransactionsForDay(DateTime day) {
    return _transactions[DateTime(day.year, day.month, day.day)] ?? [];
  }

  // Calculate daily totals for display
  Map<String, double> _getDailyTotals(DateTime day) {
    final transactions = _getTransactionsForDay(day);
    double income = 0;
    double expenses = 0;

    for (final transaction in transactions) {
      if (transaction.isIncome) {
        income += transaction.amount;
      } else {
        expenses += transaction.amount.abs();
      }
    }

    return {'income': income, 'expenses': expenses};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Calendar Section
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(100),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: calendar.TableCalendar<Transaction>(
            locale: 'ar',
            availableCalendarFormats: const {
              calendar.CalendarFormat.month: 'شهر',
              calendar.CalendarFormat.twoWeeks: 'أسبوعين',
              calendar.CalendarFormat.week: 'أسبوع',
            },
            headerStyle: calendar.HeaderStyle(
              titleTextFormatter: (date, locale) {
                // Custom formatter: English year, localized month
                final monthName = DateFormat.MMMM(locale).format(date);
                final year = DateFormat.y(
                  'en',
                ).format(date); // Force English year
                return '$monthName $year';
              },
            ),
            daysOfWeekHeight: 40, // Increase height (default is around 16-20)
            daysOfWeekStyle: const calendar.DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontSize: 12,
              ), // Adjust font size if needed
              weekendStyle: TextStyle(fontSize: 12),
            ),
            rowHeight: 72, // Default is around 52, increase as needed

            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getTransactionsForDay,
            startingDayOfWeek: calendar.StartingDayOfWeek.monday,
            calendarStyle: calendar.CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(color: Colors.red[600]),
              holidayTextStyle: TextStyle(color: Colors.red[600]),
              selectedDecoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(8),
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orange[400],
                borderRadius: BorderRadius.circular(8),
              ),
              markerDecoration: const BoxDecoration(color: Colors.transparent),
            ),
            selectedDayPredicate: (day) {
              return calendar.isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!calendar.isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _selectedTransactions.value = _getTransactionsForDay(
                  selectedDay,
                );
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: calendar.CalendarBuilders(
              // Custom builder to show income/expense amounts
              defaultBuilder: (context, day, focusedDay) {
                final totals = _getDailyTotals(day);
                final hasTransactions =
                    totals['income']! > 0 || totals['expenses']! > 0;

                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: calendar.isSameDay(_selectedDay, day)
                        ? Colors.blue[600]
                        : (calendar.isSameDay(DateTime.now(), day)
                              ? Colors.orange[400]
                              : Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          color:
                              calendar.isSameDay(_selectedDay, day) ||
                                  calendar.isSameDay(DateTime.now(), day)
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (hasTransactions) ...[
                        if (totals['income']! > 0)
                          Text(
                            '+${approximate(totals['income']!.toInt())}',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color:
                                  calendar.isSameDay(_selectedDay, day) ||
                                      calendar.isSameDay(DateTime.now(), day)
                                  ? Colors.white
                                  : Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (totals['expenses']! > 0)
                          Text(
                            '-${approximate(totals['expenses']!.toInt())}',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color:
                                  calendar.isSameDay(_selectedDay, day) ||
                                      calendar.isSameDay(DateTime.now(), day)
                                  ? Colors.white
                                  : Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // Divider with selected date info
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transactions for ${_selectedDay != null ? "${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}" : ""}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ValueListenableBuilder<List<Transaction>>(
                valueListenable: _selectedTransactions,
                builder: (context, transactions, _) {
                  final totals = _getDailyTotals(_selectedDay!);
                  final net = totals['income']! - totals['expenses']!;
                  return Text(
                    'Net: ${net >= 0 ? "+" : ""}${net.toInt()}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: net >= 0 ? Colors.green[700] : Colors.red[700],
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Transactions List Section
        Expanded(
          child: ValueListenableBuilder<List<Transaction>>(
            valueListenable: _selectedTransactions,
            builder: (context, transactions, _) {
              if (transactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No transactions for this day',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: transaction.isIncome
                            ? Colors.green[100]
                            : Colors.red[100],
                        child: Icon(
                          transaction.isIncome
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: transaction.isIncome
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      ),
                      title: Text(
                        transaction.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        transaction.category,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: Text(
                        '${transaction.isIncome ? "+" : ""}${transaction.amount.toInt()}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: transaction.isIncome
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      ),
                      onTap: () {
                        // Handle transaction tap (edit, view details, etc.)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tapped on ${transaction.title}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
