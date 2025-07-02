import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_node_monitor/generated/l10n.dart';
import 'package:master_node_monitor/src/widgets/beldex/beldex_dialog.dart';

import '../stores/settings_store.dart';
import '../utils/theme/palette.dart';
import 'primary_button.dart';

Future<T?>? presentPicker<T extends Object>(
    BuildContext context, List<T> list, SettingsStore settingsStore) async {
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
                    color: Theme.of(context).primaryTextTheme.bodySmall!.color,
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
                    backgroundColor: settingsStore.isDarkTheme ? PaletteDark.textFieldBackground : Palette.textFieldBackground,
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
                                .bodySmall!
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
                    Theme.of(context).primaryTextTheme.labelLarge!.backgroundColor!,
                borderColor:
                    Theme.of(context).primaryTextTheme.labelLarge!.decorationColor!,
                onPressed: () => Navigator.of(context).pop(_value),
              )
            ],
          ),
        ),
      );
    },
  );
}
