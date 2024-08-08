import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:master_node_monitor/generated/l10n.dart';
import 'package:master_node_monitor/src/utils/router/beldex_routes.dart';
import 'package:master_node_monitor/src/utils/short_address.dart';
import 'package:master_node_monitor/src/utils/theme/palette.dart';
import 'package:master_node_monitor/src/beldex/master_node_status.dart';

class MasterNodeCard extends StatefulWidget {
  MasterNodeCard(
      this.name,
      this.masterNodeKey,
      this.isUnlocking,
      this.active,
      this.isStorageServerReachable,
      this.isLokinetRouterReachable,
      this.lastRewardBlockHeight,
      this.earnedDowntimeBlocks,
      this.lastUptimeProof,
      this.contribution);

  final String name;
  final String masterNodeKey;
  final bool isUnlocking;
  final bool active;
  final bool isStorageServerReachable;
  final bool isLokinetRouterReachable;
  final int lastRewardBlockHeight;
  final int earnedDowntimeBlocks;
  final DateTime lastUptimeProof;
  final Contribution contribution;

  final localeName = Platform.localeName; // Hack to fix Local 'built' has not been initialized

  @override
  State<StatefulWidget> createState() => _MasterNodeCardState();
}

class _MasterNodeCardState extends State<MasterNodeCard> {
  static const int DECOMMISSION_MAX_CREDIT = 1440;

  var _tileExpanded = false;

  @override
  Widget build(BuildContext context) {
    final masterNodeKey = widget.masterNodeKey;
    final name = widget.name;
    final isUnlocking = widget.isUnlocking;
    final active = widget.active;
    final earnedDowntimeBlocks = widget.earnedDowntimeBlocks;
    final lastUptimeProof = widget.lastUptimeProof;
    final lastRewardBlockHeight = widget.lastRewardBlockHeight;
    final isStorageServerReachable = widget.isStorageServerReachable;
    final isLokinetRouterReachable = widget.isLokinetRouterReachable;
    final contribution = widget.contribution;

    final masterNodeKeyShort = masterNodeKey.toShortAddress();
    final partiallyStaked = contribution.totalContributed / 1000000000 < 10000;
    final remainingContribution = partiallyStaked
      ? ' (${contribution.totalContributed ~/ 1000000000} / 10000 BELDEX)'
      : '';
    final earnedDowntimeBlocksDisplay = partiallyStaked
      ? ''
      : '';//: ' ($earnedDowntimeBlocks / $DECOMMISSION_MAX_CREDIT ${S.of(context).blocks})';
    final statusIcon = isUnlocking
        ? SvgPicture.asset('assets/images/locked.svg',width: 30,height: 30,)
        : (active
            ? SvgPicture.asset('assets/images/active.svg',width: 30,height: 30,)
	    : partiallyStaked
		? SvgPicture.asset('assets/images/contributor.svg',width: 20,height: 20,)
		: SvgPicture.asset('assets/images/deactivate.svg',width: 30,height: 30,));//Icon(Icons.error_sharp, color: BeldexPalette.red, size: 30)

    return Card(
      color: active ? Theme.of(context).primaryTextTheme.bodyText2!.color : Theme.of(context).primaryTextTheme.headline1!.color,
        child: ExpansionTile(
      leading: Padding(padding: EdgeInsets.all(5), child: statusIcon),
      trailing: Icon(
          _tileExpanded
              ? Icons.keyboard_arrow_up_sharp
              : Icons.keyboard_arrow_down_sharp,
          size: 30,
          color: Theme.of(context).primaryTextTheme.caption!.color),
      onExpansionChanged: (bool expanded) {
        setState(() => _tileExpanded = expanded);
      },
      title: Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: Text(name,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).primaryTextTheme.caption!.color)),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 7.0,bottom: 7.0),
        child: Text(
            '$masterNodeKeyShort\n${S.of(context).uptime_proof}: ${lastUptimeProof.millisecondsSinceEpoch == 0 ? '-' : S.of(context).minutes_ago(DateTime.now().difference(lastUptimeProof).inMinutes)}$earnedDowntimeBlocksDisplay\n${S.of(context).contributors}: ${contribution.contributors.length}$remainingContribution',
            style: TextStyle(
                fontSize: 15,
                color: BeldexPalette.progressCenterText)),
      ),
      children: [
        Row(children: [
          Expanded(
            flex: 1,
            child: Container(
              width: (MediaQuery.of(context).size.width - 1) * 0.25,
              height: 70,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(S.of(context).last_reward,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16,color: BeldexPalette.progressCenterText))),
                    Expanded(
                        flex: 1,
                        child: Center(
                          child: Text('$lastRewardBlockHeight',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16)),
                        ))
                  ]),
            ),
          ),
          Center(child: Container(width: 1,height: 60,color: Colors.grey,margin: EdgeInsets.only(bottom: 30,top: 20),)),
          Expanded(
            flex: 1,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: 70,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(S.of(context).storage_server,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16,color: BeldexPalette.progressCenterText))),
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: Icon(
                                isStorageServerReachable
                                    ? Icons.check_circle_sharp
                                    : Icons.error_sharp,
                                size: 22),
                          ))
                    ])),
          ),
          Center(child: Container(width: 1,height: 60,color: Colors.grey,margin: EdgeInsets.only(bottom: 30,top: 20),)),
          Expanded(
            flex: 1,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: 70,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(S.of(context).lokinet_router,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16,color: BeldexPalette.progressCenterText))),
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: Icon(
                                isLokinetRouterReachable
                                    ? Icons.check_circle_sharp
                                    : Icons.error_sharp,
                                size: 22),
                          ))
                    ])),
          ),
          Center(child: Container(width: 1,height: 60,color: Colors.grey,margin: EdgeInsets.only(bottom: 30,top: 20),)),
          Expanded(
            flex: 1,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: 70,
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pushNamed(
                      BeldexRoutes.detailsMasterNode,
                      arguments: [masterNodeKey, name]),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text('${S.of(context).more}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,color: BeldexPalette.progressCenterText))),
                        Expanded(
                            flex: 1,
                            child: Center(
                              child: SvgPicture.asset('assets/images/more.svg',color:Theme.of(context).primaryTextTheme.headline5!.color,width: 25,height: 25,),
                            ))
                      ]),
                )),
          )
        ])
      ],
    ));
  }
}
