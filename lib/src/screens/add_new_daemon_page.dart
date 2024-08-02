import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:master_node_monitor/generated/l10n.dart';
import 'package:master_node_monitor/src/beldex/daemon.dart';
import 'package:master_node_monitor/src/utils/network_service.dart';
import 'package:master_node_monitor/src/utils/router/beldex_routes.dart';
import 'package:master_node_monitor/src/utils/theme/palette.dart';
import 'package:master_node_monitor/src/widgets/base_page.dart';
import 'package:master_node_monitor/src/widgets/beldex/beldex_text_field.dart';
import 'package:master_node_monitor/src/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class AddNewDaemonPage extends BasePage {
  @override
  bool get actionBar => true;

  @override
  Widget body(BuildContext context) => AddNewDaemonPageBody();
}

class AddNewDaemonPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddNewDaemonPageBodyState();
}

class AddNewDaemonPageBodyState extends State<AddNewDaemonPageBody> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future _saveDaemon(Box<Daemon> daemonSource, NetworkStatus networkStatus) async {
    if(networkStatus == NetworkStatus.online) {
      var uri = _hostController.text;
      final port = _portController.text;

      if (port != null && port.isNotEmpty) uri = '$uri:$port';
      final daemon = Daemon(uri);
      bool daemonIsOnline = await daemon.isOnline();
      if (daemonIsOnline) {
        final daemonList = daemonSource.values.toList();
        var status = false;
        for(var i=0 ; i < daemonList.length;i++){
            if(daemonList[i].uri.contains(uri)){
              status = true;
            }
        }
        if(!status){
          await daemonSource.add(daemon);
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(BeldexRoutes.settingsDaemon);
        }else{
          callCommonScaffoldMessenger(S.of(context).theDaemonIsAlreadyExists);
          setLoading(false);
        }
      }  else {
        callCommonScaffoldMessenger(S.of(context).pleaseEnterAValidDaemon);
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

  String? _validateNodeAddress(String value) {
    const pattern =
        '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\$|^[-0-9a-zA-Z.]{1,253}\$';
    final isValid = RegExp(pattern).hasMatch(value);
    if(isValid) {
      return null;
    }else {
      setLoading(false);
      return S.current.error_text_daemon_address;
    }
  }

  String? _validateNodePort(String value) {
    const pattern = '^[0-9]{1,5}';
    final regExp = RegExp(pattern);
    bool isValid = false;

    if (regExp.hasMatch(value)) {
      try {
        final intValue = int.parse(value);
        isValid = (intValue >= 0 && intValue <= 65535);
      } catch (e) {}
    }

    if(isValid) {
      return null;
    }else{
      setLoading(false);
      return S.current.error_text_daemon_port;
    }
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(BeldexRoutes.settingsDaemon);
    return true;
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final daemonSource = Provider.of<Box<Daemon>>(context);
    final networkStatus = Provider.of<NetworkStatus>(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
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
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(BeldexRoutes.settingsDaemon);
                      },child: Icon(Icons.arrow_back_ios)),
                      SizedBox(width:70),
                      Text(S.current.title_add_daemon,
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
                          controller: _hostController,
                          hintText: S.of(context).daemon_address,
                          validator: (value) => _validateNodeAddress(value!),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: BeldexTextField(
                          backgroundColor: Theme.of(context).primaryTextTheme.overline!.color!,
                          controller: _portController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          hintText: S.of(context).daemon_port,
                          validator: (value) => _validateNodePort(value!),
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
                        await _saveDaemon(daemonSource,networkStatus);
                      },
                      text: S.of(context).add_daemon,
                      color: Theme.of(context).primaryTextTheme.button!.backgroundColor!,
                      borderColor:
                      Theme.of(context).primaryTextTheme.button!.decorationColor!),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
