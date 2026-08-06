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
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: body(context)));
  }

  Widget body(BuildContext context) {
    final _themeChanger = Provider.of<ThemeChanger>(context);
    final _isDarkTheme = _themeChanger.theme == Themes.darkTheme;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _isTablet = _screenWidth > 600;
    final textScaler = _screenWidth < _baseWidth ? TextScaler.linear(0.76) : TextScaler.linear(1.0);
    final contentWidth = _isTablet ? 600.0 : _screenWidth;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: contentWidth),
        child: Column(children: <Widget>[
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Image.asset('assets/images/mn_monitor_logo.png',
                        height: _isTablet ? 160 : 124,
                        width: _isTablet ? 450 : 400),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      S.of(context).welcome,
                      style: TextStyle(
                        fontSize: _isTablet ? 36.0 : 30.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryTextTheme.titleLarge!.color
                      ),
                      textScaler: textScaler,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        S.of(context).welcome_first_line,
                        style: TextStyle(
                          fontSize: _isTablet ? 26.0 : 22.0,
                          color:_isDarkTheme ? PaletteDark.subTitleHead : Palette.subTitleHead
                        ),
                        textScaler: textScaler,
                        textAlign: TextAlign.center,
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        S.of(context).add_node_to_get_started,
                        style: TextStyle(
                          fontSize: _isTablet ? 26.0 : 22.0,
                          color: Palette.subTitle,
                        ),
                        textScaler: textScaler,
                        textAlign: TextAlign.center,
                      ))
                ]),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
              child: PrimaryButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, BeldexRoutes.addMasterNode,arguments: true);
                  },
                  text: S.of(context).add_master_node,
                  color:
                      Theme.of(context).primaryTextTheme.labelLarge!.backgroundColor!,
                  borderColor:
                      Theme.of(context).primaryTextTheme.labelLarge!.decorationColor!))
        ]),
      ),
    );
  }
}
