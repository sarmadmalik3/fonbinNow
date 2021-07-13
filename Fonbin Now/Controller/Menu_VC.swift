//
//  Menu_VC.swift
//  Personal Finance Management
//
//  Created by Sarmad Ishfaq on 21/08/2019.
//  Copyright © 2019 circularbyte. All rights reserved.
//

import UIKit


class Menu_VC: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    var gold : Bool!
    var titles = ["Terms and Conditions" , "Support" ,"Contact Us" , "Log out"]
    var imageName = ["support" , "term" ,"contactus" ,"logout"]
    var arrayAbout = [About]()
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        fillAboutArray()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        menuTableView.tableFooterView = UIView()
        if let user = DataManager().getUserData() {
            lblName.text = user.name
        }
    }
    //MARK:- View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        menuTableView.reloadData()
    }
    
    
    // MARK:- Tabel View
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return titles.count
            
  
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3 {
            
            showAlertWithDobuleButton("Alert", "Are you sure you want to logout?") { [weak self] in
                DataManager().removeUserData()
                self?.openVC("VC_Login")
            }
            
        }
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 {
            if let url = URL(string: "http://fonbin.com/page/indexPage/TermAndCondition") {
                UIApplication.shared.open(url)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            return 80
        }
        else{
            return 50
        }
    
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Menu_TableViewCell", for: indexPath) as! Menu_TableViewCell
                cell.lblStone.text  = titles[indexPath.row]
            cell.imgLogo.image = UIImage(named: imageName[indexPath.row])?.withTintColor(.white)
            return cell
            
        }else{
          
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutUsTableViewCell", for: indexPath) as! AboutUsTableViewCell
            cell.lblname.text = arrayAbout[indexPath.row].Tittle
            //cell.imgLogo.image = UIImage(named: arrayAbout[indexPath.row].Image)
                
     
           return cell
        }
    }//cellForRowAt()
    
    // MARK:- Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    
        
    }//prepare
    //MARK:- Fill About US Array
    func fillAboutArray(){
        
        let a1 = About(image: "Facebook",  tittle:  "Facebook")
        let a2 = About(image: "Instagram", tittle: "Instagram")
        let a3 = About(image: "Website",   tittle:   "Website")
        
        arrayAbout.append(a1)
        arrayAbout.append(a2)
        arrayAbout.append(a3)
        
    }
}//Class

class About{
    var Tittle : String = ""
    var Image : String = ""
    init(image : String , tittle : String) {
        self.Image = image
        self.Tittle = tittle
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
