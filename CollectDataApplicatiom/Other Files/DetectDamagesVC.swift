//
//  File.swift
//  CollectDataApplicatiom
//
//  Created by public on 3/25/21.
//  Copyright © 2021 ArwaKomo. All rights reserved.
//

import UIKit
import SideMenu
import Presentr
import CoreMotion
import CoreLocation
import MapKit
import Foundation

struct AccelStrctDetect {
    var x: Double?
    var y: Double?
    var z: Double?
}

struct GyroStrctRoadDetect {
    var x: Double?
    var y: Double?
    var z: Double?
}

class DetectDamagesVC: UIViewController, CLLocationManagerDelegate {
    var delegate: popUpDetect?
    lazy var presenter: Presentr = { [unowned self] in
        let temp = Presentr(presentationType: .fullScreen)
        temp.backgroundColor = UIColor.black
        temp.dismissOnSwipe = false
        return temp
        }()
    
     @IBOutlet weak var timeTravel: UILabel!
     @IBOutlet weak var NumDetectedDamages: UILabel!
     @IBOutlet weak var DetectedDamageIs: UILabel!
    
    
    var getAccDataDetect = AccelStrctDetect()
    var getGyroDataDetect = GyroStrctRoadDetect()

    var dataRecord = DataRecord()
    let gr = DispatchGroup()
  
  var Savingtimer = Timer()
  var UIUpdateTimer = Timer()
  var motionUpdateTimer = Timer()
    var InputArray = [0.0]
    var TimerValue=0.0
    var SpeedValue=0.0
    var LatValue: Float = 0.0
    var LonValue: Float = 0.0
    var AccXValue: Float = 0.0
    var AccYValue: Float  = 0.0
    var AccZValue: Float  = 0.0
    var GyrXValue: Float  = 0.0
    var GyrYValue: Float  = 0.0
    var GyrZValue: Float  = 0.0
    var batteryLevel: Float = 0.0
    var damageType: String = "Pothole"
    var numberOfWrite: Int = 0
    var battaryValue = 0.0
    var PotholePressed = false
    var HerePothole = 0
    var motionManager: CMMotionManager!
   let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var currentLocation: CLLocation? = nil

    @IBOutlet weak var DetectMap: MKMapView!
    @IBOutlet weak var popView: UIView!
    // var delegate:speedManager()
 // var delegate: SpeedManagerDelegate?
    var NewSpeed = 0.0
 
 var updatingLocation = false
 var startLocation: CLLocation!
 var lastLocation: CLLocation!
 //  var CLLocationManager = CLLocationManager()
 var speed: CLLocationSpeed = CLLocationSpeed()

//  var delegate: SpeedManagerDelegate?
 
//Timer Code //https://www.ioscreator.com/tutorials/stopwatch-tutorial
 var counter = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         UIDevice.current.isBatteryMonitoringEnabled = true
        self.damageType = "Road"
        locationManager.delegate = self
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        //speedManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        motionManager = CMMotionManager()
        motionManager.startDeviceMotionUpdates()
        checkLocationServices()
        locationManager.startUpdatingLocation()

            locationManager.desiredAccuracy=kCLLocationAccuracyBest
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
        
    }
     
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
      let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            DetectMap.setRegion(region, animated: true)
        }
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
        
            DetectMap.showsUserLocation = true
         centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
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
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         
         guard let trueData: CLLocationCoordinate2D = manager.location?.coordinate else { return }
         print("locations = \(trueData.latitude) \(trueData.longitude)")
        // self.lineWidth!.text = "\(trueData.latitude)"
      //   self.lineHeght!.text = "\(trueData.longitude)"
         //lineWidth
        dataRecord.LatitudeValue = trueData.latitude
        currentLocation = locations[0]
        
        self.LatValue = Float(trueData.latitude)
        self.LonValue = Float(trueData.longitude)
        print("L C:", self.LatValue,self.LonValue)
         let location = locations[0]
             let span:MKCoordinateSpan =  MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
             let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
             let reigon:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        DetectMap.setRegion(reigon, animated: true)
             self.DetectMap.showsUserLocation =  true
             self.DetectMap.userTrackingMode = .followWithHeading
         
        // CLLocation = locations.last!
         //Speed Code

         print("Start Speeeeed!")
          guard let speed = manager.location?.speed else { return }
        self.NewSpeed = speed < 0 ? 0.0 : speed*3.6
         print("the speed\(speed*3.6)")
             print("i'm speedo",NewSpeed)
         //https://stackoverflow.com/questions/43960584/how-can-i-get-swift-to-continuously-update-the-speed
         //https://gist.github.com/lohenyumnam/37c0fe43ed59d670d7e4e1a0ca74ab83
        }
 
    
    func myDeviceLocations(){
        print("Start DeviceLocations")
        motionManager.gyroUpdateInterval = 0.5
        motionManager.startGyroUpdates(to: OperationQueue.current!) {
            (data, error) in
            print(data as Any)
          /*  if let trueData =  data {
                self.view.reloadInputViews()
                self.lineWidth!.text = "\(trueData.rotationRate.x)"
                self.lineHeght!.text = "\(trueData.rotationRate.y)"
            }*/
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
            //BattaryLabel.text = String(Int(batteryLevelValue))
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
    
    
    func myAccelerometer(completionHandler: @escaping (AccelStrctRoad? , Error?) -> Void) {
        
        //https://www.youtube.com/watch?v=JbnBm574H0Q
        motionManager.accelerometerUpdateInterval = 0.5
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {
            (data, error) in
            print(data as Any)
           // if let trueData =  data { self.view.reloadInputViews()  }
             //https://www.youtube.com/watch?v=JmPbnuJxzHg
             let getvalues = AccelStrctRoad(x: data!.acceleration.x, y: data!.acceleration.y, z: data!.acceleration.z)
             completionHandler(getvalues,nil)
             if error != nil {
                completionHandler(nil,error)
            } } }
    
    func myGyroscope(completionHandler: @escaping (GyroStrctRoad? , Error?) -> Void) {
        //https://github.com/soonin/IOS-Swift-CoreMotionGyroscope01/blob/master/IOS-Swift-CoreMotionGyroscope01/ViewController.swift
        //https://www.youtube.com/watch?v=43B_-S5iN5o&t=751s
        //https://www.youtube.com/watch?v=nsChcl2fvps
        //https://developer.apple.com/documentation/coremotion/getting_raw_gyroscope_events
        motionManager.gyroUpdateInterval = 0.5
        motionManager.startGyroUpdates(to: OperationQueue.current!) { // this was the problem
            (data, error) in
            print(data as Any)
        // if let trueData =  data { self.view.reloadInputViews() }
            let getvalues1 = GyroStrctRoad(x: data!.rotationRate.x
                                           , y: data!.rotationRate.y
                                           , z: data!.rotationRate.z)
                completionHandler(getvalues1,nil)
          if error != nil {
            completionHandler(nil,error)
        }
        }
       }
    
    @objc func SendData() {
        motionUpdateTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0), target: self, selector: #selector(GetMotionData), userInfo: nil, repeats: true)

        let batteryLevelValue = BattraryLevelFunc(batteryLevelValue: Float(battaryValue))
       let NewRecordedData = DataRecord(_partition: ""
                                         , TimerValue: Float(counter)
                                         , LatitudeValue: self.LatValue
                                         , LonguiteValue: self.LonValue
                                         , AccXValue: getAccDataDetect.x ?? 0
                                         , AccYValue: getAccDataDetect.y ?? 0
                                         , AccZValue: getAccDataDetect.z ?? 0
                                         , GyrXValue: getGyroDataDetect.x ?? 0
                                         , GyrYValue: getGyroDataDetect.y ?? 0
                                         , GyrZValue: getGyroDataDetect.z ?? 0
                                         , BattaryValue: Int(batteryLevelValue)
                                         , SpeedValue: self.SpeedValue)
         print("Data To Save:",NewRecordedData)
     
      /*  let NInputArray = InputArray.append(<#T##newElement: Double##Double#>)

        let InputArray = [self.LatValue
                        , self.LonValue
                       , getAccDataDetect.x ?? 0
                       , getAccDataDetect.y ?? 0
                       , getAccDataDetect.z ?? 0
                       , getGyroDataDetect.x ?? 0
                       , getGyroDataDetect.y ?? 0
                       , getGyroDataDetect.z ?? 0
                       , batteryLevelValue
                       , self.SpeedValue]
        */
        print("THERE IS INPUT MODEL:",InputArray[])
        //.tflite
         }
    
    
    @objc func GetMotionData() {
        myAccelerometer { [self] (accData, error) in
            getAccDataDetect.x = accData?.x
            getAccDataDetect.y = accData?.y
            getAccDataDetect.z = accData?.z
         }
        myGyroscope { [self] (GyroData, error) in
            getGyroDataDetect.x = GyroData?.x
            getGyroDataDetect.y = GyroData?.y
            getGyroDataDetect.z = GyroData?.z
         }

    }
    
 
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
    
     
    
    
    @IBAction func StartDetectBtn(_ sender: Any) {
        popView.isHidden = false
//        let controller:DetectPopUpVC  = AppDelegate.storyboard.instanceVC()
//
//        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
        UIUpdateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        
          // A - B - C - D
        let writesinmilis = (1000 /  5) / 1000
       Savingtimer = Timer.scheduledTimer(timeInterval: TimeInterval(writesinmilis), target: self, selector: #selector(SendData), userInfo: nil, repeats: true)
 }
    
    @IBAction func StopDetectBtn(_ sender: Any) {
        UIUpdateTimer.invalidate()
        Savingtimer.invalidate()
        motionUpdateTimer.invalidate()
        locationManager.delegate = nil
        updatingLocation = false
        self.locationManager.stopUpdatingLocation()
        self.motionManager.stopDeviceMotionUpdates()
        self.motionManager.stopAccelerometerUpdates()
        self.motionManager.stopGyroUpdates()
        self.motionManager.stopMagnetometerUpdates()
     locationManager.stopMonitoringSignificantLocationChanges()
     locationManager.allowsBackgroundLocationUpdates = false
     locationManager.pausesLocationUpdatesAutomatically = true
        
       print("IT'S TIME TO STOP POTHOLE")
        
     /*   let controller:SavePopUpVC  = AppDelegate.storyboard.instanceVC()
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
 */
        
    }
    
    
    
    @IBAction func MenuBtn(_ sender: Any)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuRightVC = storyboard.instantiateViewController(withIdentifier: "aa") as! UISideMenuNavigationController
                SideMenuManager.default.menuRightNavigationController = menuRightVC
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() // Dispose of any resources that can be recreated.
    }


}

extension DetectDamagesVC: popUpSave  {
    func reloadSave(reloaded: Bool) {
     /*   stopLocationManager()
        self.motion.stopDeviceMotionUpdates()
        self.motion.stopAccelerometerUpdates()
        self.motion.stopGyroUpdates()
        self.motion.stopMagnetometerUpdates()
        self.stopLocationManager()*/
        if reloaded {
        } } }

extension DetectDamagesVC{
    
     private func mylocationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        DetectMap.setRegion(region, animated: true)
    }
}
