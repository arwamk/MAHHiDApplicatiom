//
//  SceneDelegate.swift
//  CollectDataApplicatiom
//
//  Created by MacBook Pro on 11/27/20.
//  Copyright © 2020 ArwaKomo. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

/*struct Constants {
    // Set this to your Realm App ID found in the Realm UI.
    static let REALM_APP_ID = "applicationtest-xsgih"
}*/

//struct Constants {
    // Set this to your Realm App ID found in the Realm UI. static let REALM_APP_ID = "applicationtest-xsgih" }

 let app = App(id: "applicationtest-xsgih") // replace YOUR_REALM_APP_ID with your App ID
// Access the sync manager for the app
let syncManager = app.syncManager
// Set the logger to provide debug logs

//let app = App(id: Constants.REALM_APP_ID)





class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//"mahhidrealm-wtxqi"
    var window: UIWindow?

    //app.currentUser?.logOut { (error) in
    // user is logged out or there was an error }
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
    



    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

