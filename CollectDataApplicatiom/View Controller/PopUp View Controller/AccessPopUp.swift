//
//  AccessPopUp.swift
//  CollectDataApplicatiom
//
//  Created by MacBook Pro on 11/27/20.
//  Copyright © 2020 ArwaKomo. All rights reserved.
//

import UIKit
import Presentr

protocol popUpAccessSec {
    func reloadAccess(reloaded: Bool)
}
class AccessPopUp: UIViewController {
    var delegate: popUpDelSec?
    lazy var presenter: Presentr = { [unowned self] in
        let temp = Presentr(presentationType: .fullScreen)
        temp.backgroundColor = UIColor.black
        temp.dismissOnSwipe = false
        return temp
        }()
    var temp:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func dissmissBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func YesBtn(_ sender: Any) {
      
        self.dismiss(animated: true) {
            print(self.temp ?? "")
    
            self.dismiss(animated: true, completion: nil)
        }
        
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
