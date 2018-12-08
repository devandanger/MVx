//
//  AppDelegate.swift
//  MVx
//
//  Created by Evan Anger on 12/2/18.
//  Copyright © 2018 Mighty Strong Software. All rights reserved.
//

import UIKit
import Harvey

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Harvey.add(dataSource: StubDataSource())
        Harvey.startStubbing()
        
        return true
    }
}

