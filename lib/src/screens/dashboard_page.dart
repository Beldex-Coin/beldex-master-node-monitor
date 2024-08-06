import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:master_node_monitor/generated/l10n.dart';
import 'package:master_node_monitor/src/beldex/check_master_node.dart';
import 'package:master_node_monitor/src/beldex/master_node.dart';
import 'package:master_node_monitor/src/beldex/master_node_status.dart';
import 'package:master_node_monitor/src/stores/node_sync_store.dart';
import 'package:master_node_monitor/src/stores/settings_store.dart';
import 'package:master_node_monitor/src/utils/dashboard_sort_order.dart';
import 'package:master_node_monitor/src/utils/network_service.dart';
import 'package:master_node_monitor/src/utils/router/beldex_routes.dart';
import 'package:master_node_monitor/src/utils/theme/palette.dart';
import 'package:master_node_monitor/src/utils/theme/theme_changer.dart';
import 'package:master_node_monitor/src/utils/theme/themes.dart';
import 'package:master_node_monitor/src/utils/validators.dart';
import 'package:master_node_monitor/src/widgets/base_page.dart';
import 'package:master_node_monitor/src/widgets/beldex/beldex_text_field.dart';
import 'package:master_node_monitor/src/widgets/master_node_card.dart';
import 'package:master_node_monitor/src/widgets/primary_button.dart';
import 'package:master_node_monitor/src/widgets/spinner.dart';
import 'package:provider/provider.dart';

class OperatorStatus {
  OperatorStatus(this.healthyNodes, this.unhealthyNodes);

  final int healthyNodes;
  final int unhealthyNodes;

  static OperatorStatus load(List<MasterNodeStatus> nodes) {
    var healthyNodes = 0;
    var unhealthyNodes = 0;

    if (nodes != null) {
      for (final node in nodes) {
        if ((node.active && node.funded) || (!node.active && !node.funded))
          healthyNodes++;
        else
          unhealthyNodes++;
      }
    }

    return OperatorStatus(healthyNodes, unhealthyNodes);
  }

  int get totalNodes => healthyNodes + unhealthyNodes;

  double get healthPercentage => totalNodes > 0 ? healthyNodes / totalNodes : 1;
}

class DashboardPage extends BasePage {
  @override
  String get title => S.current.title_dashboard;

  @override
  Widget leading(BuildContext context) {
    final nodeSyncStatus = Provider.of<NodeSyncStore>(context);
    return SizedBox(
      width: 30,
      child: Observer(builder: (_) {
        if (nodeSyncStatus.isSyncing) return Spinner(icon: Icons.sync);
        return MaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            nodeSyncStatus.sync();
          },
          child: Icon(Icons.sync,
              color: Theme.of(context).primaryTextTheme.caption!.color,
              size: 24),
        );
      }),
    );
  }

  @override
  Widget trailing(BuildContext context) {
    return SizedBox(
      width: 30,
      child: MaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: () => Navigator.of(context).pushNamed(BeldexRoutes.settings),
          child: Icon(Icons.settings_sharp,
              color: Theme.of(context).primaryTextTheme.caption!.color,
              size: 24)),
    );
  }

  @override
  Widget body(BuildContext context) => DashboardPageBody();
}

class DashboardPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DashboardPageBodyState();
}

class DashboardPageBodyState extends State<DashboardPageBody> {

  //SteveJosephh21
  final _nameController = TextEditingController();
  final _publicKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isDuplicatePublicKey(
      String publicKey, Box<MasterNode> masterNodeSource) =>
      masterNodeSource.values.any((element) => element.publicKey == publicKey);

  bool _isDuplicateName(String name, Box<MasterNode> masterNodeSource) =>
      masterNodeSource.values.any((element) => element.name == name);

  Future _saveMasterNode(Box<MasterNode> masterNodeSource, SettingsStore settingsStore, NodeSyncStore nodeSyncStatus, NetworkStatus networkStatus) async {
    if(networkStatus == NetworkStatus.online) {
      var checkPublicKey = settingsStore.daemon != null
          ? CheckMasterNode(settingsStore.daemon!.uri, _publicKeyController.text)
          : CheckMasterNode("", _publicKeyController.text);
      bool validPublicKey = await checkPublicKey.isOnline();
      if (validPublicKey) {
        final masterNode = MasterNode(name: _nameController.text, publicKey: _publicKeyController.text);
        await masterNodeSource.add(masterNode);
        await nodeSyncStatus.sync();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded,
                  color: Colors.white,),
                SizedBox(width: 10,),
                Text(S
                    .of(context)
                    .success_saved_node, style: TextStyle(
                    fontSize: 16, color: Colors.white),),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: BeldexPalette
                .tealWithOpacity));
        setLoading(false);
        Navigator.of(context).pop();
        _nameController.text = "";
        _publicKeyController.text = "";
        await nodeSyncStatus.sync();
      }else {
        callCommonScaffoldMessenger(S.of(context).enterAValidPublicKey);
        setLoading(false);
      }
    }else{
      callCommonScaffoldMessenger(S.of(context).checkYourInternetConnection);
      setLoading(false);
    }
  }

  void callCommonScaffoldMessenger(String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text,
              style: TextStyle(fontSize: 16, color: Colors.white),),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: BeldexPalette.red));
  }
  StateSetter? _setState;
  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _publicKeyController.dispose();
    isLoading = false;
    super.dispose();
  }

  void setLoading(bool value) {
    _setState!(() {
      isLoading = value;
    });
  }

  //SteveJosephh21
  Future<dynamic> showDialogBox(BuildContext context, TextEditingController _nameController, Box<MasterNode> masterNodeSource, NodeSyncStore nodeSyncStatus, TextEditingController _publicKeyController, GlobalKey<FormState> _formKey, SettingsStore settingsStore){
    return showDialog(
        context:context,
        barrierDismissible: false,
        builder:(context)=> StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final networkStatus = Provider.of<NetworkStatus>(context);
            _setState = setState;
            return Center(
              child: Card(
                elevation: 10,
                color: Theme
                    .of(context)
                    .cardColor,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 30, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(S.current.title_add_master_node,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),),
                          SizedBox(width: 50),
                          InkWell(onTap: () {
                            Navigator.of(context).pop();
                            _nameController.text = "";
                            _publicKeyController.text = "";
                          }, child: SvgPicture.asset(
                            'assets/images/close.svg', width: 25,
                            height: 25,
                            color: Theme
                                .of(context)
                                .primaryTextTheme
                                .caption!
                                .color,)),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 30),
                        child: Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: BeldexTextField(
                              backgroundColor: Theme
                                  .of(context)
                                  .primaryTextTheme
                                  .overline!
                                  .color!,
                              controller: _nameController,
                              hintText: S
                                  .of(context)
                                  .name,
                              maxLength: 15,
                              validator: (value) {
                                final isDuplicate =
                                _isDuplicateName(value!, masterNodeSource);
                                if (value.trim().isEmpty) {
                                  setLoading(false);
                                  return S.of(context).pleaseEnterAName;
                                }
                                else if (isDuplicate) {
                                  setLoading(false);
                                  return S
                                      .of(context)
                                      .error_name_taken;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: BeldexTextField(
                              backgroundColor: Theme
                                  .of(context)
                                  .primaryTextTheme
                                  .overline!
                                  .color!,
                              controller: _publicKeyController,
                              hintText: S
                                  .of(context)
                                  .public_key,
                              suffixIcon: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  color: BeldexPalette.pasteIcon,
                                  icon: Icon(Icons.content_paste_sharp),
                                  onPressed: () async {
                                    final clipboard = await Clipboard.getData(
                                        'text/plain');
                                    if (clipboard?.text != null)
                                      _publicKeyController.text =
                                          clipboard!.text!;
                                  }),
                              validator: (value) {
                                final publicKey = value?.trim();
                                final validPublicKey = isValidPublicKey(
                                    publicKey!);
                                final isDuplicate =
                                _isDuplicatePublicKey(
                                    publicKey, masterNodeSource);
                                if (publicKey.isEmpty) {
                                  setLoading(false);
                                  return S.of(context).enterAPublicKey;
                                }
                                else
                                if (validPublicKey == KeyValidity.TOO_SHORT ||
                                    validPublicKey == KeyValidity.TOO_LONG) {
                                  setLoading(false);
                                  return S.of(context).enterAValidPublicKey;
                                }
                                else if (isDuplicate) {
                                  setLoading(false);
                                  return S
                                      .of(context)
                                      .error_you_are_already_monitoring;
                                }
                                return null;
                              },
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 30),
                      child: LoadingPrimaryButton(
                          isLoading: isLoading,
                          onPressed: () async {
                            setLoading(true);
                            if (!_formKey.currentState!.validate()) return;
                            await _saveMasterNode(masterNodeSource,settingsStore,nodeSyncStatus,networkStatus);
                          },
                          text: S
                              .of(context)
                              .add_master_node,
                          color: Theme
                              .of(context)
                              .primaryTextTheme
                              .button!
                              .backgroundColor!,
                          borderColor:
                          Theme
                              .of(context)
                              .primaryTextTheme
                              .button!
                              .decorationColor!),
                    )
                  ],
                ),
              ),
            );
          }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    //SteveJosephh21
    final _themeChanger = Provider.of<ThemeChanger>(context);
    final _isDarkTheme = _themeChanger.theme == Themes.darkTheme;

    final nodeSyncStatus = context.watch<NodeSyncStore>();
    final nodes = context.watch<Box<MasterNode>>();
    final settingsStore = Provider.of<SettingsStore>(context);

    //SteveJosephh21
    final masterNodeSource = context.read<Box<MasterNode>>();

    return Observer(builder: (_) {
      final operatorStatus = OperatorStatus.load(nodeSyncStatus.nodes);

      final operatorStatusText = operatorStatus.healthPercentage == 1.0
          ? S.of(context).health_all_nodes(operatorStatus.totalNodes)
          : (operatorStatus.healthPercentage == 0
              ? S.of(context).health_no_nodes
              : S.of(context).health_out_of_nodes(
                  operatorStatus.healthyNodes, operatorStatus.totalNodes));

      if (nodeSyncStatus.nodes != null) {
        switch (settingsStore.dashboardOrderBy) {
          case DashboardOrderBy.NAME:
            nodeSyncStatus.nodes.sort((a, b) {
              var aN = nodes.values
                  .firstWhere((e) => e.publicKey == b.nodeInfo.publicKey)
                  .name
                  .toUpperCase();
              var bN = nodes.values
                  .firstWhere((e) => e.publicKey == a.nodeInfo.publicKey)
                  .name
                  .toUpperCase();
              return bN.compareTo(aN);
            });
            break;
          case DashboardOrderBy.LAST_UPTIME_PROOF:
            nodeSyncStatus.nodes
                .sort((a, b) => a.lastUptimeProof.compareTo(b.lastUptimeProof));
            break;
          case DashboardOrderBy.NEXT_REWARD:
            nodeSyncStatus.nodes.sort((a, b) =>
                a.lastReward.blockHeight.compareTo(b.lastReward.blockHeight));
        }
      }

      return ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 18, bottom: 28),
                    child: SizedBox(
                      height: 220.0,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: 210,
                              height: 210,
                              child: Stack(
                                children: [
                                  Container(
                                      width: 210,
                                      height: 210,
                                      margin: EdgeInsets.all(10),
                                      child: PhysicalShape(
                                        color: _isDarkTheme
                                            ? Theme.of(context).backgroundColor
                                            : Colors.white70,
                                        shadowColor:
                                        _isDarkTheme ? Colors.black45 : Colors.grey,
                                        elevation: 13,
                                        clipper:
                                        ShapeBorderClipper(shape: CircleBorder()),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 25,
                                          value: 1,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                              Theme.of(context)
                                                  .primaryTextTheme
                                                  .bodyText1!
                                                  .color!),
                                          backgroundColor: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyText1!
                                              .color,
                                        ),
                                      )),
                                  Center(
                                    child: Container(
                                      width: 190,
                                      height: 190,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 10,
                                        value: operatorStatus.healthPercentage,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            BeldexPalette.progressIndicator),
                                        backgroundColor: BeldexPalette.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(operatorStatusText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14.0, color: BeldexPalette.progressCenterText,fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 28),
                      child: Text(
                        S.of(context).all_master_nodes(
                            nodeSyncStatus.networkSize, nodeSyncStatus.currentHeight),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0, color: BeldexPalette.progressCenterText),
                      )),
                ],
              ),
              Card(
                color: Theme.of(context).cardColor,
                margin: EdgeInsets.only(left: 10,right: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin:EdgeInsets.only(left: 30,right: 25,top: 20,bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: '${S.of(context).your_master_nodes} ', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Theme.of(context).primaryTextTheme.caption!.backgroundColor)),
                                TextSpan(text: '${ nodeSyncStatus.nodes != null
                                    ? nodeSyncStatus.nodes.length
                                    : 0}', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Theme.of(context).primaryTextTheme.caption!.color)),
                              ],
                            ),
                          ),
                          InkWell(onTap:(){
                            showDialogBox(context,_nameController,masterNodeSource,nodeSyncStatus,_publicKeyController,_formKey,settingsStore);
                          },child: Icon(Icons.add_circle))
                        ],
                      ),
                    ),
                    Container(
                      margin:EdgeInsets.only(bottom: 150),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: nodeSyncStatus.nodes.map((e) {
                          final nodeStatus = e;//nodeSyncStatus.nodes[index];
                          final masterNodeKey = nodeStatus.nodeInfo.publicKey;
                          final nodeSource = nodes.values.firstWhere((e) {
                            return e.publicKey == masterNodeKey;
                          });
                          return MasterNodeCard(
                            nodeSource.name,
                            masterNodeKey,
                            nodeStatus.isUnlocking,
                            nodeStatus.active,
                            nodeStatus.storageServer.isReachable,
                            nodeStatus.lokinetRouter.isReachable,
                            nodeStatus.lastReward.blockHeight,
                            nodeStatus.earnedDowntimeBlocks,
                            nodeStatus.lastUptimeProof,
                            nodeStatus.contribution);
                        }).toList()
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
                ]);
    });
  }
}
