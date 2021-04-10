//
//  RoadVC.swift
//  CollectDataApplicatiom
//
//  Created by MacBook Pro on 11/27/20.
//  Copyright © 2020 ArwaKomo. All rights reserved.
//

import UIKit
import SideMenu
import Presentr
import CoreMotion
import CoreLocation
import MapKit
import Foundation
import RealmSwift
import SwiftUI
//mahhidrealm-wtxqi
//cmdA control i
//let app = App(id: mahhidrealm-wtxqi) // replace YOUR_REALM_APP_ID with your App ID
// Create an observable object class that announces
// changes to its only property
struct AccelStrctRoad {
    var x: Double?
    var y: Double?
    var z: Double?
}

struct GyroStrctRoad {
    var x: Double?
    var y: Double?
    var z: Double?
}

class RoadVC: UIViewController ,CLLocationManagerDelegate{
    private var observer: NSObjectProtocol!
    
    var delegate: popUpSave?
    lazy var presenter: Presentr = { [unowned self] in
        let temp = Presentr(presentationType: .fullScreen)
        temp.backgroundColor = UIColor.black
        temp.dismissOnSwipe = false
        return temp
    }()
  
    var getAccData = AccelStrctRoad()
    var getGyroData = GyroStrctRoad()

    var dataRecord = DataRecord()
    let gr = DispatchGroup()
    
    @IBOutlet weak var RoadMap: MKMapView!
    @IBOutlet weak var timeTravel: UILabel!
    @IBOutlet weak var speedlabel: UILabel!
    @IBOutlet weak var lineWidth: UILabel!
    @IBOutlet weak var lineHeght: UILabel!
    @IBOutlet weak var acX: UILabel!
    @IBOutlet weak var acY: UILabel!
    @IBOutlet weak var acZ: UILabel!
    @IBOutlet weak var geX: UILabel!
    @IBOutlet weak var geY: UILabel!
    @IBOutlet weak var geZ: UILabel!
    @IBOutlet weak var BattaryLabel: UILabel!
    
    @IBOutlet weak var widthCont: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var endView: UIView!
    var temp = true
    //for puting placemark on the map.
    // https://ase.in.tum.de/lehrstuhl_1/teaching/tutorials/505-sgd-ws13-tutorial-core-motion
    //var motionManager: CMMotionManager!
    var motion = CMMotionManager()
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    //    var delegate:speedManager()
    ///// var delegate: SpeedManagerDelegate?
    var batteryLevel: Float {
           return UIDevice.current.batteryLevel
       }
    
    var updatingLocation = false
    var startLocation: CLLocation!
    var traveledDistance: Double = 0.0
    var speed: CLLocationSpeed = CLLocationSpeed()
    var location: CLLocation?
    var damageType: String = "Road"
    var numberOfWrite = 0
    //  var delegate: SpeedManagerDelegate?
    
    //Timer Code //https://www.ioscreator.com/tutorials/stopwatch-tutorial
    var counter = 0.0
    var startTime = TimeInterval()
    var Savingtimer = Timer()
    var UIUpdateTimer = Timer()
    var motionUpdateTimer = Timer()
    
    var isPlaying = false
    let defaults1 = UserDefaults.standard
    // let defaults2 = UserDefaults.standard
    
    var TimerValue = 0.0
    var SpeedValue = 0.0
 //   var lastLocation: CLLocation!

    let lastlocation : CLLocation? = nil
    var currentLocation: CLLocation? = nil
    var LatValue = 0.0
    var LonValue = 0.0
  
    var battaryValue=0.0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        timeTravel.text = String(counter)
        UIDevice.current.isBatteryMonitoringEnabled = true
        self.damageType = "Road"
        locationManager.delegate = self
        endView.isHidden = true
    }
        
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            
            RoadMap.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            updatingLocation = true
            break
            
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        default:
            print("something default")
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        } }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            RoadMap.setRegion(region, animated: true)
        }}
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let trueData: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(trueData.latitude) \(trueData.longitude)")
        
        self.lineWidth!.text = "\(trueData.latitude)"
        self.lineHeght!.text = "\(trueData.longitude)"
        
        dataRecord.LatitudeValue = trueData.latitude
        currentLocation = locations[0]
        
        self.LatValue = trueData.latitude
        self.LonValue = trueData.longitude
        print("L C:", self.LatValue,self.LonValue)
        //LatValue
        //lineWidth
        let location = locations[0]
        let span:MKCoordinateSpan =  MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let reigon:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        RoadMap.setRegion(reigon, animated: true)
        self.RoadMap.showsUserLocation =  true
        self.RoadMap.userTrackingMode = .followWithHeading
        
        /// Speed was here
        print("Start Speeeeed!")
        guard let speed = manager.location?.speed else { return }
        speedlabel.text = speed < 0 ? "لا يوجد" : "\(speed*3.6)"
        self.SpeedValue=speed*3.6
        //speed/1000 * 3600
        print("the speed\(speed/1000 * 3600)")
        //https://stackoverflow.com/questions/43960584/how-can-i-get-swift-to-continuously-update-the-speed
    
        
    }
    
    
    func myDeviceLocations(){
        print("Start DeviceLocations")
        motion.gyroUpdateInterval = 0.5
        motion.startGyroUpdates(to: OperationQueue.current!) {
            (data, error) in
            print(data as Any)
            if let trueData =  data {
                self.view.reloadInputViews()
                self.lineWidth!.text = "\(trueData.rotationRate.x)"
                self.lineHeght!.text = "\(trueData.rotationRate.y)"
            }
        }
        return
    }
    
    func BattraryLevelFunc(batteryLevelValue: Float) -> Float
    {
        self.battaryValue = Double(UIDevice.current.batteryLevel)
        let batteryLevelValue = self.battaryValue*100
        
        if batteryLevelValue < 0 {
            print(" -1.0 means battery state is UIDeviceBatteryStateUnknown")
            return 0 }
        else{
            
            NotificationCenter.default.addObserver(self, selector: Selector(("batteryLevelDidChange")), name: UIDevice.batteryLevelDidChangeNotification,
              object: nil)
            BattaryLabel.text = String(Int(batteryLevelValue))
            print("Level of battary is:",(Int(batteryLevelValue)),"%")
            return Float(batteryLevelValue) }
    }
 
func batteryLevelDidChange(notification: NSNotification){
    
    let batteryLevel = UIDevice.current.batteryLevel
    if batteryLevel < 0.0 {
        print(" -1.0 means battery state is UIDeviceBatteryStateUnknown")
        return
    }
    
    print("Battery Level : \(batteryLevel * 100)%")
    // The battery's level did change (98%, 99%, ...)
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() // Dispose of any resources that can be recreated.
    }
    
     @IBAction func menuBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuRightVC = storyboard.instantiateViewController(withIdentifier: "aa") as! UISideMenuNavigationController
        SideMenuManager.default.menuRightNavigationController = menuRightVC
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func backBtn(_ sender: Any) { navigationController?.popViewController(animated: true) }
     
    //MARK: - - - - - Method for receiving Data through Post Notificaiton - - - - -
    @objc func methodOfReceivedNotification(notification: Notification)
    {  print("Value of notification : ", notification.object ?? "")
       // self.NewAccArray = notification.object as! [Double]
       // print("value20000",self.NewAccArray)
          //MARK: - - - - - Set data for Passing Data Post Notification - - - - -
        // https://stackoverflow.com/questions/24049020/nsnotificationcenter-addobserver-in-swift
      }
    
    
    func myAccelerometer(completionHandler: @escaping (AccelStrctRoad? , Error?) -> Void) {
        
        //https://www.youtube.com/watch?v=JbnBm574H0Q
         motion.accelerometerUpdateInterval = 0.5
         motion.startAccelerometerUpdates(to: OperationQueue.current!) { [self]
            (data, error) in
            print(data as Any)
            if let trueData =  data {
                self.view.reloadInputViews()
                let x = trueData.acceleration.x
                let y = trueData.acceleration.y
                let z = trueData.acceleration.z
                self.acX.text = "\(Double(x).rounded(to :3))" // INTO LABELS TO DISPLAY
                self.acY.text = "\(Double(y).rounded(to :3))"
                self.acZ.text = "\(Double(z).rounded(to :3))"
                //https://www.youtube.com/watch?v=JmPbnuJxzHg
                let getvalues = AccelStrctRoad(x: data!.acceleration.x, y: data!.acceleration.y, z: data!.acceleration.z)
                completionHandler(getvalues,nil)
            } else if error != nil {
                completionHandler(nil,error)
            }
        }
    }
    
    func myGyroscope(completionHandler: @escaping (GyroStrctRoad? , Error?) -> Void) {
        //https://github.com/soonin/IOS-Swift-CoreMotionGyroscope01/blob/master/IOS-Swift-CoreMotionGyroscope01/ViewController.swift
        //https://www.youtube.com/watch?v=43B_-S5iN5o&t=751s
        //https://www.youtube.com/watch?v=nsChcl2fvps
        //https://developer.apple.com/documentation/coremotion/getting_raw_gyroscope_events
         motion.gyroUpdateInterval = 0.5
        motion.startGyroUpdates(to: OperationQueue.current!) { // this was the problem
            (data, error) in
            print(data as Any)
            if let trueData =  data {
                self.view.reloadInputViews()
                let x = trueData.rotationRate.x
                let y = trueData.rotationRate.y
                let z = trueData.rotationRate.z
                self.geX.text = "\(Double(x).rounded(to :3))"
                self.geY.text = "\(Double(y).rounded(to :3))"
                self.geZ.text = "\(Double(z).rounded(to :3))"
              //   self.GyrXValue = trueData.rotationRate.x  self.GyrYValue = trueData.rotationRate.y self.GyrZValue = trueData.rotationRate.z
             
                let getvalues1 = GyroStrctRoad(x: trueData.rotationRate.x, y: trueData.rotationRate.y, z: trueData.rotationRate.z)
                completionHandler(getvalues1,nil)
            }
           else if error != nil {
            completionHandler(nil,error)
        }
        }
       }
    
    @objc func saveData() {
        motionUpdateTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0), target: self, selector: #selector(GetMotionData), userInfo: nil, repeats: true)

         let batteryLevelValue = BattraryLevelFunc(batteryLevelValue: Float(battaryValue))

        let NewRecordedData = RoadRecord(_partition: ""
                                         , TimerValue: Float(counter)
                                         , LatitudeValue: self.LatValue
                                         , LonguiteValue: self.LonValue
                                         , AccXValue: getAccData.x ?? 0
                                         , AccYValue: getAccData.y ?? 0
                                         , AccZValue: getAccData.z ?? 0
                                          , GyrXValue: getGyroData.x ?? 0
                                          , GyrYValue: getGyroData.y ?? 0
                                          , GyrZValue: getGyroData.z ?? 0
                                         , SpeedValue: self.SpeedValue
                                         , BattaryValue: Int(batteryLevelValue)
                                         , DamageTypeValue: self.damageType)
 
        print("Data To Save:",NewRecordedData)
        
    }
    
    @objc func GetMotionData() {
        myAccelerometer { [self] (accData, error) in
            getAccData.x = accData?.x
            getAccData.y = accData?.y
            getAccData.z = accData?.z
         }
        myGyroscope { [self] (GyroData, error) in
            getGyroData.x = GyroData?.x
            getGyroData.y = GyroData?.y
            getGyroData.z = GyroData?.z
         }

    }
    
    //@objc func getGyro() { }
    
    
    func locationHandle() {
        
        gr.enter()
        checkLocationServices()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {   locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation() }
        gr.notify(queue: .main) { print(self.currentLocation!.coordinate.latitude) }
    }
    
    @objc func UpdateTimer() {
        counter = counter + 0.1
        timeTravel.text = String(format: "%.1f", counter)
    }
    
    @IBAction func startRecordBtn(_ sender: Any) {
        widthCont.constant = 130.0
        endView.isHidden = false
        startView.isHidden = true
        backView.isHidden = true
        if(isPlaying) { return }
        
        isPlaying = true
        locationHandle()
       // getRecordData()
        UIUpdateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
          // A - B - C - D
        let writesinmilis = (1000 /  5) / 1000
       Savingtimer = Timer.scheduledTimer(timeInterval: TimeInterval(writesinmilis), target: self, selector: #selector(saveData), userInfo: nil, repeats: true)

        
    }
    
    
    @IBAction func endBtn(_ sender: Any) {
        isPlaying = false
        
        UIUpdateTimer.invalidate()
        Savingtimer.invalidate()
        motionUpdateTimer.invalidate()
        locationManager.delegate = nil
        updatingLocation = false
        self.locationManager.stopUpdatingLocation()
        self.motion.stopDeviceMotionUpdates()
        self.motion.stopAccelerometerUpdates()
        self.motion.stopGyroUpdates()
        self.motion.stopMagnetometerUpdates()
     locationManager.stopMonitoringSignificantLocationChanges()
     locationManager.allowsBackgroundLocationUpdates = false
     locationManager.pausesLocationUpdatesAutomatically = true
        
       print("IT'S TIME TO STOP POTHOLE")
        let controller:SavePopUpVC  = AppDelegate.storyboard.instanceVC()
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
        // SartRecordButton.isEnabled = true
         
        //   SartRecordButton.isEnabled = true
        print("Doing Logging out...");
        /*app.currentUser?.logOut() { (error) in
         // DispatchQueue.main.async {
         DispatchQueue.main.sync {
         print("Logged out!");
         //  self.navigationController?.setViewControllers([WelcomeViewController()], animated: true)
         //  }
         }
         }
         */
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}


extension RoadVC: popUpSave  {
    func reloadSave(reloaded: Bool) {
     /*   stopLocationManager()
        self.motion.stopDeviceMotionUpdates()
        self.motion.stopAccelerometerUpdates()
        self.motion.stopGyroUpdates()
        self.motion.stopMagnetometerUpdates()
        self.stopLocationManager()*/
        if reloaded {
        }
    }
}
extension RoadVC{
    
    
    private func mylocationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        RoadMap.setRegion(region, animated: true)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(to places: Int) -> Double {
        return Double(Int((pow(10, Double(places)) * self).rounded())) / pow(10, Double(places))
    }
}
 


