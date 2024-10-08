import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:master_node_monitor/generated/l10n.dart';
import 'package:master_node_monitor/src/beldex/check_master_node.dart';
import 'package:master_node_monitor/src/beldex/master_node.dart';
import 'package:master_node_monitor/src/stores/node_sync_store.dart';
import 'package:master_node_monitor/src/stores/settings_store.dart';
import 'package:master_node_monitor/src/utils/network_service.dart';
import 'package:master_node_monitor/src/utils/router/beldex_routes.dart';
import 'package:master_node_monitor/src/utils/theme/palette.dart';
import 'package:master_node_monitor/src/utils/validators.dart';
import 'package:master_node_monitor/src/widgets/base_page.dart';
import 'package:master_node_monitor/src/widgets/beldex/beldex_text_field.dart';
import 'package:master_node_monitor/src/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class AddNewMasterNodePage extends BasePage {
  AddNewMasterNodePage(this.status);

  final bool status;

  @override
  bool get actionBar => true;

  @override
  Widget body(BuildContext context) => AddNewMasterNodePageBody(status);
}

class AddNewMasterNodePageBody extends StatefulWidget {
  AddNewMasterNodePageBody(this.status);

  final bool status;

  @override
  State<StatefulWidget> createState() => AddNewMasterNodePageBodyState(status);
}

class AddNewMasterNodePageBodyState extends State<AddNewMasterNodePageBody> {
  final _nameController = TextEditingController();
  final _publicKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  AddNewMasterNodePageBodyState(this.status);
  final bool status;

  bool _isDuplicatePublicKey(
          String publicKey, Box<MasterNode> masterNodeSource) =>
      masterNodeSource.values.any((element) => element.publicKey == publicKey);

  bool _isDuplicateName(String name, Box<MasterNode> masterNodeSource) =>
      masterNodeSource.values.any((element) => element.name == name);

  @override
  void dispose() {
    _nameController.dispose();
    _publicKeyController.dispose();
    super.dispose();
  }


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
                Icon(Icons.check_circle_rounded, color: Colors.white,),
                SizedBox(width: 10,),
                Text(S
                    .of(context)
                    .success_saved_node,
                  style: TextStyle(fontSize: 16, color: Colors.white),),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: BeldexPalette.tealWithOpacity));
        Navigator.of(context).pop();
        Navigator.pushNamed(context, BeldexRoutes.dashboard);
      } else {
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

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final masterNodeSource = context.read<Box<MasterNode>>();
    final nodeSyncStatus = context.read<NodeSyncStore>();
    final settingsStore = Provider.of<SettingsStore>(context);
    final networkStatus = Provider.of<NetworkStatus>(context);

    return Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: Card(
          elevation: 10,
          color: Theme.of(context).cardColor,
          margin: EdgeInsets.fromLTRB(10,0,10,0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(onTap:(){
                      if(status) {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, BeldexRoutes.welcome);
                      }else{
                        Navigator.of(context).pop();
                      }
                    },child: Icon(Icons.arrow_back_ios)),
                    SizedBox(width:50),
                    Text(S.current.title_add_master_node,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight:FontWeight.bold
                    ),),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: BeldexTextField(
                        backgroundColor: Theme.of(context).primaryTextTheme.overline!.color!,
                        controller: _nameController,
                        hintText: S.of(context).name,
                        maxLength: 15,
                        validator: (value) {
                          final isDuplicate = _isDuplicateName(value!, masterNodeSource);
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
                        backgroundColor: Theme.of(context).primaryTextTheme.overline!.color!,
                        controller: _publicKeyController,
                        hintText: S.of(context).public_key,
                        suffixIcon: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            color: BeldexPalette.pasteIcon,
                            icon: Icon(Icons.content_paste_sharp),
                            onPressed: () async {
                              final clipboard = await Clipboard.getData('text/plain');
                              if (clipboard?.text != null)
                                _publicKeyController.text = clipboard!.text!;
                            }),
                        validator: (value) {
                          final publicKey = value?.trim();
                          final validPublicKey = isValidPublicKey(publicKey!);
                          final isDuplicate =
                              _isDuplicatePublicKey(publicKey, masterNodeSource);
                          if (publicKey.isEmpty) {
                            setLoading(false);
                            return S.of(context).enterAPublicKey;
                          }
                          else if(validPublicKey == KeyValidity.TOO_SHORT || validPublicKey == KeyValidity.TOO_LONG) {
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
                margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 30),
                child: LoadingPrimaryButton(
                  isLoading: isLoading,
                    onPressed: () async {
                      setLoading(true);
                      if (!_formKey.currentState!.validate()) return;
                      await _saveMasterNode(masterNodeSource,settingsStore,nodeSyncStatus,networkStatus);
                    },
                    text: S.of(context).add_master_node,
                    color: Theme.of(context).primaryTextTheme.button!.backgroundColor!,
                    borderColor:
                    Theme.of(context).primaryTextTheme.button!.decorationColor!),
              )
            ],
          ),
        ),
      ),
    );
  }
}
