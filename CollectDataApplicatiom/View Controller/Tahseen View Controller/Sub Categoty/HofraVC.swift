//
//  HofraVC.swift
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

 struct AccelStrctPothole {
    var AccelStrctPothole_x: Double?
    var AccelStrctPothole_y: Double?
    var AccelStrctPothole_z: Double?
}

struct GyroStrctPothole {
    var GyroStrctPothole_x: Double?
    var GyroStrctPothole_y: Double?
    var GyroStrctPothole_z: Double?
}
 
class HofraVC: UIViewController, CLLocationManagerDelegate {
    var delegate: popUpSave?
    lazy var presenter: Presentr = { [unowned self] in
        let temp = Presentr(presentationType: .fullScreen)
        temp.backgroundColor = UIColor.black
        temp.dismissOnSwipe = false
        return temp
        }()
    @IBOutlet weak var PotholeMap: MKMapView!
    @IBOutlet weak var timeTravel: UILabel!
    @IBOutlet weak var velocity: UILabel!
    @IBOutlet weak var lineWidth: UILabel!
    @IBOutlet weak var lineHeght: UILabel!
    @IBOutlet weak var acX: UILabel!
    @IBOutlet weak var acY: UILabel!
    @IBOutlet weak var acZ: UILabel!
    @IBOutlet weak var geX: UILabel!
    @IBOutlet weak var geY: UILabel!
    @IBOutlet weak var geZ: UILabel!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var endView: UIView!
    @IBOutlet weak var hofrahView: UIView!
    @IBOutlet weak var BattaryLabel: UILabel!

    
      var getAccDataPothole = AccelStrctPothole()
      var getGyroDataPothole = GyroStrctPothole()

      var dataRecord = DataRecord()
      let gr = DispatchGroup()
    
    var Savingtimer = Timer()
    var UIUpdateTimer = Timer()
    var motionUpdateTimer = Timer()

       var TimerValue=0.0
       var SpeedValue=0.0
       var LatValue=0.0
       var LonValue=0.0
       var AccXValue=0.0
       var AccYValue=0.0
       var AccZValue=0.0
       var GyrXValue=0.0
       var GyrYValue=0.0
       var GyrZValue=0.0
       var batteryLevel: Float = 0.0
       var damageType: String = "Pothole"
       var numberOfWrite: Int = 0
       var battaryValue = 0.0
       var PotholePressed = false
       var HerePothole = 0
    //for puting placemark on the map.
   // https://ase.in.tum.de/lehrstuhl_1/teaching/tutorials/505-sgd-ws13-tutorial-core-motion
       var motionManager: CMMotionManager!
       //var motion = CMMotionManager()
       let locationManager = CLLocationManager()
       let regionInMeters: Double = 10000
       var currentLocation: CLLocation? = nil

    // var delegate:speedManager()
    // var delegate: SpeedManagerDelegate?

    var updatingLocation = false
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance: Double = 0.0
  //  var CLLocationManager = CLLocationManager()
    var speed: CLLocationSpeed = CLLocationSpeed()

  //  var delegate: SpeedManagerDelegate?
    
//Timer Code //https://www.ioscreator.com/tutorials/stopwatch-tutorial
    var counter = 0.0
  //  var timer = Timer()
    var isPlaying = false
    
 //   var speed: CLLocationSpeed = CLLocationSpeed()

    override func viewDidLoad() {
        super.viewDidLoad()
        endView.isHidden = true
        hofrahView.isHidden = true
        
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
            PotholeMap.setRegion(region, animated: true)
        }
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
        
         PotholeMap.showsUserLocation = true
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
         self.lineWidth!.text = "\(trueData.latitude)"
         self.lineHeght!.text = "\(trueData.longitude)"
         //lineWidth
        dataRecord.LatitudeValue = trueData.latitude
        currentLocation = locations[0]
        
        self.LatValue = trueData.latitude
        self.LonValue = trueData.longitude
        print("L C:", self.LatValue,self.LonValue)
         let location = locations[0]
             let span:MKCoordinateSpan =  MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
             let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
             let reigon:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
             PotholeMap.setRegion(reigon, animated: true)
             self.PotholeMap.showsUserLocation =  true
             self.PotholeMap.userTrackingMode = .followWithHeading
         
        // CLLocation = locations.last!
         //Speed Code

         print("Start Speeeeed!")

         guard let speed = manager.location?.speed else { return }
        velocity.text = speed < 0 ? "لا يوجد" : "\(speed*3.6)"
         print("the speed\(speed*3.6)")
             
         //https://stackoverflow.com/questions/43960584/how-can-i-get-swift-to-continuously-update-the-speed
         //https://gist.github.com/lohenyumnam/37c0fe43ed59d670d7e4e1a0ca74ab83
        }
 
    func myAccelerometer(completionHandler: @escaping (AccelStrctPothole? , Error?) -> Void) {
         //https://www.youtube.com/watch?v=JbnBm574H0Q
        motionManager.accelerometerUpdateInterval = 0.5
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {
             (data, error) in
             print(data as Any)
             if let trueData =  data {
                 
                self.view.reloadInputViews()
                let xv = trueData.acceleration.x
                let yv = trueData.acceleration.y
                let zv = trueData.acceleration.z
             self.acX.text = "\(Double(xv).rounded(to :3))"
             self.acY.text = "\(Double(yv).rounded(to :3))"
             self.acZ.text = "\(Double(zv).rounded(to :3))"
                //https://www.youtube.com/watch?v=JmPbnuJxzHg
             let getvaluesAcc = AccelStrctPothole(AccelStrctPothole_x: data!.acceleration.x
                                                  , AccelStrctPothole_y: data!.acceleration.y
                                                  , AccelStrctPothole_z: data!.acceleration.z)
                completionHandler(getvaluesAcc,nil)
            } else if error != nil {
                completionHandler(nil,error)
            }
         }
      }

    func myGyroscope(completionHandler: @escaping (GyroStrctPothole? , Error?) -> Void) {
         //https://github.com/soonin/IOS-Swift-CoreMotionGyroscope01/blob/master/IOS-Swift-CoreMotionGyroscope01/ViewController.swift
         //https://www.youtube.com/watch?v=43B_-S5iN5o&t=751s
         //https://www.youtube.com/watch?v=nsChcl2fvps
         //https://developer.apple.com/documentation/coremotion/getting_raw_gyroscope_events
        motionManager.gyroUpdateInterval = 0.5
        motionManager.startGyroUpdates(to: OperationQueue.current!) {
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
                 
         let getvaluesGyro = GyroStrctPothole(GyroStrctPothole_x: trueData.rotationRate.x
                                            , GyroStrctPothole_y: trueData.rotationRate.y
                                            , GyroStrctPothole_z: trueData.rotationRate.z)
                    completionHandler(getvaluesGyro,nil)
                }
               else if error != nil {
                completionHandler(nil,error)
            } } }
    
    @objc func saveData() {
        motionUpdateTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0), target: self, selector: #selector(GetMotionData), userInfo: nil, repeats: true)
          let batteryLevelValue = BattraryLevelFunc(batteryLevelValue: Float(battaryValue))

        let NewRecordedData = PotholeRecord(_partition: ""
                                         , TimerValue: Float(counter)
                                         , LatitudeValue: self.LatValue
                                         , LonguiteValue: self.LonValue
                                         , AccXValue: getAccDataPothole.AccelStrctPothole_x ?? 0
                                         , AccYValue: getAccDataPothole.AccelStrctPothole_y ?? 0
                                         , AccZValue: getAccDataPothole.AccelStrctPothole_z ?? 0
                                         , GyrXValue: getGyroDataPothole.GyroStrctPothole_x ?? 0
                                         , GyrYValue: getGyroDataPothole.GyroStrctPothole_y ?? 0
                                         , GyrZValue: getGyroDataPothole.GyroStrctPothole_z ?? 0
                                         , SpeedValue: self.SpeedValue
                                         , BattaryValue: Int(batteryLevelValue)
                                         , DamageTypeValue: self.damageType
                                         , PotholeOrNot: self.HerePothole)
        if(self.HerePothole == 1){
            self.HerePothole = 0
            print("Value P changed to 0",self.HerePothole)
        }
         print("Data To Save:",NewRecordedData)
     }
    
    @objc func GetMotionData() {
        myAccelerometer { [self] (accData, error) in
            getAccDataPothole.AccelStrctPothole_x = accData?.AccelStrctPothole_x
            getAccDataPothole.AccelStrctPothole_y = accData?.AccelStrctPothole_y
            getAccDataPothole.AccelStrctPothole_z = accData?.AccelStrctPothole_z
         }
        myGyroscope { [self] (GyroData, error) in
            getGyroDataPothole.GyroStrctPothole_x = GyroData?.GyroStrctPothole_x
            getGyroDataPothole.GyroStrctPothole_y = GyroData?.GyroStrctPothole_y
            getGyroDataPothole.GyroStrctPothole_z = GyroData?.GyroStrctPothole_z
         } }
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
    
         override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning() // Dispose of any resources that can be recreated.
         }

    @IBAction func menuBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuRightVC = storyboard.instantiateViewController(withIdentifier: "aa") as! UISideMenuNavigationController
        
        SideMenuManager.default.menuRightNavigationController = menuRightVC
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
        
    }
    //https://www.dev2qa.com/ios-add-click-event-to-uibutton-swift-example/
    @IBAction func PhotholeBt(_ sender: Any){

        self.PotholePressed = true
 
        if (self.PotholePressed == true)
          {
            self.HerePothole = 1
            print("i'm changedd:)",self.HerePothole)
            self.PotholePressed = false
            }
     }
    
    
    @objc func UpdateTimer() {
        counter = counter + 0.1
        timeTravel.text = String(format: "%.1f", counter)
    }
    
    //*************** BACK To FORM ****************//
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true) }
    
    //*************** START RECORD POTHOLE *************//
    
    @IBAction func startRecordBtn(_ sender: Any) {
        startView.isHidden = true
        endView.isHidden = false
        backView.isHidden = true
        hofrahView.isHidden = false
        
        if(isPlaying) {
            return
        }
       // (sender as AnyObject).isEnabled = false
       // StopRecordButton.isEnabled = true
     //   btn.addTarget(self, action: #selector(self.PhotholeBt(_:)), for: .touchUpInside)

        locationHandle()
       UIUpdateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
         let writesinmilis = (1000 /  5) / 1000
       Savingtimer = Timer.scheduledTimer(timeInterval: TimeInterval(writesinmilis), target: self, selector: #selector(saveData), userInfo: nil, repeats: true)

   //     timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        isPlaying = true
        // Ask for Authorisation from the User.
        //    self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        // let batteryLevelValue = BattraryLevelFunc(batteryLevelValue: Float(batteryLevel))*100
       // print("Hellooo",TimerValue,SpeedValue,LatValue,LonValue,AccXValue,AccYValue,AccZValue,GyrXValue,GyrYValue,GyrZValue,Int(batteryLevelValue))
                 
        
    }
   // https://stackoverflow.com/questions/37392170/how-to-disable-enable-location-in-swift
    //*************** END RECORD POTHOLE *************//
 
    
    @IBAction func endBtn(_ sender: Any) {
    
        print("IT'S TIME TO STOP POTHOLE")
        let controller:SavePopUpVC  = AppDelegate.storyboard.instanceVC()
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
        
        isPlaying = false
        
        UIUpdateTimer.invalidate()
        Savingtimer.invalidate()
        motionUpdateTimer.invalidate()
        
         locationManager.delegate = nil
         updatingLocation = false
        locationManager.stopUpdatingLocation()
        motionManager.stopDeviceMotionUpdates()
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopMagnetometerUpdates()
         locationManager.stopMonitoringSignificantLocationChanges()
         locationManager.allowsBackgroundLocationUpdates = false
         locationManager.pausesLocationUpdatesAutomatically = true
        
        
        
        // SartRecordButton.isEnabled = true
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
extension HofraVC: popUpSave  {
    func reloadSave(reloaded: Bool) {
        if reloaded {
            //            getAllMyList()
        }
    }
}

extension HofraVC{
    
     private func mylocationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        PotholeMap.setRegion(region, animated: true)
    }
}
 
extension Double {
        /// Rounds the double to decimal places value
        func Rounded(toplaces places: Int) -> Double {
            return Double(Int((pow(10, Double(places)) * self).rounded())) / pow(10, Double(places))
            }
}
 
