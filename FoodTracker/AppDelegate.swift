//
//  AppDelegate.swift
//  FoodTracker
//
//  Created by Jafar Yormahmadzoda on 23/01/2017.
//  Copyright © 2017 Jafar Yormahmadzoda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // you should use this class provided by Xcode to initialize your app and respond to app-level events
    var window: UIWindow? // stores a reference to the app’s window
    // This window represents the root of your app’s view hierarchy. It is where all of your app content is drawn.

    /*
     These methods let the application object communicate with the app delegate.
     During an app state transition—for example, app launch, transitioning to the background,
     and app termination—the application object calls the corresponding delegate method,
     giving your app an opportunity to respond.
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    /*
     Each of the delegate methods has a default behavior. If you leave the template implementation empty
     or delete it from your AppDelegate class, you get the default behavior whenever that method is called.
     */

}

/*
 The AppDelegate.swift source file has two primary functions:
 It defines your AppDelegate class. The app delegate creates the window where your app’s content is drawn and provides a place to respond to state transitions within the app.
 It creates the entry point to your app and a run loop that delivers input events to your app. This work is done by the UIApplicationMain attribute (@UIApplicationMain), which appears toward the top of the file.
 Using the UIApplicationMain attribute is equivalent to calling the UIApplicationMain function and passing your AppDelegate class’s name as the name of the delegate class. In response, the system creates an application object. The application object is responsible for managing the life cycle of the app. The system also creates an instance of your AppDelegate class, and assigns it to the application object. Finally, the system launches your app.
 */
