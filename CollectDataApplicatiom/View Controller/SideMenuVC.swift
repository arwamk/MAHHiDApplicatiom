//
//  SideMenuVC.swift
//  CollectDataApplicatiom
//
//  Created by MacBook Pro on 11/27/20.
//  Copyright © 2020 ArwaKomo. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    /*  @IBAction func historyBtn(_ sender: Any) {
         /* if let vc = storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as?   HistoryVC{
              
              self.navigationController?.pushViewController(vc, animated: true)
          }*/
          if let vc = storyboard?.instantiateViewController(withIdentifier: "FormVC") as?   FormVC{
              
              self.navigationController?.pushViewController(vc, animated: true)
          }
 */
  
    @IBAction func PublicMapBtn(_ sender: Any) {
      if let vc = storyboard?.instantiateViewController(withIdentifier: "PublicMapVC") as?   PublicMapVC{
                 self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    
    @IBAction func DetectDamagesBtn(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetectDamagesVC") as?   DetectDamagesVC{
                 self.navigationController?.pushViewController(vc, animated: true)
            }
    }

    
    @IBAction func Tahseen(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FormVC") as?   FormVC{
             self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func SettingBtn(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SettingVC") as?   SettingVC{
             self.navigationController?.pushViewController(vc, animated: true)
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
