import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:master_node_monitor/generated/l10n.dart';
import 'package:master_node_monitor/src/beldex/daemon.dart';
import 'package:master_node_monitor/src/stores/settings_store.dart';
import 'package:master_node_monitor/src/utils/router/beldex_routes.dart';
import 'package:master_node_monitor/src/utils/theme/palette.dart';
import 'package:master_node_monitor/src/widgets/base_page.dart';
import 'package:master_node_monitor/src/widgets/node_indicator.dart';
import 'package:provider/provider.dart';

class EditDaemonsPage extends BasePage {
  @override
  String get title => S.current.daemons;

  @override
  Widget trailing(BuildContext context) {
    return SizedBox(
      width: 30,
      child: MaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(BeldexRoutes.addDaemon);
          },
          child: Icon(Icons.add_circle,
              color: Theme
                  .of(context)
                  .primaryTextTheme
                  .caption!
                  .color,
              size: 24)),
    );
  }

  @override
  Widget body(BuildContext context) {
    final daemonSources = Provider.of<Box<Daemon>>(context);
    final settingsStore = Provider.of<SettingsStore>(context);

    final daemons = daemonSources.values.toList();
    final currentColor = Theme.of(context).selectedRowColor;
    final notCurrentColor = Theme.of(context).cardColor;

    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          Expanded(
              child: ListView.separated(
                  separatorBuilder: (_, __) => Divider(
                      color: Theme.of(context).dividerTheme.color, height: 1),
                  itemCount: daemons.length,
                  itemBuilder: (BuildContext context, int index) {
                    final daemon = daemons[index];

                    return Observer(builder: (_) {
                      final isCurrent = settingsStore.daemon == null
                          ? false
                          : daemon.key == settingsStore.daemon?.key;

                      final content = Container(
                          child: ListTile(
                            title: Text(
                              daemon.uri,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .headline6!
                                      .color),
                            ),
                            trailing: FutureBuilder(
                                future: daemon.isOnline(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.done:
                                      return NodeIndicator(
                                          active: snapshot.data as bool);
                                    default:
                                      return NodeIndicator();
                                  }
                                }),
                            onTap: () async {
                              if (!isCurrent) {
                                await settingsStore.setDaemon(daemon);
                                Navigator.of(context).pop();
                              }
                            },
                          ));

                      return isCurrent
                          ? Card(
                        color: isCurrent ? currentColor : notCurrentColor,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: content)
                          : Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                            child: Dismissible(
                                key: Key('${daemon.key}'),
                                onDismissed: (direction) async =>
                                    await daemonSources.delete(daemon.key),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  padding: EdgeInsets.only(right: 10.0),
                                  alignment: AlignmentDirectional.centerEnd,
                                  color: BeldexPalette.red,
                                  child:  SvgPicture.asset('assets/images/delete.svg',color:Colors.white,width: 20,height: 20,),
                                ),
                                child: content),
                          );
                    });
                  }))
        ],
      ),
    );
  }
}
