//
//  DetectPopUpVC.swift
//  CollectDataApplicatiom
//
//  Created by public on 3/31/21.
//  Copyright © 2021 ArwaKomo. All rights reserved.
//

import UIKit
import Presentr

protocol popUpDetect {
    func reloadMor(reloaded: Bool)
}
class DetectPopUpVC: UIViewController {
    var delegate: popUpDetect?
      lazy var presenter: Presentr = { [unowned self] in
          let temp = Presentr(presentationType: .fullScreen)
          temp.backgroundColor = UIColor.black
          temp.dismissOnSwipe = false
          return temp
          }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func stopDetectionBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
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
