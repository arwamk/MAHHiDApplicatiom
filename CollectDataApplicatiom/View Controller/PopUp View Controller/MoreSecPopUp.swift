//
//  MoreSecPopUp.swift
//  CollectDataApplicatiom
//
//  Created by MacBook Pro on 11/27/20.
//  Copyright © 2020 ArwaKomo. All rights reserved.
//

import UIKit
import Presentr

protocol popUpMoreSec {
    func reloadMor(reloaded: Bool)
}
class MoreSecPopUp: UIViewController {
    var delegate: popUpMoreSec?
      lazy var presenter: Presentr = { [unowned self] in
          let temp = Presentr(presentationType: .fullScreen)
          temp.backgroundColor = UIColor.black
          temp.dismissOnSwipe = false
          return temp
          }()
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func dissmissBtn(_ sender: Any) {
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
