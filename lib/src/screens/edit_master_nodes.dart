import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:master_node_monitor/generated/l10n.dart';
import 'package:master_node_monitor/src/beldex/master_node.dart';
import 'package:master_node_monitor/src/stores/node_sync_store.dart';
import 'package:master_node_monitor/src/utils/edit_master_node_arguments.dart';
import 'package:master_node_monitor/src/utils/router/beldex_routes.dart';
import 'package:master_node_monitor/src/utils/short_address.dart';
import 'package:master_node_monitor/src/utils/theme/palette.dart';
import 'package:master_node_monitor/src/widgets/base_page.dart';
import 'package:provider/provider.dart';

class EditMasterNodesPage extends BasePage {
  @override
  String get title => S.current.title_edit_master_nodes;

  @override
  Widget trailing(BuildContext context) {
    return SizedBox(
      width: 30,
      child: MaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: () =>
              Navigator.of(context).pushNamed(BeldexRoutes.addMasterNode,arguments: false),
          child: Icon(Icons.add_sharp,
              color: Theme.of(context).primaryTextTheme.caption.color,
              size: 24)),
    );
  }

  @override
  Widget body(BuildContext context) => EditMasterNodesPageBody();
}

class EditMasterNodesPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EditMasterNodesPageBodyState();
}

class EditMasterNodesPageBodyState extends State<EditMasterNodesPageBody> {

  Future _deleteMasterNode(NodeSyncStore nodeSyncStore, Box<MasterNode> masterNodeSources, MasterNode masterNode) async {
    await masterNodeSources.delete(masterNode.key);

    if (masterNodeSources.isEmpty)
      Navigator.pushNamedAndRemoveUntil(context, BeldexRoutes.welcome,
          ModalRoute.withName(BeldexRoutes.dashboard));
    else {
      await nodeSyncStore.sync();
      setState(() {

      });
    }
  }

  void showConfirmationDialog(BuildContext context, NodeSyncStore nodeSyncStore, Box<MasterNode> masterNodeSources, MasterNode masterNode){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Are you sure you want to delete this Node from this list?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.none,
                      color: Theme.of(context).primaryTextTheme.caption.color,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonTheme(
                        height: 56.0,
                        child: TextButton(
                          onPressed:(){
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryTextTheme.headline3.backgroundColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      side: BorderSide(color: Theme.of(context).primaryTextTheme.headline3.backgroundColor),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top:2.0,bottom: 2.0,left: 18.0,right: 18.0),
                            child: Text("Cancel",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Theme.of(context).primaryTextTheme.headline3.color)),
                          ),
                        )),
                    ButtonTheme(
                        height: 56.0,
                        child: TextButton(
                          onPressed:(){
                            _deleteMasterNode(nodeSyncStore,masterNodeSources,masterNode);
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(BeldexPalette.deleteButton),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      side: BorderSide(color: BeldexPalette.deleteButton),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top:2.0,bottom: 2.0,left: 18.0,right: 18.0),
                            child: Text("Delete",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Theme.of(context).primaryTextTheme.button.color)),
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final masterNodeSources = context.watch<Box<MasterNode>>();
    final nodeSyncStore = context.watch<NodeSyncStore>();

    final masterNodes = masterNodeSources.values.toList();

    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          Expanded(
              child: ListView.separated(
                  separatorBuilder: (_, __) => Divider(
                      color: Theme.of(context).dividerTheme.color, height: 1),
                  itemCount: masterNodes.length,
                  itemBuilder: (BuildContext context, int index) {
                    final masterNode = masterNodes[index];
                    final publicKey = masterNode.publicKey;

                    final content = Container(
                      padding: EdgeInsets.all(10),
                        child: ListTile(
                      leading: Icon(CupertinoIcons.chart_bar_fill,color: Theme.of(context)
                          .primaryTextTheme
                          .headline6
                          .color,),
                      trailing: InkWell(
                        onTap: () {
                          showConfirmationDialog(context,nodeSyncStore,masterNodeSources,masterNode);
                        },
                        child: SvgPicture.asset('assets/images/delete.svg',color:BeldexPalette.deleteButton,width: 20,height: 20,),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            masterNode.name,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .headline6
                                    .color),
                          ),
                          SizedBox(height: 10,),
                          Text(publicKey.toShortAddress(16),
                            style: TextStyle(
                                fontSize: 12.0,
                                color: BeldexPalette.progressCenterText),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, BeldexRoutes.editMasterNode,
                                arguments: EditMasterNodeArguments(publicKey, false))
                            .whenComplete(() => setState(() {}));
                      },
                    ));

                    return Card(
                        color: Theme.of(context).cardColor,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: content);/*Dismissible(
                        key: Key('${masterNode.key}'),
                        onDismissed: (direction) async {
                          await masterNodeSources.delete(masterNode.key);

                          if (masterNodeSources.isEmpty)
                            Navigator.pushNamedAndRemoveUntil(context, BeldexRoutes.welcome,
                                ModalRoute.withName(BeldexRoutes.dashboard));
                          else
                            await nodeSyncStore.sync();
                        },
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: EdgeInsets.only(right: 10.0),
                          alignment: AlignmentDirectional.centerEnd,
                          color: BeldexPalette.red,
                          child: SvgPicture.asset('assets/images/delete.svg',color:Colors.white,width: 20,height: 20,),
                        ),
                        child: Card(
                            color: Theme.of(context).cardColor,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: content));*/
                  }))
        ],
      ),
    );
  }
}
