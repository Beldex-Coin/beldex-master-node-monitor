// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(networkSize, currentHeight) =>
      "${networkSize} nodes at height ${currentHeight}";

  static String m1(title) => "Copied ${title} to clipboard";

  static String m2(name) => "No route defined for ${name}";

  static String m7(unlockBlock) => "in ${unlockBlock} blocks";

  static String m3(nextReward) => "~ in ${nextReward} blocks";

  static String m4(total) => "All ${total} nodes operational";

  static String m5(healthyNodes, total) =>
      "${healthyNodes} out of ${total} nodes\nare operational";

  static String m6(minutes) => "${minutes} minutes ago";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add_daemon": MessageLookupByLibrary.simpleMessage("Add Daemon"),
        "add_master_node":
            MessageLookupByLibrary.simpleMessage("Add a Master Node"),
        "add_node_to_get_started": MessageLookupByLibrary.simpleMessage(
            "Add a Master Node below to get started."),
        "address": MessageLookupByLibrary.simpleMessage("Staker"),
        "all_master_nodes": m0,
        "amount": MessageLookupByLibrary.simpleMessage("Amount"),
        "awaiting_contributions":
            MessageLookupByLibrary.simpleMessage("Awaiting Contributions"),
        "blocks": MessageLookupByLibrary.simpleMessage("blocks"),
        "checkYourInternetConnection": MessageLookupByLibrary.simpleMessage(
            "Check your internet connection"),
        "checkpoints": MessageLookupByLibrary.simpleMessage("Checkpoints"),
        "contributors": MessageLookupByLibrary.simpleMessage("Contributors"),
        "copied_to_clipboard": m1,
        "daemon_address":
            MessageLookupByLibrary.simpleMessage("Daemon Address"),
        "daemon_port": MessageLookupByLibrary.simpleMessage("Daemon Port"),
        "dashboard_order_by_name": MessageLookupByLibrary.simpleMessage("Name"),
        "dashboard_order_by_next_reward":
            MessageLookupByLibrary.simpleMessage("Next Reward"),
        "delete_master_node":
            MessageLookupByLibrary.simpleMessage("Delete Master Node"),
        "earned_downtime_blocks":
            MessageLookupByLibrary.simpleMessage("Earned Downtime Blocks"),
        "enterAPublicKey":
            MessageLookupByLibrary.simpleMessage("Enter a public key"),
        "enterAValidPublicKey":
            MessageLookupByLibrary.simpleMessage("Enter a valid public key"),
        "error_name_taken": MessageLookupByLibrary.simpleMessage(
            "You already have a node with that name"),
        "error_public_key_too_long":
            MessageLookupByLibrary.simpleMessage("Public Key too long"),
        "error_public_key_too_short":
            MessageLookupByLibrary.simpleMessage("Public Key too short"),
        "error_router_no_route": m2,
        "error_text_daemon_address": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid iPv4 address or domain name"),
        "error_text_daemon_port": MessageLookupByLibrary.simpleMessage(
            "Daemon port can only contain numbers between 0 and 65535"),
        "error_you_are_already_monitoring":
            MessageLookupByLibrary.simpleMessage(
                "You are already monitoring that node"),
        "estimated_node_unlock": m7,
        "estimated_reward_block": m3,
        "health_all_nodes": m4,
        "health_no_nodes":
            MessageLookupByLibrary.simpleMessage("No nodes are operational!"),
        "health_out_of_nodes": m5,
        "help": MessageLookupByLibrary.simpleMessage("Help"),
        "hours": MessageLookupByLibrary.simpleMessage("hours"),
        "last_reward": MessageLookupByLibrary.simpleMessage("Last\nReward"),
        "last_reward_height":
            MessageLookupByLibrary.simpleMessage("Last Reward Height"),
        "last_uptime_proof":
            MessageLookupByLibrary.simpleMessage("Last Uptime Proof"),
        "lokinet_router":
            MessageLookupByLibrary.simpleMessage("Belnet\nRouter"),
        "master_node_operator":
            MessageLookupByLibrary.simpleMessage("Node Operator"),
        "master_node_version":
            MessageLookupByLibrary.simpleMessage("Node Version"),
        "minutes_ago": m6,
        "month_april": MessageLookupByLibrary.simpleMessage("April"),
        "month_august": MessageLookupByLibrary.simpleMessage("August"),
        "month_december": MessageLookupByLibrary.simpleMessage("December"),
        "month_february": MessageLookupByLibrary.simpleMessage("February"),
        "month_january": MessageLookupByLibrary.simpleMessage("January"),
        "month_july": MessageLookupByLibrary.simpleMessage("July"),
        "month_june": MessageLookupByLibrary.simpleMessage("June"),
        "month_march": MessageLookupByLibrary.simpleMessage("March"),
        "month_may": MessageLookupByLibrary.simpleMessage("May"),
        "month_november": MessageLookupByLibrary.simpleMessage("November"),
        "month_october": MessageLookupByLibrary.simpleMessage("October"),
        "month_september": MessageLookupByLibrary.simpleMessage("September"),
        "more": MessageLookupByLibrary.simpleMessage("More\nInfo"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "next_reward": MessageLookupByLibrary.simpleMessage("Next Reward:"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "pleaseEnterAName":
            MessageLookupByLibrary.simpleMessage("Please enter a name"),
        "pleaseEnterAValidDaemon":
            MessageLookupByLibrary.simpleMessage("Please enter a valid daemon"),
        "please_select": MessageLookupByLibrary.simpleMessage("Please select:"),
        "pos": MessageLookupByLibrary.simpleMessage("POS"),
        "public_ip": MessageLookupByLibrary.simpleMessage("IP Address"),
        "public_key": MessageLookupByLibrary.simpleMessage("Public Key"),
        "registration_height":
            MessageLookupByLibrary.simpleMessage("Registration Height"),
        "registration_hf_version": MessageLookupByLibrary.simpleMessage(
            "Registration Hardfork Version"),
        "save_master_node":
            MessageLookupByLibrary.simpleMessage("Save Master Node"),
        "settings_daemon": MessageLookupByLibrary.simpleMessage("Daemon"),
        "settings_dark_theme":
            MessageLookupByLibrary.simpleMessage("Dark Theme"),
        "settings_language": MessageLookupByLibrary.simpleMessage("Language"),
        "settings_light_theme":
            MessageLookupByLibrary.simpleMessage("Light Theme"),
        "settings_master_nodes":
            MessageLookupByLibrary.simpleMessage("Master Nodes"),
        "settings_order_by":
            MessageLookupByLibrary.simpleMessage("Order Nodes by"),
        "settings_title_app": MessageLookupByLibrary.simpleMessage("App"),
        "settings_title_general":
            MessageLookupByLibrary.simpleMessage("General"),
        "software_versions": MessageLookupByLibrary.simpleMessage(
            "Node / Storage Server / Belnet Version"),
        "state_height":
            MessageLookupByLibrary.simpleMessage("Last State Change Height"),
        "storage_server":
            MessageLookupByLibrary.simpleMessage("Storage\nServer"),
        "success_saved_node":
            MessageLookupByLibrary.simpleMessage("Node successfully saved"),
        "swarm_id": MessageLookupByLibrary.simpleMessage("Swarm ID"),
        "termsAndConditions":
            MessageLookupByLibrary.simpleMessage("Terms and Conditions"),
        "termsConditions":
            MessageLookupByLibrary.simpleMessage("Terms & Conditions"),
        "title_add_daemon": MessageLookupByLibrary.simpleMessage("Add Daemon"),
        "title_add_master_node":
            MessageLookupByLibrary.simpleMessage("Add Master Node"),
        "title_changelog": MessageLookupByLibrary.simpleMessage("Changelog"),
        "title_dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
        "title_edit_daemons":
            MessageLookupByLibrary.simpleMessage("Edit Daemons"),
        "title_edit_master_node":
            MessageLookupByLibrary.simpleMessage("Edit Master Node"),
        "title_edit_master_nodes":
            MessageLookupByLibrary.simpleMessage("Edit Master Nodes"),
        "title_faq": MessageLookupByLibrary.simpleMessage("FAQ"),
        "title_settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "unlocking_node":
            MessageLookupByLibrary.simpleMessage("Node is unlocking"),
        "uptime_proof": MessageLookupByLibrary.simpleMessage("Uptime proof"),
        "welcome": MessageLookupByLibrary.simpleMessage(
            "Welcome,\nBeldex Master Node Monitor"),
        "welcome_first_line": MessageLookupByLibrary.simpleMessage(
            "Here you can watch Master Nodes you run or contribute to."),
        "your_master_nodes":
            MessageLookupByLibrary.simpleMessage("Your Master Nodes")
      };
}
