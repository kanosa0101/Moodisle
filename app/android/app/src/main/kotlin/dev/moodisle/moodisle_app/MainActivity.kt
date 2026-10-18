package dev.moodisle.moodisle_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.PowerManager
import android.os.SystemClock
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var focusChannel: MethodChannel? = null
    private var screenOffReceiver: BroadcastReceiver? = null
    private var screenLockListenerReady = false
    private var pendingScreenLock = false
    private var pendingScreenUnlock = false
    private var activityResumed = false
    private var lastPauseAtMs: Long? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "moodisle/focus_lifecycle"
        )
        focusChannel = channel
        channel.setMethodCallHandler { call, result ->
            if (call.method == "listen") {
                screenLockListenerReady = true
                when {
                    pendingScreenUnlock -> channel.invokeMethod("screenUnlocked", null)
                    pendingScreenLock -> channel.invokeMethod("screenLocked", null)
                }
                pendingScreenLock = false
                pendingScreenUnlock = false
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        if (screenOffReceiver == null) {
            val receiver = object : BroadcastReceiver() {
                override fun onReceive(context: Context, intent: Intent) {
                    if (intent.action == Intent.ACTION_USER_PRESENT) {
                        if (!activityResumed) emitScreenUnlocked()
                        return
                    }
                    if (intent.action != Intent.ACTION_SCREEN_OFF) return
                    val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
                    val pausedAt = lastPauseAtMs
                    val activityRecentlyPaused = pausedAt != null &&
                        SystemClock.elapsedRealtime() - pausedAt <= SCREEN_LOCK_TRANSITION_WINDOW_MS
                    if (!powerManager.isInteractive && (activityResumed || activityRecentlyPaused)) {
                        emitScreenLocked()
                    }
                }
            }
            val filter = IntentFilter().apply {
                addAction(Intent.ACTION_SCREEN_OFF)
                addAction(Intent.ACTION_USER_PRESENT)
            }
            applicationContext.registerReceiver(
                receiver,
                filter
            )
            screenOffReceiver = receiver
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        screenOffReceiver?.let { receiver ->
            applicationContext.unregisterReceiver(receiver)
            screenOffReceiver = null
        }
        focusChannel?.setMethodCallHandler(null)
        focusChannel = null
        screenLockListenerReady = false
        pendingScreenLock = false
        pendingScreenUnlock = false
        super.cleanUpFlutterEngine(flutterEngine)
    }

    private fun emitScreenLocked() {
        if (screenLockListenerReady) {
            focusChannel?.invokeMethod("screenLocked", null)
        } else {
            pendingScreenLock = true
            pendingScreenUnlock = false
        }
    }

    private fun emitScreenUnlocked() {
        if (screenLockListenerReady) {
            focusChannel?.invokeMethod("screenUnlocked", null)
        } else {
            pendingScreenLock = false
            pendingScreenUnlock = true
        }
    }

    override fun onResume() {
        super.onResume()
        activityResumed = true
        lastPauseAtMs = null
    }

    override fun onPause() {
        activityResumed = false
        lastPauseAtMs = SystemClock.elapsedRealtime()
        super.onPause()
    }

    private companion object {
        const val SCREEN_LOCK_TRANSITION_WINDOW_MS = 1_500L
    }
}
