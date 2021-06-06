//
//  AppDelegate.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 30/05/21.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        var configuration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {

                    // if just the name of your model's property changed you can do this
    //                migration.renameProperty(onType: NotSureItem.className(), from: "text", to: "title")

                    // if you want to fill a new property with some values you have to enumerate
                    // the existing objects and set the new value
    //                migration.enumerateObjects(ofType: NotSureItem.className()) { oldObject, newObject in
    //                    let text = oldObject!["text"] as! String
    //                    newObject!["textDescription"] = "The title is \(text)"
    //                }

                    // if you added a new property or removed a property you don't
                    // have to do anything because Realm automatically detects that
                }
            }
        )
        Realm.Configuration.defaultConfiguration = configuration
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

