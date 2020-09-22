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
    private lazy var userDefault = dependencies.makeUserDefault()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        QiscusCore.enableDebugMode(value: true)
        QiscusCore.setup(AppID: appID)
        
        dependencies.requestDevicePermission()
        setupFirstScreen()
        
        return true
    }
    
    // did we actually need a remote notification? because it needs APN certicfication, but there you go
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var tokenString: String = ""
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        print("token = \(tokenString)")
        
        handleNewToken(tokenString)
     
        
        
    }
    
    
    
    private func setupFirstScreen(){
        
        let initialViewController: UIViewController = UINavigationController(rootViewController: isLoggedIn() ? dependencies.makeChatListViewController() : dependencies.makeSignInViewController())
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.switchRootViewController(initialViewController)
        window?.makeKeyAndVisible()
    }
    
    
    private func isLoggedIn() -> Bool{
        QiscusCore.hasSetupUser()
    }
    
    private func handleNewToken(_ token: String){
        // new token save to persistence
        userDefault.saveData(token, forKey: .deviceToken)
        
        //re register
        if isLoggedIn(){
            dependencies.requestToRegisterNewDeviceToken(withToken: token) { (response) in
                switch response{
                case .success(_):
                    print("success register device token =\(token)")
                case .failure(let err):
                    print("Failed to register device token = \(err.localizedDescription)")
                }
            }
        }
    }
    
}


extension AppDelegate: QiscusConnectionDelegate{
    
    func connectionState(change state: QiscusConnectionState) {
        
    }
    
    func onConnected() {
        
    }
    
    func onReconnecting() {
        
    }
    
    func onDisconnected(withError err: QError?) {
        
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
