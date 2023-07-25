import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final Widget? onExpanded;
  final double? height;
  final double? expandedHeight;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const HomeWidget({
    super.key,
    required this.title,
    required this.child,
    this.onExpanded,
    this.height,
    this.expandedHeight,
    this.margin,
    this.padding,
  });

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool _expanded = false;

  void onExpand() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onExpanded != null ? onExpand : () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (widget.onExpanded != null)
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down_rounded,
                    )
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: _expanded ? widget.expandedHeight : widget.height,
            padding: widget.padding ?? EdgeInsets.zero,
            child: _expanded ? widget.onExpanded! : widget.child,
          )
        ],
      ),
    );
  }
}
