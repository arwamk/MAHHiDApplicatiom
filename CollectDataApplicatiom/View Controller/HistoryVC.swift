//
//  HistoryVC.swift
//  CollectDataApplicatiom
//
//  Created by MacBook Pro on 11/27/20.
//  Copyright © 2020 ArwaKomo. All rights reserved.
//

import UIKit
import SideMenu
import Presentr

class HistoryVC: UIViewController {
    var delegate: popUpDelSec?
    lazy var presenter: Presentr = { [unowned self] in
        let temp = Presentr(presentationType: .fullScreen)
        temp.backgroundColor = UIColor.black
        temp.dismissOnSwipe = false
        return temp
        }()
    
    var delegatee: popUpMoreSec?
      lazy var presenterer: Presentr = { [unowned self] in
          let temp = Presentr(presentationType: .fullScreen)
          temp.backgroundColor = UIColor.black
          temp.dismissOnSwipe = false
          return temp
          }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func menuBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuRightVC = storyboard.instantiateViewController(withIdentifier: "aa") as! UISideMenuNavigationController
        
        SideMenuManager.default.menuRightNavigationController = menuRightVC
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
        
        
    }
    
}
extension HistoryVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.trashBtn.tag = indexPath.row
        cell.trashBtn.addTarget(self, action: #selector(self.DeleteBtn), for: UIControl.Event.touchUpInside)
        cell.moreBtn.tag = indexPath.row
        cell.moreBtn.addTarget(self, action: #selector(self.ViewMoreBtn), for: UIControl.Event.touchUpInside)

        return cell
    }
    

    @objc func DeleteBtn(sender: UIButton){
        
        let controller:DeleteSecPopUp  = AppDelegate.storyboard.instanceVC()
        
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
        
    }
    @objc func ViewMoreBtn(sender: UIButton){
        
        let controller:MoreSecPopUp  = AppDelegate.storyboard.instanceVC()
        
        customPresentViewController(presenterer, viewController: controller, animated: true, completion: nil)
        
    }
    
}
extension HistoryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 100.0)
    }
}
extension HistoryVC: popUpDelSec  {
    func reloadDel(reloaded: Bool) {
        if reloaded {
            //            getAllMyList()
        }
    }
}
extension HistoryVC: popUpMoreSec  {
    func reloadMor(reloaded: Bool) {
        if reloaded {
            //            getAllMyList()
        }
    }
}
