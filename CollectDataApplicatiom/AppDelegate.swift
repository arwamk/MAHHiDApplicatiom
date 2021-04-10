//
//  AppDelegate.swift
//  CollectDataApplicatiom
//
//  Created by MacBook Pro on 11/27/20.
//  Copyright © 2020 ArwaKomo. All rights reserved.
//

import UIKit
//import RealmSwift
//Thread 1: "Attempting to create an object of type 'userdata' with an existing primary key value 'adam'."
@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
    /*Thread 1: "Property QsTask._id is declared as ObjectId, which is not a supported managed Object property type. If it is not supposed to be a managed property, either add it to `ignoredProperties()` or do not declare it as `@objc dynamic`. See https://realm.io/docs/swift/latest/api/Classes/Object.html for more information."
     */
    /*  let realm = try! RealmSwift.Realm(configuration: configuration)
     print("Opened realm: \(realm)")
     
     let app = App(id: "mahhidrealm-wtxqi", configuration: configuration)
     
     let configuration = AppConfiguration(
     baseURL: "https://realm.mongodb.com", // Custom base URL
     transport: nil, // Custom RLMNetworkTransportProtocol
     localAppName: "My App",
     localAppVersion: "3.14.159",
     defaultRequestTimeoutMS: 30000
     )
     let partitionValue = "some partition value"
     
     var configuration = user!.configuration(partitionValue: partitionValue)
     
     
     let user = app.currentUser
     
     
     Realm.asyncOpen(configuration: configuration) { result in
     switch result {
     case .failure(let error):
     print("Failed to open realm: \(error.localizedDescription)")
     // handle error
     case .success(let realm):
     print("Successfully opened realm: \(realm)")
     // Use realm
     }
     }
     
     let anonymousCredentials = Credentials.anonymous
     
     app.login(credentials: anonymousCredentials) { (result) in
     switch result {
     case .failure(let error):
     print("Login failed: \(error.localizedDescription)")
     case .success(let user):
     print("Successfully logged in as user \(user)")
     // Now logged in, do something with user
     // Remember to dispatch to main if you are doing anything on the UI thread
     }
     }
     
     */
    
    static var storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       /* do {
            let _ = try Realm()
        } catch  {
            print("Error initializing realm\(error)")
        }*/
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

