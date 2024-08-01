import 'dart:ui';

import 'package:flutter/material.dart';

Future showBeldexDialog(BuildContext context, Widget child,
    {required void Function(BuildContext context) onDismiss}) {
  return showDialog<void>(
    builder: (_) => BeldexDialog(body: child, onDismiss: onDismiss),
    context: context,
  );
}

class BeldexDialog extends StatelessWidget {
  BeldexDialog({required this.body, this.onDismiss});

  final void Function(BuildContext context)? onDismiss;
  final Widget body;

  void _onDismiss(BuildContext context) {
    if (onDismiss == null) {
      Navigator.of(context).pop();
    } else {
      onDismiss!(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onDismiss(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}
