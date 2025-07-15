import 'package:flutter/material.dart';
import 'package:master_node_monitor/generated/l10n.dart';
import 'package:master_node_monitor/src/utils/router/beldex_routes.dart';
import 'package:master_node_monitor/src/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import '../utils/theme/palette.dart';
import '../utils/theme/theme_changer.dart';
import '../utils/theme/themes.dart';

class WelcomePage extends StatelessWidget {
  static const _baseWidth = 411.43;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: body(context)));
  }

  Widget body(BuildContext context) {
    final _themeChanger = Provider.of<ThemeChanger>(context);
    final _isDarkTheme = _themeChanger.theme == Themes.darkTheme;
    final _screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = _screenWidth < _baseWidth ? 0.76 : 1.0;

    return Column(children: <Widget>[
      Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Image.asset('assets/images/mn_monitor_logo.png',
                    height: 124, width: 400),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  S.of(context).welcome,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryTextTheme.titleLarge!.color
                  ),
                  textScaleFactor: textScaleFactor,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    S.of(context).welcome_first_line,
                    style: TextStyle(
                      fontSize: 22.0,
                      color:_isDarkTheme ? PaletteDark.subTitleHead : Palette.subTitleHead
                    ),
                    textScaleFactor: textScaleFactor,
                    textAlign: TextAlign.center,
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    S.of(context).add_node_to_get_started,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Palette.subTitle,
                    ),
                    textScaleFactor: textScaleFactor,
                    textAlign: TextAlign.center,
                  ))
            ]),
      ),
      Container(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
          child: Column(children: <Widget>[
            PrimaryButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, BeldexRoutes.addMasterNode,arguments: true);
                },
                text: S.of(context).add_master_node,
                color:
                    Theme.of(context).primaryTextTheme.labelLarge!.backgroundColor!,
                borderColor:
                    Theme.of(context).primaryTextTheme.labelLarge!.decorationColor!),
          ]))
    ]);
  }
}
