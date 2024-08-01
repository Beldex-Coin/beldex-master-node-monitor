import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:master_node_monitor/generated/l10n.dart';
import 'package:master_node_monitor/src/beldex/master_node.dart';
import 'package:master_node_monitor/src/stores/node_sync_store.dart';
import 'package:master_node_monitor/src/utils/router/beldex_routes.dart';
import 'package:master_node_monitor/src/utils/short_address.dart';
import 'package:master_node_monitor/src/utils/theme/palette.dart';
import 'package:master_node_monitor/src/widgets/base_page.dart';
import 'package:master_node_monitor/src/widgets/nav/nav_list_multiheader.dart';
import 'package:master_node_monitor/src/widgets/beldex/beldex_text_field.dart';
import 'package:master_node_monitor/src/widgets/primary_button.dart';
import 'package:master_node_monitor/src/widgets/scrollable_with_bottom_section.dart';
import 'package:provider/provider.dart';

class EditMasterNodePage extends BasePage {
  EditMasterNodePage({required this.publicKey, required this.status});

  final String publicKey;
  final bool status;

  @override
  void onClose(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  String get title => S.current.title_edit_master_node;

  @override
  Widget body(BuildContext context) => EditMasterNodePageBody(publicKey: this.publicKey,status: this.status);
}

class EditMasterNodePageBody extends StatefulWidget {
  EditMasterNodePageBody({required this.publicKey,required this.status});

  final String publicKey;
  final bool status;

  @override
  State<StatefulWidget> createState() =>
      EditMasterNodePageBodyState(publicKey: this.publicKey,status: this.status);
}

class EditMasterNodePageBodyState extends State<EditMasterNodePageBody> {
  EditMasterNodePageBodyState({required this.publicKey,required this.status});

  final String publicKey;
  final bool status;
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Box<MasterNode>? masterNodeSource;
  MasterNode? node;

  bool? _isDuplicateName(String name) =>
      masterNodeSource?.values.any((element) => element.name == name);

  @override
  void initState() {
    super.initState();
    masterNodeSource = context.read<Box<MasterNode>>();
    node = masterNodeSource?.values
        .firstWhere((e) => e.publicKey == this.publicKey);

    _nameController.text = node!.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future _saveMasterNode() async {
    node?.name = _nameController.text;
    await node?.save();
  }

  Future _deleteMasterNode(bool status, NodeSyncStore nodeSyncStore) async {
    await node?.delete();

    if (masterNodeSource!.isEmpty)
      Navigator.pushNamedAndRemoveUntil(context, BeldexRoutes.welcome,
          ModalRoute.withName(BeldexRoutes.dashboard));
    else {
      if(status) {
        Navigator.pop(context);
        Navigator.pop(context);
        nodeSyncStore.sync();
      }else{
        Navigator.pop(context);
      }
    }
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void showConfirmationDialog(BuildContext context, bool status, NodeSyncStore nodeSyncStore){
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
                      color: Theme.of(context).primaryTextTheme.caption!.color,
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
                              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryTextTheme.headline3!.backgroundColor!),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      side: BorderSide(color: Theme.of(context).primaryTextTheme.headline3!.backgroundColor!),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top:2.0,bottom: 2.0,left: 18.0,right: 18.0),
                            child: Text("Cancel",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Theme.of(context).primaryTextTheme.headline3!.color)),
                          ),
                        )),
                    ButtonTheme(
                        height: 56.0,
                        child: TextButton(
                          onPressed:(){
                            _deleteMasterNode(status,nodeSyncStore);
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
                                    color: Theme.of(context).primaryTextTheme.button!.color)),
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
    final nodeSyncStore = context.watch<NodeSyncStore>();

    return ScrollableWithBottomSection(
      contentPadding: EdgeInsets.all(0),
      content: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
          child: Column(children: <Widget>[
            Container(
                margin:EdgeInsets.only(top: 15,bottom: 10),
                alignment:AlignmentDirectional.centerStart,child: Text(S.of(context).name,style: TextStyle(fontSize:20.0,color: BeldexPalette.progressCenterText),)),
            BeldexTextField(
              backgroundColor:Theme.of(context).primaryTextTheme.headline2!.color!,
              controller: _nameController,
              hintText: S.of(context).name,
              validator: (value) {
                final isDuplicate = _isDuplicateName(value!);
                if (value.isEmpty) {
                  setLoading(false);
                  return S.of(context).pleaseEnterAName;
                }
                else if (isDuplicate!) {
                  setLoading(false);
                  return S
                      .of(context)
                      .error_name_taken;
                }
                //return null;
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 20,bottom: 30),
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.of(context).public_key,
                    style: TextStyle(fontSize: 18.0, color: BeldexPalette.progressCenterText),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    publicKey,//publicKey.toShortAddress(20),
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryTextTheme.headline5?.color),
                  )
                ],
              ),
            ),
            PrimaryIconButton(
              onPressed:(){ showConfirmationDialog(context,status,nodeSyncStore);},
              text: S.of(context).delete_master_node,
              color: BeldexPalette.deleteButton,
              borderColor: BeldexPalette.deleteButton,
              textColor: Colors.white,
            ),
          ]),
        ),
      ),
      bottomSection: LoadingPrimaryButton(
        isLoading:isLoading,
          onPressed: () async {
            setLoading(true);
            if (!_formKey.currentState!.validate()) return;
            await _saveMasterNode();
            await nodeSyncStore.sync();
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
                    Text(S.of(context).success_saved_node,style: TextStyle(fontSize:16,color: Colors.white),),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: BeldexPalette.tealWithOpacity));
            Navigator.pop(context);
          },
          text: S.of(context).save_master_node,
          color: Theme.of(context).primaryTextTheme.button!.backgroundColor!,
          borderColor: Theme.of(context).primaryTextTheme.button!.decorationColor!),
    );
  }
}
