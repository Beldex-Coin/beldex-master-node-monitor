class MasterNodeStatus {
  MasterNodeStatus(
      this.active,
      this.checkpointBlocks,
      this.contribution,
      this.decommissionCount,
      this.earnedDowntimeBlocks,
      this.funded,
      this.lastReward,
      this._lastUptimeProof,
      this.posBlocks,
      this.requestedUnlockHeight,
      this.nodeInfo,
      this.stateHeight,
      this.storageServer,
      this.lokinetRouter,
      this.swarmId,
      {this.stakingRequirement = 10000000000000});

  final bool active;
  final CheckpointParticipation checkpointBlocks;
  final Contribution contribution;
  final MasterNodeInfo nodeInfo;
  final int decommissionCount;
  final int earnedDowntimeBlocks;
  final bool funded;
  final LastReward lastReward;
  final PosParticipation posBlocks;
  final int stakingRequirement;
  final int stateHeight;
  final StorageServerStatus storageServer;
  final LokinetRouterStatus lokinetRouter;
  final int requestedUnlockHeight;
  final String swarmId;
  final int _lastUptimeProof;

  bool get isUnlocking => requestedUnlockHeight != 0;

  DateTime get lastUptimeProof =>
      DateTime.fromMillisecondsSinceEpoch(_lastUptimeProof * 1000);

  static MasterNodeStatus load(Map map) {
    final keys = [
      'decommission_count',
      'earned_downtime_blocks',
      'last_reward_block_height',
      'last_reward_transaction_index',
      'last_uptime_proof',
      'registration_height',
      'registration_hf_version',
      'requested_unlock_height',
      'state_height',
      'storage_server_reachable_timestamp',
      'belnet_reachable_timestamp',
      'total_contributed',
      'total_reserved'
    ];

    for (final key in keys) {
      if(map[key] != null) {
        try {
          map[key] as int?;
        } catch (e) {
          map[key] = (map[key] as double?)?.truncate();
        }
      }
    }

    final contribution = Contribution.fromMap(map);
    final storageServerStatus = StorageServerStatus.fromMap(map);
    final lokinetRouterStatus = LokinetRouterStatus.fromMap(map);
    final lastReward = LastReward.fromMap(map);
    final masterNodeInfo = MasterNodeInfo.fromMap(map);
    final checkpointBlocks = CheckpointParticipation.fromMap(map);
    final posBlocks = PosParticipation.fromMap(map);

    return MasterNodeStatus(
        map['active'] as bool,
        checkpointBlocks,
        contribution,
        map['decommission_count'] as int,
        map['earned_downtime_blocks'] as int,
        map['funded'] as bool,
        lastReward,
        map['last_uptime_proof'] as int,
        posBlocks,
        map['requested_unlock_height'] as int,
        masterNodeInfo,
        map['state_height'] as int,
        storageServerStatus,
        lokinetRouterStatus,
        map['swarm_id'] as String);
  }
}

class MasterNodeInfo {
  MasterNodeInfo(
      this.operatorAddress,
      this.registrationHeight,
      this.registrationHfVersion,
      this.publicKey,
      this.ipAddress,
      this.nodeVersion,
      this.storageServerVersion,
      this.lokinetVersion);

  MasterNodeInfo.fromMap(Map map)
      : operatorAddress = map['operator_address'] as String,
        registrationHeight = (map['registration_height'] ?? 0) as int,
        registrationHfVersion = (map['registration_hf_version'] ?? 0) as int,
        publicKey = map['master_node_pubkey'] as String,
        ipAddress = map['public_ip'] as String,
        nodeVersion = (map['master_node_version'] as List).join('.'),
        storageServerVersion =
            (map['storage_server_version'] as List).join('.'),
        lokinetVersion = (map['belnet_version'] as List).join('.');

  final String? operatorAddress;
  final int registrationHeight;
  final int registrationHfVersion;
  final String publicKey;
  final String? ipAddress;
  final String? nodeVersion;
  final String? storageServerVersion;
  final String? lokinetVersion;

  bool equals(MasterNodeInfo masterNodeInfo) {
    return masterNodeInfo.operatorAddress == operatorAddress &&
        masterNodeInfo.registrationHeight == registrationHeight &&
        masterNodeInfo.registrationHfVersion == registrationHfVersion &&
        masterNodeInfo.publicKey == publicKey &&
        masterNodeInfo.ipAddress == ipAddress &&
        masterNodeInfo.nodeVersion == nodeVersion &&
        masterNodeInfo.storageServerVersion == storageServerVersion &&
        masterNodeInfo.lokinetVersion == lokinetVersion;
  }
}

class StorageServerStatus {
  StorageServerStatus(this.isReachable, this.timestamp);

  StorageServerStatus.fromMap(Map map)
      : isReachable = map['storage_server_reachable'] as bool,
        timestamp = (map['storage_server_reachable_timestamp'] ?? 0) as int;

  final bool isReachable;
  final int timestamp;
}

class LokinetRouterStatus {
  LokinetRouterStatus(this.isReachable, this.timestamp);

  LokinetRouterStatus.fromMap(Map map)
      : isReachable = map['belnet_reachable'] as bool,
        timestamp = (map['belnet_router_reachable_timestamp'] ?? 0) as int;

  final bool isReachable;
  final int timestamp;
}

class Checkpoint {
  Checkpoint(this.height, this.voted);

  Checkpoint.fromMap(Map map)
      : height = map['height'] as int,
        voted = map['voted'] as bool;

  final int height;
  final bool voted;
}

class CheckpointParticipation {
  CheckpointParticipation(this.checkpoints);

  CheckpointParticipation.fromMap(Map map)
      : checkpoints = (map.containsKey('checkpoint_participation')
            ? (map['checkpoint_participation'] as List)
                .map((e) => Checkpoint.fromMap(e))
                .toList()
            : []);

  final List<Checkpoint> checkpoints;
}

class Pos {
  Pos(this.height, this.voted);

  Pos.fromMap(Map map)
      : height = map['height'] as int,
        voted = map['voted'] as bool;

  final int height;
  final bool voted;
}

class PosParticipation {
  PosParticipation(this.pos);

  PosParticipation.fromMap(Map map)
      : pos = (map.containsKey('pos_participation')
            ? (map['pos_participation'] as List)
                .map((e) => Pos.fromMap(e))
                .toList()
            : []);

  final List<Pos> pos;
}

class Contributor {
  Contributor(this.address, this.amount, this.reserved);

  Contributor.fromMap(Map map)
      : address = (map['address'] ?? '') as String,
        amount = (map['amount'] ?? 0) as int,
        reserved = (map['reserved'] ?? 0) as int;

  final String address;
  final int amount;
  final int reserved;
}

class Contribution {
  Contribution(this.contributors, this.totalContributed, this.totalReserved);

  Contribution.fromMap(Map map)
      : totalContributed = (map['total_contributed'] ?? 0) as int,
        totalReserved = (map['total_reserved'] ?? 0) as int,
        contributors = (map['contributors'] as List)
            .map((e) => Contributor.fromMap(e))
            .toList();

  final int totalContributed;
  final int totalReserved;
  final List<Contributor> contributors;
}

class LastReward {
  LastReward(this.blockHeight, this.transactionIndex);

  LastReward.fromMap(Map map)
      : blockHeight = (map['last_reward_block_height'] ?? 0) as int,
        transactionIndex = (map['last_reward_transaction_index'] ?? 0) as int;

  final int blockHeight;
  final int transactionIndex;
}
