//
//  AppDelegate.swift
//  itss_murasaki_flashcard
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        creatMainTabBarWindow()
        FirebaseApp.configure()
        return true
    }
    
    func creatMainTabBarWindow() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainTabBarController = storyboard.instantiateViewController(
            withIdentifier: "MainTabBarController") as? MainTabBarController {
            window?.rootViewController = mainTabBarController
            window?.makeKeyAndVisible()
        }
    }
    
    private func requestPermissionPushNoti() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (_, _) in
        }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}

