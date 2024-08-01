import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_node_monitor/generated/l10n.dart';
import 'package:master_node_monitor/src/widgets/beldex/beldex_dialog.dart';

import 'primary_button.dart';

Future<T> presentPicker<T extends Object>(
    BuildContext context, List<T> list) async {
  var _value = list[0];

  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return BeldexDialog(
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Order Nodes By',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Theme.of(context).primaryTextTheme.caption!.color,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Container(
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: CupertinoPicker(
                    backgroundColor: Theme.of(context).primaryTextTheme.overline!.color,
                    itemExtent: 45.0,
                    onSelectedItemChanged: (int index) => _value = list[index],
                    children: List.generate(
                      list.length,
                      (index) => Center(
                        child: Text(
                          list[index].toString(),
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .caption!
                                .color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              PrimaryButton(
                text: "Okay",
                color:
                    Theme.of(context).primaryTextTheme.button!.backgroundColor!,
                borderColor:
                    Theme.of(context).primaryTextTheme.button!.decorationColor!,
                onPressed: () => Navigator.of(context).pop(_value),
              )
            ],
          ),
        ),
      );
    },
  );
}
