import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:master_node_monitor/src/beldex/daemon.dart';
import 'package:yaml/yaml.dart';

Future<List<Daemon>> loadDefaultNodes() async {
  final nodesRaw = await rootBundle.loadString('assets/daemon_list.yml');
  final nodes = loadYaml(nodesRaw) as YamlList;

  final n = <Daemon>[];
  nodes.forEach((dynamic raw) {
    if (raw is Map) {
      n.add(Daemon.fromMap(raw));
    }
  });
  return n;
}

Future resetToDefault(Box<Daemon> nodeSource) async {
  final nodes = await loadDefaultNodes();
  final entities = <int, Daemon>{};

  await nodeSource.clear();

  for (var i = 0; i < nodes.length; i++) {
    entities[i] = nodes[i];
  }

  await nodeSource.putAll(entities);
}
