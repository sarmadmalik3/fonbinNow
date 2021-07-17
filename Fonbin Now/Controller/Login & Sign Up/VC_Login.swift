//
//  VC_Login.swift
//  Business Search Solution
//
//  Created by Sarmad Ashfaq on 1/10/1399 AP.
//  Copyright © 1399 Softgear. All rights reserved.
//

import UIKit


class VC_Login: UIViewController {
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.borderStyle = .none
        txtPassword.borderStyle = .none
        txtPassword.dropTextFeildCardView()
        txtEmail.dropTextFeildCardView()
        txtEmail.setLeftPaddingPoints(55)
        txtEmail.changePlaceHolder(PlaceHoldertxt: "Email Address", Color: UIColor.Primary_Blue)
        txtPassword.changePlaceHolder(PlaceHoldertxt: "Password", Color: .Primary_Blue)
        txtPassword.setLeftPaddingPoints(55)
        btnSignIn.makeRound(cornerRadius: 20)
        navigationController?.navigationBar.isHidden = false
        DesignNavBar()
        DesignStatusBar()
        UserDefaults.standard.set("hello", forKey: "AppFirstOpened")
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

    @IBAction func SignIn(_ sender: Any) {

        if txtEmail.text == ""{
            showAlertView(message: "Enter your email", title: "Alert")
            return
        }
        if txtPassword.text == "" {
            showAlertView(message: "Enter your password", title: "Alert")
            return
        }
        
        login()
    }
    
    @IBAction func SignUp(_ sender: Any) {
        openVC("VC_SignUp_User")
    }
    @IBAction func ForgotPassword(_ sender: Any) {
        openVC("VC_Forgot")
    }
    
    
    
    func login(){
        showLoadingView()
        ApiManager.shared.signIn(txtEmail.text ?? "", txtPassword.text ?? "") { [weak self] user, error in
            
            if let user = user {
                self?.hideLoadingView()
                if !user.isEmailVerified {
                    self?.showAlert("Attention",  String(format: "%@ %@", "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to" , user.email!)) {
                        user.sendEmailVerification(completion: nil)
                        return
                    }
                }else{

                    ApiManager.shared.getUserProfile {
                        self?.hideLoadingView()
                        self!.openVC("Dashboard")
                    }
                }
            }
            if let _ = error {
                self?.hideLoadingView()
                self?.showAlertView(message: "Email or Password is incorrect", title: "Alert")
            }
        }
    }
}
