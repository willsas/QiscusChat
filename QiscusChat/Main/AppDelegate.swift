//
//  AppDelegate.swift
//  QiscusChat
//
//  Created by Willa on 22/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit
import QiscusCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let appID = "sdksample"
    private let dependencies = DependecyContainer(networkService: URLSessionNetworkingService())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        QiscusCore.setup(AppID: appID)
        dependencies.requestDevicePermission()
        setupFirstScreen()
        
        return true
    }
    
    
    
    private func setupFirstScreen(){
        let initialViewController: UIViewController = dependencies.makeSignInViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.switchRootViewController(initialViewController)
        window?.makeKeyAndVisible()
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate{
    
    
    // Fired when notification is about to appear in foreground (not tapped)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // handle notif
    }
    
    // Fired when user user tapped on notification badge (both foreground and background) but not being suspend
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // hanle notif
    }
    
    
}

