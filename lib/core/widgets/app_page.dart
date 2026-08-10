import 'package:flutter/material.dart';
import 'package:pose_match/core/constants/app_sizes.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    required this.child,
    super.key,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(AppSizes.pagePadding),
    this.useSafeArea = true,
    this.scrollable = false,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final bool useSafeArea;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        Widget pageContent = Padding(padding: padding, child: child);

        if (scrollable) {
          pageContent = SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: pageContent,
            ),
          );
        }

        return pageContent;
      },
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(backgroundColor: backgroundColor, body: content);
  }
}
