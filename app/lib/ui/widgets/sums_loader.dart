import 'package:flutter/material.dart';
import 'package:mal/ui/widgets/no_data_centered.dart';
import 'package:mal/ui/widgets/sums_card.dart';
import 'package:mal/utils.dart';

class SumsLoader extends StatelessWidget {
  const SumsLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadTotals(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('test :: ${snapshot.error}');
        }

        if (snapshot.data == null) {
          return const NoDataCentered();
        }

        return SumsCard(totals: snapshot.data!);
      },
    );
  }
}
