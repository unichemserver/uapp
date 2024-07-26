package com.uci.uapp

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.sr.SrPrinter

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.uci.uapp/printer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "printText") {
                val text = call.argument<String>("text")
                if (text != null) {
                    printText(text)
                    result.success("Printed successfully")
                } else {
                    result.error("ERROR", "Text is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun printText(text: String) {
        val srPrinter = SrPrinter.getInstance(applicationContext)
        srPrinter.printText(text)
    }
}
