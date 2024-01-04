import 'package:flutter/material.dart';
import 'package:rb_share/src/core/utils/styles.dart';

class EmptyWidget extends StatelessWidget {
  final String message;

  const EmptyWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.warning,
          size: 48,
        ),
        Text(message, style: CommonTextStyle.textStyleNormal),
      ],
    ));
  }
}
