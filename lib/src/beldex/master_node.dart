import 'package:hive/hive.dart';
import 'package:master_node_monitor/src/beldex/master_node_status.dart';

part 'master_node.g.dart';

@HiveType(typeId: 1)
class MasterNode extends HiveObject {
  MasterNode({required this.name, required this.publicKey});

  MasterNode.fromMap(Map map)
      : name = (map['name'] ?? '') as String,
        publicKey = (map['publicKey'] ?? '') as String;

  static const boxName = 'MasterNodes';

  @HiveField(0)
  String name;

  @HiveField(1)
  String publicKey;

  @HiveField(2)
  String? operatorAddress;

  @HiveField(3)
  int registrationHeight = 0;

  @HiveField(4)
  int registrationHfVersion = 0;

  @HiveField(5)
  String? nodeVersion;

  @HiveField(6)
  String? ipAddress;

  @HiveField(7)
  String? storageServerVersion;

  @HiveField(8)
  String? lokinetVersion;

  MasterNodeInfo get nodeInfo => MasterNodeInfo(
      operatorAddress,
      registrationHeight,
      registrationHfVersion,
      publicKey,
      ipAddress,
      nodeVersion,
      storageServerVersion,
      lokinetVersion);

  set nodeInfo(MasterNodeInfo value) {
    operatorAddress = value.operatorAddress;
    registrationHeight = value.registrationHeight;
    registrationHfVersion = value.registrationHfVersion;
    nodeVersion = value.nodeVersion;
    storageServerVersion = value.storageServerVersion;
    lokinetVersion = value.lokinetVersion;
    ipAddress = value.ipAddress;
  }
}
