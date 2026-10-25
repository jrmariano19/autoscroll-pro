package com.example.autoscroll

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.autoscroll/accessibility"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val delay = call.argument<Int>("delay") ?: 8000
                    if (AutoScrollService.instance != null) {
                        AutoScrollService.instance?.startScrolling(delay.toLong())
                        result.success(true)
                    } else {
                        result.error("SERVICE_NOT_RUNNING", "Serviço de acessibilidade não está ativo nas definições do Android.", null)
                    }
                }
                "stopService" -> {
                    AutoScrollService.instance?.stopScrolling()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
