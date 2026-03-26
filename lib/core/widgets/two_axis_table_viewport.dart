import 'package:flutter/material.dart';

/// A reusable bounded viewport for CRM-style data tables.
///
/// It provides:
/// - Horizontal scrolling when table content exceeds available width.
/// - A bounded height for vertical scrolling in the table body.
/// - A single horizontal scroll context so headers and rows stay aligned.
class TwoAxisTableViewport extends StatefulWidget {
  const TwoAxisTableViewport({
    required this.minContentWidth,
    required this.header,
    required this.bodyBuilder,
    super.key,
  });

  final double minContentWidth;
  final Widget header;
  final Widget Function(BuildContext context, ScrollController controller)
  bodyBuilder;

  @override
  State<TwoAxisTableViewport> createState() => _TwoAxisTableViewportState();
}

class _TwoAxisTableViewportState extends State<TwoAxisTableViewport> {
  late final ScrollController _horizontalController;
  late final ScrollController _verticalController;

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
    _verticalController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : widget.minContentWidth;
        final viewportHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 320.0;

        final contentWidth = widget.minContentWidth > viewportWidth
            ? widget.minContentWidth
            : viewportWidth;
        final shouldScrollHorizontally = contentWidth > viewportWidth;

        return ClipRect(
          child: Scrollbar(
            controller: _horizontalController,
            thumbVisibility: shouldScrollHorizontally,
            trackVisibility: shouldScrollHorizontally,
            notificationPredicate:
                (notification) => notification.metrics.axis == Axis.horizontal,
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: contentWidth,
                height: viewportHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    widget.header,
                    Expanded(
                      child: Scrollbar(
                        controller: _verticalController,
                        thumbVisibility: true,
                        trackVisibility: true,
                        notificationPredicate:
                            (notification) =>
                                notification.metrics.axis == Axis.vertical,
                        child: widget.bodyBuilder(context, _verticalController),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
