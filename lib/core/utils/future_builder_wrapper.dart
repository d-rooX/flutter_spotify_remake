import 'package:flutter/material.dart';

class FutureBuilderWrapper<T> extends StatefulWidget {
  final Future<T> future;
  final WidgetBuilder onLoading;
  final Widget Function(BuildContext context, T data) onDone;

  const FutureBuilderWrapper({
    super.key,
    required this.future,
    required this.onLoading,
    required this.onDone,
  });

  @override
  State<FutureBuilderWrapper<T>> createState() =>
      _FutureBuilderWrapperState<T>();
}

class _FutureBuilderWrapperState<T> extends State<FutureBuilderWrapper<T>> {
  T? _result;

  @override
  Widget build(BuildContext context) {
    if (_result != null) {
      return widget.onDone(context, _result!);
    }

    return FutureBuilder(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _result = snapshot.data;

          return widget.onDone(context, _result!);
        } else {
          return widget.onLoading(context);
        }
      },
    );
  }
}
