//
//  ViewController.swift
//  CollectDataApplicatiom
//
//  Created by MacBook Pro on 11/27/20.
//  Copyright © 2020 ArwaKomo. All rights reserved.
//
import Foundation
import UIKit
import AAPickerView
import SideMenu
import Presentr
import DeviceGuru
import CoreLocation
import CoreMotion
import UserNotifications
import RealmSwift
import Realm
import SwiftUI
//let app = App(id: "mahhidrealm-wtxqi")
//https://stackoverflow.com/questions/65074310/404-unauthorized-authenticate-with-the-realm-cli

class FormVC: UIViewController, UNUserNotificationCenterDelegate, CLLocationManagerDelegate{
    
    var motion = CMMotionManager()

    var delegate: popUpAccessSec?
    lazy var presenter: Presentr = { [unowned self] in
        let temp = Presentr(presentationType: .fullScreen)
        temp.backgroundColor = UIColor.white
        temp.dismissOnSwipe = false
        return temp
        }()
    
    @IBOutlet weak var numOFSelecrTF: AAPickerView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var modelCarTF: UITextField!
    @IBOutlet weak var carTypeTF: UITextField!
    @IBOutlet weak var softMobileTF: UITextField!
    @IBOutlet weak var mobileTypeTF: UITextField!
    @IBOutlet weak var regionTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    var damagevalue: String = ""
    var modelCarvalue = "nil"
    var carTypevalue = "nil"
    var softMobilevalue = 0.0
    var mobileTypevalue = "nil"
    var regionvalue = "nil"
    var namevalue = "nil"
    var numberOfWritevalue = "5 record in second"
    var NumOfWrites: Int = 5

    
    var temp = "road"
    var CatArray =  ["٥ قراءة فالثانية"," ٤ قراءة فالثانية","٣ قراءة فالثانية","٢ قراءة فالثانية","١ قراءة فالثانية"]
   
    let locationManager = CLLocationManager()
                               
       //.edgesIgnoringSafeArea(.top)
     
    override func viewDidLoad() {

        super.viewDidLoad()
        //runExample()

       // signIn()
        
        let controller:AccessPopUp  = AppDelegate.storyboard.instanceVC()
   //     controller.temp = self.temp
             customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
       // title = "My Project"

        requestPermissionNotifications()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        config_CategoryPicker()
        
        iosversion()
        DiviceModel()
        
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
             if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        //https://github.com/rshankras/Swift-Demo/blob/master/WhereAmI/WhemAmI/ViewController.swift
        //https://rustynailsoftware.com/dev-blog/core-location-reverse-geocoding-locations-using-clgeocoder
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let Locality = (containsPlacemark.subLocality != nil) ? containsPlacemark.subLocality : ""
             regionTF.text = Locality
            //countryTxtField.text = country
        }

    }
    
 
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
          print("Error while updating location " + error.localizedDescription)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
        func requestPermissionNotifications(){
            let application =  UIApplication.shared
            
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (isAuthorized, error) in
                    if( error != nil ){
                        print(error!)
                    }
                    else{
                        if( isAuthorized ){
                            print("authorized")
                            NotificationCenter.default.post(Notification(name: Notification.Name("AUTHORIZED")))
                        }
                        else{
                            let pushPreference = UserDefaults.standard.bool(forKey: "PREF_PUSH_NOTIFICATIONS")
                            if pushPreference == false {
                                let alert = UIAlertController(title: "Turn on Notifications", message: "Push notifications are turned off.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Turn on notifications", style: .default, handler: { (alertAction) in
                                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                        return
                                    }
                                    
                                    if UIApplication.shared.canOpenURL(settingsUrl) {
                                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                            // Checking for setting is opened or not
                                            print("Setting is opened: \(success)")
                                        })
                                    }
                                    UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                                }))
                                alert.addAction(UIAlertAction(title: "No thanks.", style: .default, handler: { (actionAlert) in
                                    print("user denied")
                                    UserDefaults.standard.set(true, forKey: "PREF_PUSH_NOTIFICATIONS")
                                }))
                            }
                        }
                    }
                }
            }
            else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
        }

        
        
        func postLocalNotifications(eventTitle:String){
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = eventTitle
            content.body = "You've entered a new region"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let notificationRequest:UNNotificationRequest = UNNotificationRequest(identifier: "Region", content: content, trigger: trigger)
            
            center.add(notificationRequest, withCompletionHandler: { (error) in
                if let error = error {
                    // Something went wrong
                    print(error)
                }
                else{
                    print("added")
                }
            })
        }
        
    func config_CategoryPicker() {
        
        numOFSelecrTF.pickerType = .string(data: CatArray)
        numOFSelecrTF.heightForRow = 40
        numOFSelecrTF.toolbar.barTintColor = .darkGray
        numOFSelecrTF.toolbar.tintColor = .darkGray
        numOFSelecrTF.valueDidSelected = { (index) in
        }
        self.NumOfWrites = 5

        numOFSelecrTF.valueDidChange = { [self] value in
            print("selected Value",value)
            if (value as! Int == 0){
                    print("")
                self.numOFSelecrTF.text = self.CatArray[0]
                let numberOfWritevalue = "5 record in second"
                self.NumOfWrites = 5
                print(numberOfWritevalue)
                    }
                    if (value as! Int == 1){
                        self.numOFSelecrTF.text = self.CatArray[1]
                        let numberOfWritevalue = "4 record in second"
                        self.NumOfWrites = 4
                        print(numberOfWritevalue)
                    }
                    
                    if (value as! Int == 2){
                        self.numOFSelecrTF.text = self.CatArray[2]
                        let numberOfWritevalue = "3 record in second"
                        self.NumOfWrites = 3
                            print(numberOfWritevalue)

                    }
                    if (value as! Int == 3){
                        self.numOFSelecrTF.text = self.CatArray[3]
                        let numberOfWritevalue = "2 record in second"
                        self.NumOfWrites = 2
                            print(numberOfWritevalue)
                    }
                    else if (value as! Int == 4){
                        self.numOFSelecrTF.text = self.CatArray[4]
                        let numberOfWritevalue = "1 record in second"
                        self.NumOfWrites = 1
                            print(numberOfWritevalue)
                     }
        }
       
               // print("is chosen from list:",damagevalue as Any)
    }
    
    @IBAction func meunBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuRightVC = storyboard.instantiateViewController(withIdentifier: "aa") as! UISideMenuNavigationController
                SideMenuManager.default.menuRightNavigationController = menuRightVC
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
      }
    
    
    @IBAction func nextBtn(_ sender: Any) {
      
        print("Myvalue",NumOfWrites)
        
        if self.temp == "road" {
        let vc : HofraVC = AppDelegate.storyboard.instanceVC()
            let DataToPotholeVC = storyboard?.instantiateViewController(withIdentifier: "HofraVC") as! HofraVC
            DataToPotholeVC.numberOfWrite = NumOfWrites
            DataToPotholeVC.modalPresentationStyle = .fullScreen
            present(DataToPotholeVC, animated: true, completion: nil)
            AppManager.shared.rootNavigationController?.pushViewController(vc, animated: true)
         }
        else {
            let vc : RoadVC = AppDelegate.storyboard.instanceVC()
            let DataToRoadVC = storyboard?.instantiateViewController(withIdentifier: "RoadVC") as! RoadVC
            DataToRoadVC.numberOfWrite = NumOfWrites
            DataToRoadVC.modalPresentationStyle = .fullScreen
            present(DataToRoadVC, animated: true, completion: nil)
            AppManager.shared.rootNavigationController?.pushViewController(vc, animated: true)
          //navigationController
        }
        
       
     //    Vairables to labelss.
        self.regionvalue = regionTF.text!
        self.modelCarvalue = modelCarTF.text!
        self.carTypevalue = carTypeTF.text!
        self.softMobilevalue = Double(softMobileTF.text!)!
        self.mobileTypevalue = mobileTypeTF.text!
        self.namevalue = nameTF.text!
      //self.numberOfWritevalue = numOFSelecrTF.text!
        

        print("is written:",self.modelCarvalue)
        print("is written:",self.carTypevalue)
        print("is written:",self.softMobilevalue)
        print("is written:",self.mobileTypevalue)
        print("is written:",self.regionvalue)
        print("is written:",self.namevalue)
        print("is written:",self.damagevalue)
        print("is chosen from list:",self.numberOfWritevalue)
        
    //    convenience init(partition: String, name: String, region: String, mobileType: String , MobileSoftware: String , CarType: String , CarModel: String , DamageType: String) {
        // Now logged in, do something with user
        //let app = App(id: YOUR_REALM_APP_ID)
       // let realm = try! Realm(configuration: configuration)
      //  print("Opened realm: \(realm)")
      
        // Log in...
        /*   app.login(credentials: Credentials.anonymous) { (result) in
            // Remember to dispatch back to the main thread in completion handlers
            // if you want to do anything on the UI.
             DispatchQueue.main.async { [] in

                switch result {
                case .failure(let error):
                    print("Login failed: \(error)")
                case .success(let user):
                    print("Login as \(user) succeeded!")
                
                  let user = app.currentUser!
                    // The partition determines which subset of data to access.
                 let partitionValue = user.id
                    // Get a sync configuration from the user object.
                 var configuration = user.configuration(partitionValue: partitionValue)
                    configuration.objectTypes = [UserRecord.self]
                    Realm.asyncOpen(configuration: configuration) { (result) in
                        switch result {
                        case .failure(let error):
                            print("Failed to open realm: \(error.localizedDescription)")
                            // Handle error...
                        case .success(let realm):
                  //    let myrecorddata = realm.objects(UserRecord.self)

                         
                            let NewRecordData  = UserRecord(_partition: partitionValue
                                                            , name : self.namevalue
                                                            , region : self.regionvalue
                                                            , mobileType : self.mobileTypevalue
                                                            , MobileSoftware : self.softMobilevalue
                                                            , CarType : self.carTypevalue
                                                            , CarModel : self.modelCarvalue
                                                            , NumberOfRecords : self.numberOfWritevalue
                                                            , DamageType : self.damagevalue )
                            syncManager.logLevel = .debug
                            
                     //       let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
                      //      print("Opened realm: \(realm)")
                           try! realm.write
                       {  realm.add(NewRecordData.self)  }
                            let path = realm.configuration.fileURL?.path
                                  print("Realm Path: \(String(describing: path))")
                     //  print("A list: \(myrecorddata)")
                            app.currentUser?.logOut
                            { (error) in }
                            // Invalidate notification tokens when done observing
                           // NotificationToken.invalidate()
                            
                        } } } } }
 */
        /*
         
         ------------DELETE--------------
         let realm = try! Realm()
         try! realm.write {
             // Find dogs younger than 2 years old.
             let puppies = realm.objects(Dog.self).filter("age < 2")
             // Delete the objects in the collection from the realm.
             realm.delete(puppies)
         }
         */
        
       // Realm
        /*
         exports = function() {
           const mongodb = context.services.get("mongodb-atlas");
           const itemsCollection = mongodb.db("store").collection("items");
           const purchasesCollection = mongodb.db("store").collection("purchases");
           // ... paste snippet here ...
         }
         
         const doc1 = { "name": "basketball", "category": "sports", "quantity": 20, "reviews": [] };
        const doc2 = { "name": "football",   "category": "sports", "quantity": 30, "reviews": [] };
        return itemsCollection.insertMany([doc1, doc2])
          .then(result => {
            console.log(`Successfully inserted ${result.insertedIds.length} items!`);
            return result
          })
          .catch(err => console.error(`Failed to insert documents: ${err}`))
         */
        //----------------ARRAY--------------//
      /*  let arrayObject : [String?] = [regionvalue,modelCarvalue,carTypevalue,softMobilevalue,mobileTypevalue,namevalue]

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myNotification"), object: arrayObject)

        func refreshList(notification: NSNotification){

            let arrayObject =  notification.object as! [AnyObject]
            let receivednumber = arrayObject[0] as! Int
            let receivedString = arrayObject[1] as! String
        }
        //----------------------------------
        
        //https://stackoverflow.com/questions/30328452/how-to-pass-multiple-values-with-a-notification-in-swift
        let myDict = [ "regionvaluepass": regionvalue, "modelCarvaluepass":modelCarvalue, "carTypevaluepass":carTypevalue,"softMobilevaluepass":softMobilevalue,"mobileTypevaluepass":mobileTypevalue,"namevaluepass":namevalue,"damagevaluepass":damagevalue]
        
 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myNotification"), object: nil, userInfo: myDict)
 */
   //     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myNotification"), object:myDict);

     //   NotificationCenter.default.post(name: NSNotification.Name, object: myDict)

            }
    
  //  func refreshList(notification: Notification){
  //      let receivednumber = notification.userInfo?["damagevaluepass"] as? Int ?? 0
   //     let receivedString = notification.userInfo?["regionvaluepass"] as? String ?? ""  }
    
    func iosversion(){
       // var deviceOSVersion = UIDevice.currentDevice.systemversion()
        //https://stackoverflow.com/questions/3339722/how-to-check-ios-version/44429397
        let ver = (UIDevice.current.systemVersion as NSString).floatValue
        softMobileTF.text = String(format: "%.1f", ver)
       print("iosVersion",ver)
    }
    
    
    func DiviceModel(){
        let deviceGuru = DeviceGuru()
        let deviceName = deviceGuru.hardware()
        let deviceCode = deviceGuru.hardwareString()
        let platform = deviceGuru.platform()
        print("\(deviceName) - \(deviceCode) - \(platform.hashValue)")
        mobileTypeTF.text = "\(deviceName)"
    }
    
    
    @IBAction func roadOneBtn(_ sender: Any) {
        image1.image = UIImage(named: "Select")
        image2.image = UIImage(named: "unSelect")
        self.temp = "road"
        self.damagevalue = "road"
     print("road btn Selected")
    }
    
    @IBAction func roadTwoBtn(_ sender: Any) {
        image1.image = UIImage(named: "unSelect")
        image2.image = UIImage(named: "Select")
        self.temp = "hofra"
        self.damagevalue = "pothole"
        print("pothole btn Selected")
    }
    
}


extension FormVC: popUpAccessSec  {
    
    func reloadAccess(reloaded: Bool) {
        if reloaded {
      //getAllMyList()
        }
    }
}


extension Notification.Name{
    static let mynotification = Notification.Name("myNotification")
}


class AppManager{
    static let shared = AppManager()
    var rootNavigationController: UINavigationController?
    
}
