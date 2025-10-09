import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mal/utils/logger.dart';
import 'package:mal/utils.dart';
import 'package:showcaseview/showcaseview.dart';

class TourGuideContainer extends StatelessWidget {
  const TourGuideContainer({
    super.key,
    required this.firstShowCaseKey,
    required this.lastShowCaseKey,
    required this.child,
  });

  final GlobalKey<State<StatefulWidget>> firstShowCaseKey;
  final GlobalKey<State<StatefulWidget>> lastShowCaseKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      enableAutoScroll: true,
      hideFloatingActionWidgetForShowcase: [firstShowCaseKey],
      globalFloatingActionWidget: (showcaseContext) => FloatingActionWidget(
        left: 16,
        bottom: 16,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: ShowCaseWidget.of(showcaseContext).dismiss,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.errorContainer,
            ),
            child: Text(
              context.l10n.skip,
              style: TextStyle(
                color: context.colors.error,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      onStart: (index, key) {
        logger.i('onStart: $index, $key');
      },
      onComplete: (index, key) {
        logger.i('onComplete: $index, $key');
        if (index == 4) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white,
            ),
          );
        }
      },
      blurValue: 1,
      autoPlayDelay: const Duration(seconds: 3),
      builder: (context) => child,
      globalTooltipActionConfig: const TooltipActionConfig(actionGap: 20),
      globalTooltipActions: [
        // Here we don't need previous action for the first showcase widget
        // so we hide this action for the first showcase widget
        TooltipActionButton(
          type: TooltipDefaultActionType.previous,
          name: context.l10n.previous,
          backgroundColor: context.colors.secondary,
          textStyle: TextStyle(color: context.colors.onSecondary),
          hideActionWidgetForShowcase: [firstShowCaseKey],
        ),
        // Here we don't need next action for the last showcase widget so we
        // hide this action for the last showcase widget
        TooltipActionButton(
          type: TooltipDefaultActionType.next,
          name: context.l10n.next,
          backgroundColor: context.colors.secondary,
          textStyle: TextStyle(color: context.colors.onSecondary),
          hideActionWidgetForShowcase: [lastShowCaseKey],
        ),
      ],
    );
  }
}
