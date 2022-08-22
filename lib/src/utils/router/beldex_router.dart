import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_node_monitor/generated/l10n.dart';
import 'package:master_node_monitor/src/screens/add_new_daemon_page.dart';
import 'package:master_node_monitor/src/screens/add_new_master_node_page.dart';
import 'package:master_node_monitor/src/screens/change_language_page.dart';
import 'package:master_node_monitor/src/screens/changelog_page.dart';
import 'package:master_node_monitor/src/screens/dashboard_page.dart';
import 'package:master_node_monitor/src/screens/details_master_node/page.dart';
import 'package:master_node_monitor/src/screens/edit_daemons.dart';
import 'package:master_node_monitor/src/screens/edit_master_node_page.dart';
import 'package:master_node_monitor/src/screens/edit_master_nodes.dart';
import 'package:master_node_monitor/src/screens/faq_page.dart';
import 'package:master_node_monitor/src/screens/settings_page.dart';
import 'package:master_node_monitor/src/screens/terms_and_conditions.dart';
import 'package:master_node_monitor/src/screens/welcome_page.dart';
import 'package:master_node_monitor/src/stores/settings_store.dart';
import 'package:master_node_monitor/src/utils/edit_master_node_arguments.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'beldex_routes.dart';

class BeldexRouter {
  static Route<dynamic> generateRoute(RouteSettings settings,
      SharedPreferences sharedPreferences, SettingsStore settingsStore) {
    final args = settings.arguments;
    switch (settings.name) {
      case BeldexRoutes.welcome:
        return MaterialPageRoute<void>(builder: (_) => WelcomePage());

      case BeldexRoutes.addMasterNode:
        return CupertinoPageRoute<void>(
            builder: (_) => AddNewMasterNodePage(args as bool));

      case BeldexRoutes.editMasterNode:
        return CupertinoPageRoute<void>(
            builder: (_) {
              EditMasterNodeArguments argument = args;
              return EditMasterNodePage(argument.publicKey, argument.status);});

      case BeldexRoutes.addDaemon:
        return CupertinoPageRoute<void>(builder: (_) => AddNewDaemonPage());

      case BeldexRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => DashboardPage());

      case BeldexRoutes.settings:
        return CupertinoPageRoute(builder: (_) => SettingsPage());

      case BeldexRoutes.settingsLanguage:
        return CupertinoPageRoute(builder: (_) => ChangeLanguagePage());

      case BeldexRoutes.settingsDaemon:
        return CupertinoPageRoute(builder: (_) => EditDaemonsPage());

      case BeldexRoutes.settingsChangelog:
        return CupertinoPageRoute(builder: (_) => ChangelogPage());

      case BeldexRoutes.settingsMasterNode:
        return CupertinoPageRoute(builder: (_) => EditMasterNodesPage());

      case BeldexRoutes.detailsMasterNode:
        return CupertinoPageRoute(builder: (_) {
          List<String> args = settings.arguments;
          String nodeName = args.length > 1 ? args[1] : null;
          return DetailsMasterNodePage(args.first, nodeName: nodeName);
        });

      case BeldexRoutes.termsAndConditions:
        return CupertinoPageRoute(builder: (_) => TermsAndConditions());

      case BeldexRoutes.faq:
        return CupertinoPageRoute(builder: (_) => FaqPage());

      default:
        return MaterialPageRoute<void>(
            builder: (_) => Scaffold(
                  body: Center(
                      child:
                          Text(S.current.error_router_no_route(settings.name))),
                ));
    }
  }
}
