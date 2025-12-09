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
      this.belnetRouter,
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
  final PosVotesParticipation posBlocks;
  final int stakingRequirement;
  final int stateHeight;
  final StorageServerStatus storageServer;
  final BelnetRouterStatus belnetRouter;
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
    final belnetRouterStatus = BelnetRouterStatus.fromMap(map);
    final lastReward = LastReward.fromMap(map);
    final masterNodeInfo = MasterNodeInfo.fromMap(map);
    final checkpointBlocks = CheckpointParticipation.fromMap(map);
    final posBlocks = PosVotesParticipation.fromMap(map);

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
        belnetRouterStatus,
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
      this.belnetVersion);

  MasterNodeInfo.fromMap(Map map)
      : operatorAddress = map['operator_address'] as String,
        registrationHeight = (map['registration_height'] ?? 0) as int,
        registrationHfVersion = (map['registration_hf_version'] ?? 0) as int,
        publicKey = map['master_node_pubkey'] as String,
        ipAddress = map['public_ip'] as String,
        nodeVersion = (map['master_node_version'] as List).join('.'),
        storageServerVersion =
            (map['storage_server_version'] as List).join('.'),
        belnetVersion = (map['belnet_version'] as List).join('.');

  final String? operatorAddress;
  final int registrationHeight;
  final int registrationHfVersion;
  final String publicKey;
  final String? ipAddress;
  final String? nodeVersion;
  final String? storageServerVersion;
  final String? belnetVersion;

  bool equals(MasterNodeInfo masterNodeInfo) {
    return masterNodeInfo.operatorAddress == operatorAddress &&
        masterNodeInfo.registrationHeight == registrationHeight &&
        masterNodeInfo.registrationHfVersion == registrationHfVersion &&
        masterNodeInfo.publicKey == publicKey &&
        masterNodeInfo.ipAddress == ipAddress &&
        masterNodeInfo.nodeVersion == nodeVersion &&
        masterNodeInfo.storageServerVersion == storageServerVersion &&
        masterNodeInfo.belnetVersion == belnetVersion;
  }
}

class StorageServerStatus {
  StorageServerStatus(this.isReachable, this.timestamp);

  StorageServerStatus.fromMap(Map map)
      : isReachable = (map['storage_server_reachable'] as bool?) ?? false,
        timestamp = (map['storage_server_reachable_timestamp'] as int?) ?? 0;

  final bool isReachable;
  final int timestamp;
}

class BelnetRouterStatus {
  BelnetRouterStatus(this.isReachable, this.timestamp);

  BelnetRouterStatus.fromMap(Map map)
      : isReachable = (map['belnet_reachable'] as bool?) ?? false,
        timestamp = (map['belnet_router_reachable_timestamp'] as int?) ?? 0;

  final bool isReachable;
  final int timestamp;
}

class Checkpoint {
  Checkpoint(this.height, this.voted);

  // This fromMap is no longer used with the new JSON format,
  // but we can keep it in case of future map-based data.
  Checkpoint.fromMap(Map map)
      : height = map['height'] as int,
        voted = map['voted'] as bool;

  final int height;
  final bool voted;
}

class CheckpointParticipation {
  CheckpointParticipation(this.checkpoints);

  CheckpointParticipation.fromMap(Map map)
      : checkpoints = _parseCheckpoints(map);

  final List<Checkpoint> checkpoints;

  // Helper to parse the new structure:
  // "checkpoint_votes": { "missed": [...], "voted": [...] }
  static List<Checkpoint> _parseCheckpoints(Map map) {
    final List<Checkpoint> result = [];

    if (!map.containsKey('checkpoint_votes')) {
      return result;
    }

    final votes = map['checkpoint_votes'] as Map;

    // missed: [height, height, ...]  -> voted = false
    final missed = (votes['missed'] as List?) ?? [];
    for (final m in missed) {
      if (m != null) {
        result.add(Checkpoint(m as int, false));
      }
    }

    // voted: [height, height, ...]  -> voted = true
    final voted = (votes['voted'] as List?) ?? [];
    for (final v in voted) {
      if (v != null) {
        result.add(Checkpoint(v as int, true));
      }
    }

    // sort by height ascending
    result.sort((a, b) => a.height.compareTo(b.height));

    return result;
  }
}

class PosVote {
  PosVote(this.height, this.voted);

  PosVote.fromMap(Map map)
      : height = map['height'] as int,
        voted = map['voted'] as bool;

  final int height;
  final bool voted;
}

class PosVotesParticipation {
  PosVotesParticipation(this.votes);

  PosVotesParticipation.fromMap(Map map)
      : votes = _parsePosVotes(map);

  final List<PosVote> votes;

  static List<PosVote> _parsePosVotes(Map map) {
    final List<PosVote> result = [];

    if (!map.containsKey('POS_votes')) {
      return result;
    }

    final votesMap = map['POS_votes'] as Map;

    // missed -> [[height, _]]  -> voted = false
    final missed = votesMap['missed'] as List? ?? [];
    for (final entry in missed) {
      if (entry is List && entry.isNotEmpty) {
        final height = entry[0] as int;
        result.add(PosVote(height, false));
      }
    }

    // voted -> [[height, _]]  -> voted = true
    final voted = votesMap['voted'] as List? ?? [];
    for (final entry in voted) {
      if (entry is List && entry.isNotEmpty) {
        final height = entry[0] as int;
        result.add(PosVote(height, true));
      }
    }

    // sort by height ascending
    result.sort((a, b) => a.height.compareTo(b.height));

    return result;
  }
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
