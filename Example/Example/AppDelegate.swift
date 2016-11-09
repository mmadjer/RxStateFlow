//
//  AppDelegate.swift
//  Example
//
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import UIKit
import RxStateFlow
import RealmSwift

let store = Store<AppState>(middlewares: [LoggingMiddleware(), HistoryMiddleware(limit: .limit(1))])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // swiftlint:disable line_length
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Realm is used as the persistent layer in RxStateFlow.
        // You define your State as Realm Models and thereofore you are reasbonsibly to assure
        // your State models are migrated correctly.
        // Full documentation on Realm migration: https://realm.io/docs/swift/latest/#migrations

        // At the very minimum all we need to do is to update the version with an empty block
        // to indicate that the schema has been upgraded (automatically) by Realm.
        /*
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if oldSchemaVersion < 1 {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        */

        return true
    }
    // swiftlint:enable line_length

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions
        // (such as an incoming phone call or SMS message) or when the user quits the application
        // and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers,
        // and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data,
        // invalidate timers, and store enough application state information to restore
        // your application to its current state in case it is terminated later.
        // If your application supports background execution,
        // this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state;
        // here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started)
        // while the application was inactive.
        // If the application was previously in the background,
        // optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate.
        // See also applicationDidEnterBackground:.
    }

}
