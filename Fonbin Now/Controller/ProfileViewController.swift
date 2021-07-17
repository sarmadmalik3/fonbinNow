//
//  ProfileViewController.swift
//  Business Search Solution
//
//  Created by Sarmad Ishfaq on 14/06/2021.
//  Copyright © 2021 Softgear. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var tvBio: UITextView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnUpdate: UIButton!
    var localUser : localUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.borderStyle = .none
        txtName.dropTextFeildCardView()
        txtName.setLeftPaddingPoints(55)
        txtName.changePlaceHolder(PlaceHoldertxt: "Name / Company name", Color: UIColor.Primary_Blue)
        btnUpdate.makeRound(cornerRadius: 20)
        
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.borderColor = UIColor.black.cgColor
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.makeCircle()
        navigationItem.title = "Profile"
        populateData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image in
            self?.imgProfile.image = image
        }
    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        if tvBio.text == "" {
            showAlertView(message: "Enter Bio", title: "Alert")
            return
        }
        if txtName.text == "" {
            showAlertView(message: "Enter Name", title: "Alert")
            return
        }
        updateProfile()
    }
    
    func populateData(){
        localUser = DataManager().getUserData()
        if let data = localUser {
            imgProfile.downloadImage(url: data.imageUrl)
            txtName.text = data.name
            tvBio.text = data.bio
        }
        
    }
    
    func updateProfile(){
        showLoadingView()
        ApiManager.shared.uploadMedia(image: imgProfile.image!) { [weak self] imageUrl in
            if let image = imageUrl {
                
                ApiManager.shared.updateProfile(image, self!.tvBio.text, self!.txtName.text!) { message, error in
                    self?.hideLoadingView()
                    if let message = message {
                        self?.showAlertWithSingleButton("Success", message, completion: {
                            self?.showLoadingView()
                            ApiManager.shared.getUserProfile { [weak self] in
                                self?.hideLoadingView()
                                self?.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                }
            }else{
                self?.hideLoadingView()
                self?.showAlertView(message: "Profile update Failed", title: "Alert")
            }
        }
    }
}
