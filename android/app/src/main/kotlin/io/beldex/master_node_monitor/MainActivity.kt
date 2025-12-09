package io.beldex.master_node_monitor

import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
class MainActivity: FlutterFragmentActivity() {

    private val channel = "io.beldex.master_node_monitor/beldex_master_node_monitor_channel";
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor, channel)
            .setMethodCallHandler{
                    call, result ->
                if(call.method == "email"){
                    val args = call.arguments as Map<String, Any>
                    val emailId = args["email_id"] as String;
                    val intent = Intent(Intent.ACTION_SENDTO)
                    intent.data = Uri.parse("mailto:")
                    intent.putExtra(Intent.EXTRA_EMAIL, arrayOf(emailId))
                    intent.putExtra(Intent.EXTRA_SUBJECT, "")
                    startActivity(intent)
                    result.success(hashMapOf("test" to ""))
                }else{
                    result.notImplemented()
                }
            }
    }
}
