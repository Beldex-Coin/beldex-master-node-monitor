import 'dart:convert';
import 'dart:ffi';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

@HiveType(typeId: 1)
class CheckMasterNode extends HiveObject {
  CheckMasterNode(this.uri,this.publicKey);

  CheckMasterNode.fromMap(Map map) : uri = (map['uri'] ?? '') as String,publicKey = (map['publicKey'] ?? '') as String;

  static const boxName = 'CheckMasterNodes';

  @HiveField(0)
  String uri;

  @HiveField(1)
  String publicKey;

  Future<bool> isOnline() async {
    try {
      final resBody = await sendRPCRequest('get_master_nodes',{'master_node_pubkeys':[publicKey]});
      if(resBody['result']['master_node_states']!=null){
        return true;
      }else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> sendRPCRequest(String method, Map<String, dynamic> params) async {
    Map<String, dynamic> resultBody;

    final requestBody = params != null
        ? {'jsonrpc': '2.0', 'id': '0', 'method': method, 'params': params}
        : {'jsonrpc': '2.0', 'id': '0', 'method': method};

    final url = Uri.http(uri, '/json_rpc');
    final headers = {'Content-type': 'application/json'};
    final body = json.encode(requestBody);
    final response = await http.post(url, headers: headers, body: body);
    final newBody = response.body.replaceAllMapped(
        RegExp(r'("swarm_id":)(\d+)'),
            (match) => '${match.group(1)}"${match.group(2)}"');

    resultBody = json.decode(newBody) as Map<String, dynamic>;
    return resultBody;
  }
}