//
//  AppDelegate.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/24.
//

import UIKit

@main
class AppDelegate: UIResponder ,UIApplicationDelegate {

    var sizeVertical: CGRect?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.sizeVertical = UIDevice.current.accessibilityFrame
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}

