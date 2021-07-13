//
//  ApiManager.swift
//  Fonbin Now
//
//  Created by Sarmad Ishfaq on 30/06/2021.
//

import Foundation
import FirebaseStorage
import Firebase
import Alamofire
import UIKit


class ApiManager {
    
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    static let shared = ApiManager()
    
    
    func signIn(_ email: String , _ password: String , completion: @escaping(_ user: User? , _ error: String?)->()){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if let user = user {
                self?.ref.child("user").child(user.user.uid).updateChildValues(["fcmToken" : Constant.fcmToken])
                completion(user.user , nil)
            }
            if let error = error {
                completion(nil , error.localizedDescription)
            }
        }
    }
    
    func createUser(_ email: String , _ password: String , _ phoneNo: String , _ name: String , completion: @escaping(_ user: User? , _ error: String?) -> ()){
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let user = user {
            
                self.ref.child("user").child(user.user.uid).setValue(["email" : email , "id" : user.user.uid , "mobileNo" : phoneNo , "name" : name , "password" : password, "fcmToken" : Constant.fcmToken]) { error, snapShot in
                    if error == nil {
                        completion(user.user , nil)
                    }
                }
                
            }
            if let erro = error {
                completion(nil , erro.localizedDescription)
            }
        }
        
    }
    
    
    func getUserProfile(completion: @escaping() -> ()){
        let uuid = Auth.auth().currentUser!.uid
        
        ref.child("user").child(uuid).observeSingleEvent(of: .value, with: { snapshot in
            var object = localUser()
            
            
            if let value = snapshot.value as? [String: Any] {
                print("value:\(value)")
                
                if let bioValue = value["bio"] as? String {
                    
                    object.bio = bioValue
                }
                if let name = value["name"] as? String {
                    object.name = name
                }
                if let imageURl = value["imageUrl"] as? String {
                    object.imageUrl = imageURl
                }
                object.isLoggedIn = true
                object.userId = uuid
                DataManager().saveUserData(user: object)
                completion()
            }
        })
        
    }
    
    func getStores(completion: @escaping(_ store: [locationDataModel]?) -> ()){
        ref.child("user").observe(.value) { snapshot in
            
            var store = [locationDataModel]()
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                if let value = snap.value as? [String: Any] {
                    
                    var storeObject = locationDataModel()
                    if let bio = value["bio"] as? String {
                        storeObject.bio = bio
                    }
                    if let id = value["id"] as? String {
                        storeObject.userId = id
                    }
                    if let image = value["imageUrl"] as? String {
                        storeObject.imageUrl = image
                    }
                    if let lat = value["lat"] as? Double {
                        storeObject.lat = lat
                    }
                    if let long = value["lng"] as? Double {
                        storeObject.long = long
                    }
                    if let name = value["name"] as? String {
                        storeObject.name = name
                    }
                    if let mobile = value["mobileNo"] as? String {
                        storeObject.mobileNum = mobile
                    }
                    if let isOnline = value["isOnline"] as? Bool {
                        storeObject.isOnline = isOnline
                    }
                    
                    store.append(storeObject)
                }
            }
            completion(store)
        }
    }
    
    func checkIfUserExistInFavList(_ userUUID: String , completion: @escaping(_ exist: Bool) -> () ){
        let uuid = DataManager().getUserData()?.userId ?? ""
        ref.child("user").child(uuid).child("fav").observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChild(userUUID){
                completion(true)
            }else{
            completion(false)
            }
        }
    }
    
    func addToFavList(_ userUUID: String ,completion: @escaping(_ message: String? , _ error: String?) -> ()){
        let uuid = DataManager().getUserData()?.userId ?? ""
        ref.child("user").child(uuid).child("fav").child(userUUID).setValue(["id" : userUUID]) {[weak self] error, snapShot in
            if let error = error {
                completion(nil , error.localizedDescription)
            }else{
                self?.ref.child("user").child(userUUID).child("followingStores").child(uuid).setValue(["id" : uuid])
                completion("Store has been added to favourite list" , nil)
            }
        }
    }
    
    func removeFromFavList(_ userUUID: String, completion: @escaping(_ message: String?, _ error: String?) -> Void){
        let uuid = DataManager().getUserData()?.userId ?? ""
        ref.child("user").child(uuid).child("fav").child(userUUID).removeValue {[weak self] error, snapshot in
            if let error = error {
                completion(nil, error.localizedDescription)
            }else{
                self?.ref.child("user").child(userUUID).child("followingStores").child(uuid).removeValue()
                completion("Store has been removed from your favourite list" , nil)
            }
        }
    }
    
    func goOnline(userId: String , lat: Double , long: Double, isOnline: Bool ,completion: @escaping(_ message: String? , _ error: String?) -> ()){
        ref.child("user").child(userId).updateChildValues(["lat" : lat , "lng" : long , "isOnline" : isOnline]) { error, snapshot in
            if let error = error {
                completion(nil , error.localizedDescription)
             return
            }
            var message = ""
            if isOnline == true {
                message = "Customers can find you in the Map and go to your location"
            }else{
                message = "You are now offline and you will not appear in the map"
            }
            completion(message , nil)
        }
    }
    
    func getFCMDeviceUsers(completion: @escaping(_ usersList: [String]?) -> ()){
        let uuid = DataManager().getUserData()?.userId ?? ""
        ref.child("user").child(uuid).child("followingStores").observeSingleEvent(of: .value) { snapshot in
            var deviceTokens = [String]()
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                if let value = snap.value as? [String : Any] {
                    if let id = value["id"] as? String {
                        deviceTokens.append(id)
                    }
                }
            }
            completion(deviceTokens)
        }
    }
    func getUpdatedFCMSOFUsers(usersList: [String], _ completion: @escaping(_ fcmList: [String]?) -> ()){
        var fcmListToReturn = [String]()
        let group = DispatchGroup()
        
            for i in 0..<usersList.count {
                group.enter()
                    let userId = usersList[i]
                ref.child("user").child(userId).observeSingleEvent(of: .value) { snapshot in
                    defer { group.leave() }
                        if let value = snapshot.value as? [String: Any]{
                            if let fcmToken = value["fcmToken"] as? String {
                                fcmListToReturn.append(fcmToken)
                            }
                        }
                    }
                }
        group.notify(queue: .main) {
            completion(fcmListToReturn)
        }
        
    }
    
    func broadcastFCM(_ fcmList: [String] , _ title: String , _ body: String , _ storeId: String){
        let bodyString : [String: Any] = ["body" : body , "title" : title]
        let storeUUID : [String: Any] = ["storeUUID" : storeId]
        let parameter : Parameters = [
            "registration_ids" : fcmList,
            "notification": bodyString,
            "data" : storeUUID
        ]
        let header : HTTPHeaders = ["Authorization" : "Bearer AAAA-Ha2YZY:APA91bGfv2pv2nVlRCatl8UAysAM1y2SXzRlZxAOPdRyfvKbbfj8bPB3ej6jtmO6I-Rx05WIkM3aWvPcSEj7Nt0AVwtEZx_XDsvCwE0iasgl7YVr1OTMUQW416NtKe-6TSMUQ1qCObff"]
        Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            let resp = response.result.value
            print("JSONREsponse:\(String(describing: resp))")
        }
    }
    
    func getStoreData(_ storeUUID: String, completion: @escaping(_ store: [locationDataModel]?) -> ()){
        
        ref.child("user").child(storeUUID).observeSingleEvent(of: .value, with: { snapshot in
            
            var store = [locationDataModel]()
//            for child in snapshot.children {
//                let snap = child as! DataSnapshot
                if let value = snapshot.value as? [String: Any] {
                    
                    var storeObject = locationDataModel()
                    if let bio = value["bio"] as? String {
                        storeObject.bio = bio
                    }
                    if let id = value["id"] as? String {
                        storeObject.userId = id
                    }
                    if let image = value["imageUrl"] as? String {
                        storeObject.imageUrl = image
                    }
                    if let lat = value["lat"] as? Double {
                        storeObject.lat = lat
                    }
                    if let long = value["lng"] as? Double {
                        storeObject.long = long
                    }
                    if let name = value["name"] as? String {
                        storeObject.name = name
                    }
                    if let mobile = value["mobileNo"] as? String {
                        storeObject.mobileNum = mobile
                    }
                    if let isOnline = value["isOnline"] as? Bool {
                        storeObject.isOnline = isOnline
                    }
                    
                    store.append(storeObject)
                }
//            }
            completion(store)
        
        })
    }
    
    func updateProfile(_ imageUrl: String ,_ bio: String , _ name: String, completion: @escaping(_ message: String? , _ error: String?) -> ()){
        let uuid = Auth.auth().currentUser!.uid
        ref.child("user").child(uuid).updateChildValues(["imageUrl" : imageUrl , "bio" : bio , "name" : name]) { error, response in
            if let error = error {
                completion(nil , error.localizedDescription)
            }else{
                completion("Profile Update Successfuly" , nil)
            }
        }
    }
    
        func uploadMedia(image : UIImage ,completion: @escaping (_ url: String?) -> Void) {
            let storageRef = Storage.storage().reference().child("user").child("\(String.random()).png")
           if let uploadData = image.jpegData(compressionQuality: 0.5) {
               storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                   if error != nil {
                       print("error")
                       completion(nil)
                   } else {

                       storageRef.downloadURL(completion: { (url, error) in

                        print(url?.absoluteString ?? "")
                           completion(url?.absoluteString)
                       })
                   }
               }
           }
       }
}

