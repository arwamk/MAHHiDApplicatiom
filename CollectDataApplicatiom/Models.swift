//
//  Models.swift
//  CollectDataApplicatiom
//
//  Created by public on 2/19/21.
//  Copyright © 2021 ArwaKomo. All rights reserved.
//
import Foundation
import RealmSwift
/*
typealias ProjectId = String
//Connection[1]: Session[1]:
   client_reset_config = false
 , Realm exists = true
 , async open = false
 , client reset = false
class Project: EmbeddedObject {
    @objc dynamic var name: String? = nil
    @objc dynamic var partition: String? = nil
    convenience init(partition: String, name: String) {
        self.init()
        self.partition = partition
        self.name = name
    }
}

class User: Object {
    @objc dynamic var _id: String = ""
    @objc dynamic var _partition: String = ""
    @objc dynamic var name: String = ""
  //  let memberOf = RealmSwift.List<Project>()
    override static func primaryKey() -> String? {
        return "_id"
    }
}
*/
/*
enum TaskStatus: String {
case Open
case InProgress
case Complete
}
// QsTask is the Task model for this QuickStart
class QsTask: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    // When configuring Sync, we selected `_partition` as the partition key.
    // A partition key is only required if you are using Sync.
    @objc dynamic var _partition: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var owner: String? = nil
    @objc dynamic var status: String = ""
    override static func primaryKey() -> String? {
        return "_id"
    }

    convenience init(partition: String, name: String) {
        self.init()
        self._partition = partition;
        self.name = name;
    }
}
*/


 
class DataRecord: Object {
    @objc dynamic var _id: String = ""
    @objc dynamic var _partition: String = ""
    @objc dynamic var TimerValue: Float = 0.0
    @objc dynamic var LatitudeValue: Double = 0.0
    @objc dynamic var LonguiteValue: Double = 0.0
    @objc dynamic var AccXValue: Double = 0.0
    @objc dynamic var AccYValue: Double = 0.0
    @objc dynamic var AccZValue: Double = 0.0
    @objc dynamic var GyrXValue: Double = 0.0
    @objc dynamic var GyrYValue: Double = 0.0
    @objc dynamic var GyrZValue: Double = 0.0
    @objc dynamic var BattaryValue: Int = 0
    @objc dynamic var SpeedValue: Double = 0.0
    let ResultList = List<ResultDataRoadRecord>()
   // let userrecorddata = LinkingObjects(fromType: UserRecord.self, property: "listrecord")

     override static func primaryKey() -> String? {
        return "_id"
    }
    convenience init(_partition: String
                     , TimerValue: Float
                     , LatitudeValue: Double
                     , LonguiteValue: Double
                     , AccXValue: Double
                     , AccYValue: Double
                     , AccZValue: Double
                     , GyrXValue: Double
                     , GyrYValue: Double
                     , GyrZValue: Double
                     , BattaryValue: Int
                     , SpeedValue: Double)
    {
        self.init()
        self._partition = _partition;
        self.TimerValue = TimerValue;
        self.LatitudeValue = LatitudeValue;
        self.LonguiteValue = LonguiteValue;
        self.AccXValue = AccXValue;
        self.AccYValue = AccYValue;
        self.AccZValue = AccZValue;
        self.GyrXValue = GyrXValue;
        self.GyrYValue = GyrYValue;
        self.GyrZValue = GyrZValue;
        self.BattaryValue = BattaryValue;
  }
}

class ResultDataRoadRecord: Object {
    @objc dynamic var _id: String = ""
    @objc dynamic var _partition: String = ""
    @objc dynamic var TimerValue: Float = 0.0
    @objc dynamic var LatitudeValue: Double = 0.0
    @objc dynamic var LonguiteValue: Double = 0.0
    @objc dynamic var DamageTypeValue: String = ""
 
     // @objc dynamic var Potholeornot: Int = 0
  let resultdetectlist = LinkingObjects(fromType: DataRecord.self, property: "ResultList")
      override static func primaryKey() -> String? {
        return "_id"
    }
    convenience init(_partition: String
                     , TimerValue: Float
                     , LatitudeValue: Double
                     , LonguiteValue: Double
                     , DamageTypeValue: String )
    {
        self.init()
        self._partition = _partition;
        self.TimerValue = TimerValue;
        self.LatitudeValue = LatitudeValue;
        self.LonguiteValue = LonguiteValue;
        self.DamageTypeValue = DamageTypeValue;
  }
}

class ResultDataPotholeRecord: Object {
    @objc dynamic var _id: String = ""
    @objc dynamic var _partition: String = ""
    @objc dynamic var TimerValue: Float = 0.0
    @objc dynamic var LatitudeValue: [Double] = [0.0]
    @objc dynamic var LonguiteValue: [Double] = [0.0]
    @objc dynamic var DamageTypeValue: String = ""
 
     // @objc dynamic var Potholeornot: Int = 0
  let resultdetectlist = LinkingObjects(fromType: DataRecord.self, property: "ResultList")
      override static func primaryKey() -> String? {
        return "_id"
    }
    convenience init(_partition: String
                     , TimerValue: Float
                     , LatitudeValue: Double
                     , LonguiteValue: Double
                     , DamageTypeValue: String )
    {
        self.init()
        self._partition = _partition;
        self.TimerValue = TimerValue;
        self.LatitudeValue = [LatitudeValue];
        self.LonguiteValue = [LonguiteValue];
        self.DamageTypeValue = DamageTypeValue;
  }
}

 class UserRecord: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    // When configuring Sync, we selected `_partition` as the partition key.
    // A partition key is only required if you are using Sync.
    @objc dynamic var _partition: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var region: String? = nil
    @objc dynamic var MobileSoftware: Double = 0.0
    @objc dynamic var CarType: String = ""
    @objc dynamic var CarModel: String = ""
    @objc dynamic var DamageType: String = ""
    @objc dynamic var mobileType : String = ""
    @objc dynamic var NumberOfRecords: String = ""
    let listrecord1 = List<PotholeRecord>()
    let listrecord2 = List<RoadRecord>()

    override static func primaryKey() -> String? {
        return "_id"
    }
     
    convenience init(_partition: String
                     , name: String
                     , region: String
                     , mobileType: String
                     , MobileSoftware: Double
                     , CarType: String
                     , CarModel: String
                     , NumberOfRecords: String
                     , DamageType: String)
    {
        self.init()
        self._partition = _partition;
        self.name = name;
        self.region = region;
        self.mobileType = mobileType;
        self.MobileSoftware = MobileSoftware;
        self.CarType = CarType;
        self.CarModel = CarModel;
        self.NumberOfRecords = NumberOfRecords;
        self.DamageType = DamageType;
  }
}
 
class PotholeRecord: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition: String = ""
    @objc dynamic var TimerValue: Float = 0.0
    @objc dynamic var LatitudeValue: Double = 0.0
    @objc dynamic var LonguiteValue: Double = 0.0
    @objc dynamic var AccXValue: Double = 0.0
    @objc dynamic var AccYValue: Double = 0.0
    @objc dynamic var AccZValue: Double = 0.0
    @objc dynamic var GyrXValue: Double = 0.0
    @objc dynamic var GyrYValue: Double = 0.0
    @objc dynamic var GyrZValue: Double = 0.0
    @objc dynamic var SpeedValue: Double = 0.0
    @objc dynamic var BattaryValue: Int = 0
    @objc dynamic var DamageTypeValue: String = "Pothole"
    @objc dynamic var PotholeOrNot: Int = 0

    let userrecorddata = LinkingObjects(fromType: UserRecord.self, property: "listrecord1")

     override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(_partition: String
                     , TimerValue: Float
                     , LatitudeValue: Double
                     , LonguiteValue: Double
                     , AccXValue: Double
                     , AccYValue: Double
                     , AccZValue: Double
                     , GyrXValue: Double
                     , GyrYValue: Double
                     , GyrZValue: Double
                     , SpeedValue: Double
                     , BattaryValue: Int
                     , DamageTypeValue: String
                     , PotholeOrNot: Int)
    {
        self.init()
        self._partition = _partition;
        self.TimerValue = TimerValue;
        self.LatitudeValue = LatitudeValue;
        self.LonguiteValue = LonguiteValue;
        self.AccXValue = AccXValue;
        self.AccYValue = AccYValue;
        self.AccZValue = AccZValue;
        self.GyrXValue = GyrXValue;
        self.GyrYValue = GyrYValue;
        self.GyrZValue = GyrZValue;
        self.SpeedValue = SpeedValue
        self.BattaryValue = BattaryValue;
        self.DamageTypeValue = DamageTypeValue;
        self.PotholeOrNot = PotholeOrNot;
   }
}
 

 
class RoadRecord: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition: String = ""
    @objc dynamic var TimerValue: Float = 0.0
    @objc dynamic var LatitudeValue: Double = 0.0
    @objc dynamic var LonguiteValue: Double = 0.0
    @objc dynamic var AccXValue: Double = 0.0
    @objc dynamic var AccYValue: Double = 0.0
    @objc dynamic var AccZValue: Double = 0.0
    @objc dynamic var GyrXValue: Double = 0.0
    @objc dynamic var GyrYValue: Double = 0.0
    @objc dynamic var GyrZValue: Double = 0.0
    @objc dynamic var SpeedValue: Double = 0.0
    @objc dynamic var BattaryValue: Int = 0
    @objc dynamic var DamageTypeValue: String = "Road"
   // @objc dynamic var Potholeornot: Int = 0

    let userrecorddata = LinkingObjects(fromType: UserRecord.self, property: "listrecord2")

     override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(_partition: String
                     , TimerValue: Float
                     , LatitudeValue: Double
                     , LonguiteValue: Double
                     , AccXValue: Double
                     , AccYValue: Double
                     , AccZValue: Double
                     , GyrXValue: Double
                     , GyrYValue: Double
                     , GyrZValue: Double
                     , SpeedValue: Double
                     , BattaryValue: Int
                     , DamageTypeValue: String)
    {
        self.init()
        self._partition = _partition;
        self.TimerValue = TimerValue;
        self.LatitudeValue = LatitudeValue;
        self.LonguiteValue = LonguiteValue;
        self.AccXValue = AccXValue;
        self.AccYValue = AccYValue;
        self.AccZValue = AccZValue;
        self.GyrXValue = GyrXValue;
        self.GyrYValue = GyrYValue;
        self.GyrZValue = GyrZValue;
        self.SpeedValue = SpeedValue
        self.BattaryValue = BattaryValue;
        self.DamageTypeValue = DamageTypeValue;

 }
}
 
