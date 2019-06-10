//
//  AppDelegate.swift
//  SoundAssistant
//
//  Created by Stephen Cao on 1/6/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupBasicSettings()
        return true
    }
}
private extension AppDelegate{
    func setupBasicSettings(){
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
    }
}
