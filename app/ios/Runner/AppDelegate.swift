import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var focusLifecycleChannel: FlutterMethodChannel?
  private var protectedDataObserver: NSObjectProtocol?
  private var protectedDataAvailableObserver: NSObjectProtocol?
  private var didEnterBackgroundObserver: NSObjectProtocol?
  private var didBecomeActiveObserver: NSObjectProtocol?
  private var focusListenerReady = false
  private var pendingScreenLock = false
  private var pendingScreenUnlock = false
  private var lastBackgroundAt: Date?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: "moodisle/focus_lifecycle",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    focusLifecycleChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "listen" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let self else {
        result(FlutterError(code: "unavailable", message: nil, details: nil))
        return
      }

      self.focusListenerReady = true
      if self.pendingScreenLock {
        self.focusLifecycleChannel?.invokeMethod("screenLocked", arguments: nil)
      }
      if self.pendingScreenUnlock {
        self.focusLifecycleChannel?.invokeMethod("screenUnlocked", arguments: nil)
      }
      self.pendingScreenLock = false
      self.pendingScreenUnlock = false
      result(nil)
    }

    if protectedDataObserver == nil {
      didEnterBackgroundObserver = NotificationCenter.default.addObserver(
        forName: UIApplication.didEnterBackgroundNotification,
        object: nil,
        queue: .main
      ) { [weak self] _ in
        self?.lastBackgroundAt = Date()
      }

      didBecomeActiveObserver = NotificationCenter.default.addObserver(
        forName: UIApplication.didBecomeActiveNotification,
        object: nil,
        queue: .main
      ) { [weak self] _ in
        self?.lastBackgroundAt = nil
        self?.pendingScreenLock = false
        self?.pendingScreenUnlock = false
      }

      protectedDataObserver = NotificationCenter.default.addObserver(
        forName: UIApplication.protectedDataWillBecomeUnavailableNotification,
        object: nil,
        queue: .main
      ) { [weak self] _ in
        guard let self else { return }
        let recentlyBackgrounded = self.lastBackgroundAt.map {
          let elapsed = Date().timeIntervalSince($0)
          return elapsed >= 0 && elapsed <= Self.screenLockTransitionWindow
        } ?? false
        guard UIApplication.shared.applicationState != .background || recentlyBackgrounded else {
          return
        }
        if self.focusListenerReady {
          self.focusLifecycleChannel?.invokeMethod("screenLocked", arguments: nil)
        } else {
          self.pendingScreenLock = true
          self.pendingScreenUnlock = false
        }
      }

      protectedDataAvailableObserver = NotificationCenter.default.addObserver(
        forName: UIApplication.protectedDataDidBecomeAvailableNotification,
        object: nil,
        queue: .main
      ) { [weak self] _ in
        guard let self else { return }
        guard UIApplication.shared.applicationState == .background else {
          self.pendingScreenLock = false
          self.pendingScreenUnlock = false
          return
        }
        if self.focusListenerReady {
          self.focusLifecycleChannel?.invokeMethod("screenUnlocked", arguments: nil)
        } else {
          self.pendingScreenLock = false
          self.pendingScreenUnlock = true
        }
      }
    }
  }

  deinit {
    if let protectedDataObserver {
      NotificationCenter.default.removeObserver(protectedDataObserver)
    }
    if let protectedDataAvailableObserver {
      NotificationCenter.default.removeObserver(protectedDataAvailableObserver)
    }
    if let didEnterBackgroundObserver {
      NotificationCenter.default.removeObserver(didEnterBackgroundObserver)
    }
    if let didBecomeActiveObserver {
      NotificationCenter.default.removeObserver(didBecomeActiveObserver)
    }
  }

  private static let screenLockTransitionWindow: TimeInterval = 2
}
