package com.example.autoscroll

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.GestureDescription
import android.graphics.Path
import android.os.Handler
import android.os.Looper
import java.util.Random

class AutoScrollService : AccessibilityService() {

    private val handler = Handler(Looper.getMainLooper())
    private val random = Random()
    var isRunning = false

    companion object {
        var instance: AutoScrollService? = null
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
    }

    fun startScrolling(baseDelay: Long) {
        isRunning = true
        performHumanSwipe(baseDelay)
    }

    fun stopScrolling() {
        isRunning = false
        handler.removeCallbacksAndMessages(null)
    }

    private fun performHumanSwipe(baseDelay: Long) {
        if (!isRunning) return

        val path = Path()
        val startX = (450 + random.nextInt(100)).toFloat()
        val startY = (1700 + random.nextInt(200)).toFloat()
        val endX = (430 + random.nextInt(100)).toFloat()
        val endY = (400 + random.nextInt(150)).toFloat()

        path.moveTo(startX, startY)
        path.lineTo(endX, endY)

        val gestureBuilder = GestureDescription.Builder()
        val duration = (250 + random.nextInt(200)).toLong()
        
        gestureBuilder.addStroke(GestureDescription.StrokeDescription(path, 0, duration))

        dispatchGesture(gestureBuilder.build(), object : GestureResultCallback() {
            override fun onCompleted() {
                super.onCompleted()
                if (!isRunning) return

                val jitterDelay = baseDelay + (random.nextInt(4000) - 2000)
                val finalWait = maxOf(3000L, jitterDelay)

                handler.postDelayed({
                    performHumanSwipe(baseDelay)
                }, finalWait)
            }

            override fun onCancelled() {
                super.onCancelled()
            }
        }, null)
    }

    override fun onAccessibilityEvent(event: android.view.accessibility.AccessibilityEvent?) {}

    override fun onInterrupt() {
        isRunning = false
    }

    override onDestroy() {
        super.onDestroy()
        instance = null
    }
}
