import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:master_node_monitor/src/beldex/daemon.dart';
import 'package:master_node_monitor/src/beldex/master_node.dart';
import 'package:master_node_monitor/src/screens/dashboard_page.dart';
import 'package:master_node_monitor/src/screens/welcome_page.dart';
import 'package:master_node_monitor/src/stores/node_sync_store.dart';
import 'package:master_node_monitor/src/stores/settings_store.dart';
import 'package:master_node_monitor/src/utils/default_settings_migration.dart';
import 'package:master_node_monitor/src/utils/language.dart';
import 'package:master_node_monitor/src/utils/router/beldex_router.dart';
import 'package:master_node_monitor/src/utils/theme/palette.dart';
import 'package:master_node_monitor/src/utils/theme/theme_changer.dart';
import 'package:master_node_monitor/src/utils/theme/themes.dart';
import 'package:native_updater/native_updater.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  Hive.registerAdapter(MasterNodeAdapter());
  Hive.registerAdapter(DaemonAdapter());

  final masterNodes = await Hive.openBox<MasterNode>(MasterNode.boxName);
  final daemons = await Hive.openBox<Daemon>(Daemon.boxName);
  final sharedPreferences = await SharedPreferences.getInstance();

  await defaultSettingsMigration(1, sharedPreferences, daemons);

  final settingsStore =
      await SettingsStoreBase.load(sharedPreferences, daemons);
  final nodeSyncStore = NodeSyncStore(masterNodes, settingsStore);

  if (masterNodes.isNotEmpty) {
    await nodeSyncStore.sync();
    nodeSyncStore.startSync();
  }

  runApp(MultiProvider(providers: [
    Provider(create: (_) => masterNodes),
    Provider(create: (_) => daemons),
    Provider(create: (_) => sharedPreferences),
    Provider(create: (_) => settingsStore),
    Provider(create: (_) => nodeSyncStore),
  ], child: BeldexMasterNodeApp()));
}

class BeldexMasterNodeApp extends StatefulWidget {
  BeldexMasterNodeApp() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  _BeldexMasterNodeAppState createState() => _BeldexMasterNodeAppState();
}

class _BeldexMasterNodeAppState extends State<BeldexMasterNodeApp> {
  @override
  void initState() {
    super.initState();
    checkVersion(context);
  }

  Future<void> checkVersion(BuildContext context) async {

    Future.delayed(Duration.zero, () {
        NativeUpdater.displayUpdateAlert(
          context,
          forceUpdate: true,
          appStoreUrl: '',
          playStoreUrl: 'https://play.google.com/store/apps/details?id=io.beldex.master_node_monitor',
          iOSDescription: 'A new version of the Beldex Master Node Monitor is available. Update to continue using it.',
          iOSUpdateButtonLabel: 'Upgrade',
          iOSCloseButtonLabel: 'Exit',
          iOSAlertTitle: 'Mandatory Update',
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);

    return ChangeNotifierProvider<ThemeChanger>(
        create: (_) => ThemeChanger(
            settingsStore.isDarkTheme ? Themes.darkTheme : Themes.lightTheme),
        child: ChangeNotifierProvider<Language>(
            create: (_) => Language(settingsStore.languageCode),
            child: MaterialAppWithTheme()));
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sharedPreferences = Provider.of<SharedPreferences>(context);
    final settingsStore = Provider.of<SettingsStore>(context);
    final currentLanguage = Provider.of<Language>(context);
    final theme = Provider.of<ThemeChanger>(context);
    final masterNodes = Provider.of<Box<MasterNode>>(context);
    //final statusBarColor = settingsStore.isDarkTheme ? PaletteDark.darkThemeBackgroundDark : Palette.lightThemeBackground;

    final isSetup = masterNodes.isEmpty;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.black.withOpacity(0)));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.theme,
        localizationsDelegates: [
          S.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: Locale(currentLanguage.currentLanguage),
        onGenerateRoute: (settings) => BeldexRouter.generateRoute(
            settings, sharedPreferences, settingsStore),
        home: isSetup ? WelcomePage() : DashboardPage());
  }
}
