import 'package:flutter/material.dart';
import 'package:mal/ui/screens/mal_page_container.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MalPageContainer(
      child: Column(
        children: [OutlinedButton(onPressed: () {}, child: Text('hi'))],
      ),
    );
  }
}
