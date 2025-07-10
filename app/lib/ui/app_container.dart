import 'package:flutter/material.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/ui/screens/categories_screen.dart';
import 'package:mal/ui/screens/reports_screen.dart';
import 'package:mal/ui/widgets/main_drawer.dart';
import 'package:mal/utils.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  final PageController _pageController = PageController();
  var tabIndex = 0;

  List<MalPage> pages = [];

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    var theme = Theme.of(context).colorScheme;

    pages = [
      MalPage(
        icon: Icon(Icons.pie_chart),
        title: l10n.reportsTitle,
        widget: ReportsScreen(),
        actions: [],
      ),
      MalPage(
        icon: Icon(Icons.dashboard),
        title: l10n.tabCategoriesLabel,
        widget: CategoriesScreen(),
        actions: [
          IconButton(
            icon: Icon(Icons.dashboard_customize, color: theme.onPrimary),
            onPressed: () {
              showModalBottomSheet(
                useSafeArea: true,
                isScrollControlled: true,
                // constraints: const BoxConstraints(maxHeight: 400),
                context: context,
                builder: (ctx) => NewEntry(),
              );
              print('hi category');
            },
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pages[tabIndex].title,
          style: TextStyle(color: theme.onPrimary),
        ),
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(color: theme.onPrimary),
        actions: pages[tabIndex].actions.isNotEmpty
            ? pages[tabIndex].actions
            : [
                IconButton(
                  icon: Icon(Icons.create, color: theme.onPrimary),
                  onPressed: () {
                    print('hi entry');
                  },
                ),
              ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => tabIndex = index),
        children: pages.map((page) => page.widget).toList(),
      ),
      drawer: MainDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 40,
        type: BottomNavigationBarType.fixed,
        currentIndex: tabIndex,
        onTap: (index) {
          setState(() {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            tabIndex = index;
          });
        },
        items: pages
            .map(
              (page) =>
                  BottomNavigationBarItem(icon: page.icon, label: page.title),
            )
            .toList(),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.search),
        //   label: AppLocalizations.of(context)!.tabSearchLabel,
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.calendar_today),
        //   label: AppLocalizations.of(context)!.tabCalendarLabel,
        // ),
      ),
    );
  }
}

class NewEntry extends StatefulWidget {
  const NewEntry({super.key});

  @override
  State<NewEntry> createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  String? _categoryTitle;
  String? _categoryType;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.newCategory,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            TextFormField(
              autofocus: true,
              validator: (value) {
                if (value == null || value.length < 2) {
                  return l10n.categoryTitleErrorMessage;
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _categoryTitle = value;
                });
              },
              decoration: InputDecoration(labelText: l10n.categoryTitle),
            ),
            SizedBox(height: 24),
            Text(
              l10n.categoryType,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Row(
              children: [
                RadioMenuButton(
                  value: l10n.expense,
                  groupValue: _categoryType,
                  onChanged: (value) {
                    setState(() {
                      _categoryType = value;
                    });
                  },
                  child: Text(l10n.expense),
                ),
                RadioMenuButton(
                  value: l10n.income,
                  groupValue: _categoryType,
                  onChanged: (value) {
                    setState(() {
                      _categoryType = value;
                    });
                  },
                  child: Text(l10n.income),
                ),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.save),
            ),
            TextButton(onPressed: () {}, child: Text(l10n.cancel)),
          ],
        ),
      ),
    );
  }

  void _submit() {
    setState(() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
      }
      Navigator.pop(context);
      print('submitted');
    });
  }
}
