//
//  SettingVC.swift
//  CollectDataApplicatiom
//
//  Created by public on 3/26/21.
//  Copyright © 2021 ArwaKomo. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import Presentr

class SettingVC: UIViewController {
    override func viewDidLoad() { super.viewDidLoad() }

    
    @IBAction func MenuBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuRightVC = storyboard.instantiateViewController(withIdentifier: "aa") as! UISideMenuNavigationController
                SideMenuManager.default.menuRightNavigationController = menuRightVC
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }
    
    
    
    
    
}
