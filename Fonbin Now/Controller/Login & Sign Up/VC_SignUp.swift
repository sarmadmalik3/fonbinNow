//
//  VC_SignUp.swift
//  Business Search Solution
//
//  Created by Sarmad Ashfaq on 1/10/1399 AP.
//  Copyright © 1399 Softgear. All rights reserved.
//

import UIKit

class VC_SignUp: UIViewController {

    
    var isChecked : Bool = true
    
    
    @IBOutlet weak var btnChecked: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfrim_Password: UITextField!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtBussinesNo: UITextField!
    @IBOutlet weak var txtCompanyCat: UITextField!
    @IBOutlet weak var txtEmployeRange: UITextField!
    @IBOutlet weak var txtFoundedDate: UITextField!
    @IBOutlet weak var txtTags: UITextField!
    @IBOutlet weak var txtLinkedInURL: UITextField!
    @IBOutlet weak var txtTwitterURL: UITextField!
    @IBOutlet weak var txtFacebookURL: UITextField!
    @IBOutlet weak var txtCompanyOperationalAddress: UITextField!
    @IBOutlet weak var txtTown_City: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry_Region: UITextField!
    @IBOutlet weak var txtFounders: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var btnSkipForKnow: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnUploadMedia: UIButton!
    @IBOutlet weak var viewTV: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        designTextFeilds()
        DesignStatusBar()
        DesignNavBar()
        btnUploadMedia.makeRound(cornerRadius: 20)
        btnSignUp.makeRound(cornerRadius: 20)
        btnSkipForKnow.makeRound(cornerRadius: 10)
    }
    func DesignStatusBar(){
         let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
         let statusBarColor = UIColor.white
         statusBarView.backgroundColor = statusBarColor
         view.addSubview(statusBarView)
     }
     func DesignNavBar(){
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
         self.navigationController?.navigationBar.backgroundColor = UIColor.white
         self.navigationController?.navigationBar.shadowImage = UIImage()
         self.navigationController?.navigationBar.layoutIfNeeded()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
     }
    func designTextFeilds(){
        viewTV.dropTextFeildCardView()
        txtEmail.borderStyle = .none
        txtPassword.borderStyle = .none
        txtConfrim_Password.borderStyle = .none
        txtCompanyName.borderStyle = .none
        txtPhone.borderStyle = .none
        txtBussinesNo.borderStyle = .none
        txtCompanyCat.borderStyle = .none
        txtEmployeRange.borderStyle = .none
        txtFoundedDate.borderStyle = .none
        txtTags.borderStyle = .none
        txtLinkedInURL.borderStyle = .none
        txtTwitterURL.borderStyle = .none
        txtFacebookURL.borderStyle = .none
        txtCompanyOperationalAddress.borderStyle = .none
        txtTown_City.borderStyle = .none
        txtState.borderStyle = .none
        txtCountry_Region.borderStyle = .none
        txtFounders.borderStyle = .none
        
        txtFounders.dropTextFeildCardView()
        txtEmail.dropTextFeildCardView()
        txtPassword.dropTextFeildCardView()
        txtConfrim_Password.dropTextFeildCardView()
        txtCompanyName.dropTextFeildCardView()
        txtPhone.dropTextFeildCardView()
        txtBussinesNo.dropTextFeildCardView()
        txtCompanyCat.dropTextFeildCardView()
        txtEmployeRange.dropTextFeildCardView()
        txtFoundedDate.dropTextFeildCardView()
        txtTags.dropTextFeildCardView()
        txtLinkedInURL.dropTextFeildCardView()
        txtTwitterURL.dropTextFeildCardView()
        txtFacebookURL.dropTextFeildCardView()
        txtCompanyOperationalAddress.dropTextFeildCardView()
        txtTown_City.dropTextFeildCardView()
        txtState.dropTextFeildCardView()
        txtCountry_Region.dropTextFeildCardView()
        
        txtFounders.setLeftPaddingPoints(55)
        txtEmail.setLeftPaddingPoints(55)
        txtPassword.setLeftPaddingPoints(55)
        txtConfrim_Password.setLeftPaddingPoints(55)
        txtCompanyName.setLeftPaddingPoints(55)
        txtPhone.setLeftPaddingPoints(55)
        txtBussinesNo.setLeftPaddingPoints(55)
        txtCompanyCat.setLeftPaddingPoints(55)
        txtEmployeRange.setLeftPaddingPoints(55)
        txtFoundedDate.setLeftPaddingPoints(55)
        txtTags.setLeftPaddingPoints(55)
        txtLinkedInURL.setLeftPaddingPoints(55)
        txtTwitterURL.setLeftPaddingPoints(55)
        txtFacebookURL.setLeftPaddingPoints(55)
        txtCompanyOperationalAddress.setLeftPaddingPoints(55)
        txtTown_City.setLeftPaddingPoints(55)
        txtState.setLeftPaddingPoints(55)
        txtCountry_Region.setLeftPaddingPoints(55)
        
        txtEmail.changePlaceHolder(PlaceHoldertxt: "Email Address", Color: .Primary_Blue)
        txtPassword.changePlaceHolder(PlaceHoldertxt: "Password", Color: .Primary_Blue)
        txtConfrim_Password.changePlaceHolder(PlaceHoldertxt: "Confirm Password", Color: .Primary_Blue)
        txtCompanyName.changePlaceHolder(PlaceHoldertxt: "Company Name", Color: .Primary_Blue)
        txtPhone.changePlaceHolder(PlaceHoldertxt: "Phone", Color: .Primary_Blue)
        txtBussinesNo.changePlaceHolder(PlaceHoldertxt: "Business No", Color: .Primary_Blue)
        txtCompanyCat.changePlaceHolder(PlaceHoldertxt: "Company Category", Color: .Primary_Blue)
        txtEmployeRange.changePlaceHolder(PlaceHoldertxt: "Employee Range", Color: .Primary_Blue)
        txtFoundedDate.changePlaceHolder(PlaceHoldertxt: "Founded Date", Color: .Primary_Blue)
        txtFounders.changePlaceHolder(PlaceHoldertxt: "Founders", Color: .Primary_Blue)
        txtTags.changePlaceHolder(PlaceHoldertxt: "Tags", Color: .Primary_Blue)
        txtLinkedInURL.changePlaceHolder(PlaceHoldertxt: "Linked In Url", Color: .Primary_Blue)
        txtTwitterURL.changePlaceHolder(PlaceHoldertxt: "Twitter Url", Color: .Primary_Blue)
        txtFacebookURL.changePlaceHolder(PlaceHoldertxt: "Facebook Url", Color: .Primary_Blue)
        txtCompanyOperationalAddress.changePlaceHolder(PlaceHoldertxt: "Company Operational Address", Color: .Primary_Blue)
        txtTown_City.changePlaceHolder(PlaceHoldertxt: "Town/City", Color: .Primary_Blue)
        txtState.changePlaceHolder(PlaceHoldertxt: "State", Color: .Primary_Blue)
        txtCountry_Region.changePlaceHolder(PlaceHoldertxt: "Country/Region", Color: .Primary_Blue)
        btnChecked.setImage(UIImage(named: "unSelected"), for: .normal)
    }

    @IBAction func login(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func CheckButton(_ sender: Any) {
          if isChecked {
              btnChecked.setImage(UIImage(named: "selected"), for: .normal)
              print("Selected")
          }else{
              btnChecked.setImage(UIImage(named: "unSelected"), for: .normal)
              print("Unselected")
          }
        isChecked = !isChecked
    }
    
}
