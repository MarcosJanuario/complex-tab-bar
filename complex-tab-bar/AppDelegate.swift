//
//  AppDelegate.swift
//  complex-tab-bar
//
//  Created by Marcos Januário on 19.05.19.
//  Copyright © 2019 Marcos Januário. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // Necessario para corrigir erro "RLMException, Migration is required for object type"
        let configuration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    
                    // if just the name of your model's property changed you can do this
                    //                    migration.renameProperty(onType: Data.className(), from: "text", to: "title")
                    
                    // if you want to fill a new property with some values you have to enumerate
                    // the existing objects and set the new value
                    //                    migration.enumerateObjects(ofType: Data.className()) { oldObject, newObject in
                    //                        let text = oldObject!["text"] as! String
                    //                        newObject!["textDescription"] = "The title is \(text)"
                    //                    }
                    
                    // if you added a new property or removed a property you don't
                    // have to do anything because Realm automatically detects that
                }
        }
        )
        Realm.Configuration.defaultConfiguration = configuration
        
        do {
            _ = try Realm()
        } catch {
            print("Error by initializing Realm \(error)")
        }
        
        //A COR DE FUNDO DO TAB BAR
//        UITabBar.appearance().barTintColor = .black
        //A COR DO ICONE SELECIONADO DO TABBAR
        UITabBar.appearance().tintColor = .red
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

