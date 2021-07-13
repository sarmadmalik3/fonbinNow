//
//  VC_SignUp_User.swift
//  Business Search Solution
//
//  Created by Sarmad Ashfaq on 1/10/1399 AP.
//  Copyright © 1399 Softgear. All rights reserved.
//

import UIKit

class VC_SignUp_User: UIViewController {
    
    var isChecked : Bool = true
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtConfrimPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtName: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtPhone.borderStyle = .none
        txtEmail.borderStyle = .none
        txtPassword.borderStyle = .none
        txtConfrimPassword.borderStyle = .none
        txtName.borderStyle = .none
        txtName.dropTextFeildCardView()
        txtPhone.dropTextFeildCardView()
        txtConfrimPassword.dropTextFeildCardView()
        txtPassword.dropTextFeildCardView()
        txtEmail.dropTextFeildCardView()
        btnSignUp.makeRound(cornerRadius: 20)
        txtPhone.setLeftPaddingPoints(55)
        txtConfrimPassword.setLeftPaddingPoints(55)
        txtPassword.setLeftPaddingPoints(55)
        txtEmail.setLeftPaddingPoints(55)
        txtName.setLeftPaddingPoints(55)
        txtEmail.changePlaceHolder(PlaceHoldertxt: "Email Address", Color: .Primary_Blue)
        txtPassword.changePlaceHolder(PlaceHoldertxt: "Password", Color: .Primary_Blue)
        txtConfrimPassword.changePlaceHolder(PlaceHoldertxt: "Confirm Password", Color: .Primary_Blue)
        txtPhone.changePlaceHolder(PlaceHoldertxt: "Phone", Color: .Primary_Blue)
        txtName.changePlaceHolder(PlaceHoldertxt: "Name / Company", Color: .Primary_Blue)
        btnCheck.setImage(UIImage(named: "unSelected"), for: .normal)

    }
    
    
    @IBAction func checkButton(_ sender: Any) {
        if isChecked {
            btnCheck.setImage(UIImage(named: "selected"), for: .normal)
            print("Selected")
        }else{
            btnCheck.setImage(UIImage(named: "unSelected"), for: .normal)
            print("Unselected")
        }
      isChecked = !isChecked
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {

createUser()
        
    }
    
    func createUser(){
        if txtName.text == "" {
            showAlertView(message: "Enter your Name/Company", title: "Alert")
            return
        }
        if txtEmail.text == ""{
            showAlertView(message: "Enter your email", title: "Alert")
            return
        }
        if txtPhone.text == "" {
            showAlertView(message: "Enter your Phone Number", title: "Alert")
            return
        }
        if txtPassword.text == "" {
            showAlertView(message: "Enter your password", title: "Alert")
            return
        }
        if txtConfrimPassword.text == "" {
            showAlertView(message: "Enter your confirm password", title: "Alert")
            return
        }
        if txtPassword.text != txtConfrimPassword.text {
            showAlertView(message: "Confirm password does not match", title: "Alert")
            return
        }
        showLoadingView()
        ApiManager.shared.createUser(txtEmail.text!, txtPassword.text!, txtPhone.text!, txtName.text!) {[weak self] user, error in
            self?.hideLoadingView()
            if let user = user {
                user.sendEmailVerification(completion: nil)
                self?.showAlertWithSingleButton("Attention", "We have sent a verification link to your email address please check and verify your email address", completion: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                })
            }
            if let error = error {
                self?.showAlertView(message: error, title: "Alert")
                self?.showAlertWithSingleButton("Alert", error, completion: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                })
            }
            
        }
        
    }
}
