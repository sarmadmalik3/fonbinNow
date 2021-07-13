//
//  VC_Forgot.swift
//  Business Search Solution
//
//  Created by Sarmad Ashfaq on 1/12/1399 AP.
//  Copyright © 1399 Softgear. All rights reserved.
//

import UIKit
import FirebaseAuth

class VC_Forgot: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnContinue.makeRound(cornerRadius: 20)

    }
    override func viewWillAppear(_ animated: Bool) {
        DesignStatusBar()
        DesignNavBar()
    }

    func DesignStatusBar(){
         let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
         let statusBarColor = UIColor.white
         statusBarView.backgroundColor = statusBarColor
         view.addSubview(statusBarView)
     }
     func DesignNavBar(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
     }
    @IBAction func `continue`(_ sender: Any) {
        showLoadingView()
        Auth.auth().sendPasswordReset(withEmail: txtEmail.text ?? "") { [weak self] error in
            self?.hideLoadingView()
            if let error = error {
                self?.showAlertView(message: error.localizedDescription, title: "Alert")
            }else{
                self?.showAlertWithSingleButton("Attention", "A rest password link has been sent to \(self!.txtEmail.text!)", completion: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    

    @IBAction func signUp(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
