//
//  DoneDeleteVC.swift
//  CollectDataApplicatiom
//
//  Created by MacBook Pro on 11/27/20.
//  Copyright © 2020 ArwaKomo. All rights reserved.
//

import UIKit
import SideMenu
class DoneDeleteVC: UIViewController {
    @IBOutlet weak var viewToRound: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewToRound.layer.cornerRadius = 70
        viewToRound.layer.masksToBounds = true
        viewToRound.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuRightVC = storyboard.instantiateViewController(withIdentifier: "aa") as! UISideMenuNavigationController
        
        SideMenuManager.default.menuRightNavigationController = menuRightVC
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
        
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
