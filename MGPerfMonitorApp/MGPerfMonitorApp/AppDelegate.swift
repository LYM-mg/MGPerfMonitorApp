//
//  AppDelegate.swift
//  MGPerfMonitorApp
//
//  Created by 刘远明 on 2025/10/23.
//

import UIKit
import MGPerfMonitor

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 启动联合监控
        MGPerfMonitor.shared.start()

        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            // HUD
            MGPerfMonitor.shared.showHUD()
        }

        // Combine 订阅
        let cancellable = MGPerfMonitor.shared.combinedPublisher.sink { fps, lag in
            print("FPS: \(fps) | Lag: \(lag)")
        }

        // Logger 上报
        MGPerfLogger.shared.onUpload = { line in
            // 上传到服务器
            print("Log upload: \(line)")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

