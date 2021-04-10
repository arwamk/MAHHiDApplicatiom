//
//  Record.swift
//  CollectDataApplicatiom
//
//  Created by public on 2/4/21.
//  Copyright © 2021 ArwaKomo. All rights reserved.
//

import Foundation

struct Record{
    
    let AccXTest: Double?
    let AccYTest: Double?
    let AccZTest: Double?
     
    
     init(AccXTest: Double, AccYTest: Double, AccZTest: Double) {
      self.AccXTest = AccXTest
      self.AccYTest = AccYTest
      self.AccZTest = AccZTest
       }
    /*
    var RecordArray = [AnyObject]()
    let RecordFile = Record() // car is a class name
    RecordFile.brandName = "Ford"
    RecordFile.modelName = "Mustang" // string type
    RecordFile.modelYear = 1968
    RecordFile.isConvertibible = true
    RecordFile.isHatchback = false
    RecordArray.hasSunroof = false // bool type
    RecordArray.numberOfDoors = 2 // int type
    RecordArray.powerSource = "gas engine"
    RecordArray.append(RecordFile)

    */
    
    
    
    
}
