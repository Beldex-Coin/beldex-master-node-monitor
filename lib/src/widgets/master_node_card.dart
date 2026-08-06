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
      this.isBelnetRouterReachable,
      this.lastRewardBlockHeight,
      this.earnedDowntimeBlocks,
      this.lastUptimeProof,
      this.contribution,
      this.isDarkTheme);

  final String name;
  final String masterNodeKey;
  final bool isUnlocking;
  final bool active;
  final bool isStorageServerReachable;
  final bool isBelnetRouterReachable;
  final int lastRewardBlockHeight;
  final int earnedDowntimeBlocks;
  final DateTime lastUptimeProof;
  final Contribution contribution;

  final localeName = Platform.localeName; // Hack to fix Local 'built' has not been initialized
  final bool isDarkTheme;

  @override
  State<StatefulWidget> createState() => _MasterNodeCardState();
}

class _MasterNodeCardState extends State<MasterNodeCard> {
  //static const int DECOMMISSION_MAX_CREDIT = 1440;

  var _tileExpanded = false;

  @override
  Widget build(BuildContext context) {
    final masterNodeKey = widget.masterNodeKey;
    final name = widget.name;
    final isUnlocking = widget.isUnlocking;
    final active = widget.active;
    //final earnedDowntimeBlocks = widget.earnedDowntimeBlocks;
    final lastUptimeProof = widget.lastUptimeProof;
    final lastRewardBlockHeight = widget.lastRewardBlockHeight;
    final isStorageServerReachable = widget.isStorageServerReachable;
    final isBelnetRouterReachable = widget.isBelnetRouterReachable;
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
    final isDarkTheme = widget.isDarkTheme;

    return Card(
      color: active ? isDarkTheme ?  PaletteDark.activeListItemBackground : Palette.activeListItemBackground : isDarkTheme ? PaletteDark.deactivateListItemBackground : Palette.deactivateListItemBackground,
        child: ExpansionTile(
      leading: Padding(padding: EdgeInsets.all(5), child: statusIcon),
      trailing: Icon(
          _tileExpanded
              ? Icons.keyboard_arrow_up_sharp
              : Icons.keyboard_arrow_down_sharp,
          size: 30,
          color: Theme.of(context).primaryTextTheme.bodySmall!.color),
      onExpansionChanged: (bool expanded) {
        setState(() => _tileExpanded = expanded);
      },
      title: Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: Text(name,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).primaryTextTheme.bodySmall!.color)),
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
        Row(
          children: [
            buildColumnWidget(
              context,
              title: S.of(context).last_reward,
              child: Flexible(
                child: Text(
                  '$lastRewardBlockHeight',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            buildVerticalDivider(),
            buildColumnWidget(
              context,
              title: S.of(context).storage_server,
              child: Icon(
                isStorageServerReachable
                    ? Icons.check_circle_sharp
                    : Icons.error_sharp,
                size: 20,
              ),
            ),
            buildVerticalDivider(),
            buildColumnWidget(
              context,
              title: S.of(context).belnet_router,
              child: Icon(
                isBelnetRouterReachable
                    ? Icons.check_circle_sharp
                    : Icons.error_sharp,
                size: 20,
              ),
            ),
            buildVerticalDivider(),
            buildColumnWidget(
              context,
              title: S.of(context).more,
              child: Icon(
                Icons.more,
                size: 20,
              ),
              onTap: () => Navigator.of(context).pushNamed(
                BeldexRoutes.detailsMasterNode,
                arguments: [masterNodeKey, name],
              ),
            ),
          ],
        )
      ],
    ));
  }

  Widget buildColumnWidget(BuildContext context,
      {required String title,
        required Widget child,
        VoidCallback? onTap}) {
    Widget column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: BeldexPalette.progressCenterText,
            ),
          ),
        ),
        Flexible(child: child),
        SizedBox(height: 10,),
      ],
    );

    return Expanded(
      flex: 1,
      child: onTap != null
          ? MaterialButton(padding: EdgeInsets.zero, onPressed: onTap, child: column)
          : Center(child: column),
    );
  }

  Widget buildVerticalDivider() {
    return Container(
      width: 1,
      height: 70,
      color: Colors.grey,
    );
  }
}
