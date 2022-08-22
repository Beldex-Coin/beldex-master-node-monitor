import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:master_node_monitor/generated/l10n.dart';
import 'package:master_node_monitor/src/stores/settings_store.dart';
import 'package:master_node_monitor/src/utils/dashboard_sort_order.dart';
import 'package:master_node_monitor/src/utils/router/beldex_routes.dart';
import 'package:master_node_monitor/src/utils/theme/palette.dart';
import 'package:master_node_monitor/src/utils/theme/theme_changer.dart';
import 'package:master_node_monitor/src/widgets/base_page.dart';
import 'package:master_node_monitor/src/widgets/nav/nav_list_arrow.dart';
import 'package:master_node_monitor/src/widgets/nav/nav_list_header.dart';
import 'package:master_node_monitor/src/widgets/nav/nav_list_settings_header.dart';
import 'package:master_node_monitor/src/widgets/nav/nav_list_trailing.dart';
import 'package:master_node_monitor/src/widgets/present_picker.dart';
import 'package:master_node_monitor/src/widgets/standard_switch.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends BasePage {
  @override
  String get title => S.current.title_settings;

  Future<void> _setDashboardOrderBy(BuildContext context) async {
    final settingsStore = context.read<SettingsStore>();
    final selectedDashboardOrderBy =
        await presentPicker(context, DashboardOrderBy.values);

    if (selectedDashboardOrderBy != null) {
      await settingsStore.setDashboardOrderBy(selectedDashboardOrderBy);
    }
  }

  @override
  Widget body(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);
    final themeChanger = Provider.of<ThemeChanger>(context);
    settingsStore.themeChanger = themeChanger;

    return ListView(
      children: <Widget>[
        NavListSettingsHeader(S.of(context).settings_title_general),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            elevation: 5,
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              children: [
                NavListTrailing(
                  leading: SvgPicture.asset('assets/images/daemon.svg',color: Theme.of(context).primaryTextTheme.headline6.color,width: 25,height: 25,),
                  text: S.of(context).settings_daemon,
                  trailing: Observer(builder: (_) {
                    return Text(
                      settingsStore.daemon == null ? '' : settingsStore.daemon.hostname.substring(0,11),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 16.0,
                          overflow: TextOverflow.ellipsis,
                          color: BeldexPalette.progressCenterText),
                    );
                  }),
                  onTap: () =>
                      Navigator.of(context).pushNamed(BeldexRoutes.settingsDaemon),
                ),
                NavListArrow(
                  leading: SvgPicture.asset('assets/images/master_nodes.svg',color: Theme.of(context).primaryTextTheme.headline6.color,width: 20,height: 20,),
                  text: S.of(context).settings_master_nodes,
                  onTap: () =>
                      Navigator.of(context).pushNamed(BeldexRoutes.settingsMasterNode),
                ),
                NavListTrailing(
                  leading: SvgPicture.asset('assets/images/order.svg',color: Theme.of(context).primaryTextTheme.headline6.color,width: 20,height: 20,),
                  text: S.of(context).settings_order_by,
                  trailing: Observer(builder: (_) {
                    return Text(
                      settingsStore.dashboardOrderBy.toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 16.0,
                          overflow: TextOverflow.ellipsis,
                          color: BeldexPalette.progressCenterText),
                    );
                  }),
                  onTap: () => _setDashboardOrderBy(context),
                ),
              ],
            ),
          ),
        ),
        NavListSettingsHeader(S.of(context).settings_title_app),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            elevation: 5,
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              children: [
                Observer(builder: (_) {
                  return NavListTrailing(
                    leading: SvgPicture.asset('assets/images/theme.svg',color: Theme.of(context).primaryTextTheme.headline6.color,width: 23,height: 23,),
                    text: settingsStore.isDarkTheme
                        ? S.of(context).settings_light_theme
                        : S.of(context).settings_dark_theme,
                    trailing: StandardSwitch(
                      value: settingsStore.isDarkTheme,
                      onTaped: () => settingsStore.toggleDarkTheme(),
                    ),
                  );
                }),
                /*NavListArrow(
                  leading: SvgPicture.asset('assets/images/daemon.svg',color: Theme.of(context).primaryTextTheme.headline6.color,width: 25,height: 25,),
                  text: S.of(context).settings_language,
                  onTap: () =>
                      Navigator.of(context).pushNamed(BeldexRoutes.settingsLanguage),
                ),*/
                NavListArrow(
                  leading: SvgPicture.asset('assets/images/change_log.svg',color: Theme.of(context).primaryTextTheme.headline6.color,width: 25,height: 25,),
                  text: S.of(context).title_changelog,
                  onTap: () =>
                      Navigator.of(context).pushNamed(BeldexRoutes.settingsChangelog),
                ),
                NavListArrow(
                  leading: SvgPicture.asset('assets/images/faq.svg',color: Theme.of(context).primaryTextTheme.headline6.color,width: 25,height: 25,),
                  text: S.of(context).title_faq,
                  onTap: (){
                    Navigator.of(context).pushNamed(BeldexRoutes.faq);
                  },
                ),
                NavListArrow(
                  leading: SvgPicture.asset('assets/images/terms_and_conditions.svg',color: Theme.of(context).primaryTextTheme.headline6.color,width: 25,height: 25,),
                  text: S.of(context).termsConditions,
                  onTap: (){
                    Navigator.of(context).pushNamed(BeldexRoutes.termsAndConditions);
                  },
                ),
                NavListArrow(
                  leading: SvgPicture.asset('assets/images/help.svg',color: Theme.of(context).primaryTextTheme.headline6.color,width: 23,height: 23,),
                  text: S.of(context).help,
                  onTap: (){
                    _launchUrl(Uri.parse('mailto:support@beldex.io'));
                  },
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 35, top: 10),
          child: Text("Version 1.0.0",style: TextStyle(fontSize: 16.0,color: BeldexPalette.progressCenterText),),
        )
      ],
    );
  }

  /*void _launchUrl(String url) async {
    print('call _launchURL');
    if (await canLaunch(url)) await launch(url);
  }*/

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
