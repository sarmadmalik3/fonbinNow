//
//  VC_VerifyEmail.swift
//  Business Search Solution
//
//  Created by Sarmad Ashfaq on 1/12/1399 AP.
//  Copyright © 1399 Softgear. All rights reserved.
//

import UIKit

class VC_VerifyEmail: UIViewController {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var bannerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.makeCircle()
       DesignStatusBar()
       DesignNavBar()
    }
    

     func DesignStatusBar(){
         let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
         let statusBarColor = UIColor.Secondary_Blue
         statusBarView.backgroundColor = statusBarColor
         view.addSubview(statusBarView)
     }
     func DesignNavBar(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
     }
    
    @IBAction func changeEmail(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
