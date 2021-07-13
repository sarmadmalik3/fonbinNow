//
//  DataManager.swift
//  Ma Donuts
//
//  Created by Sarmad Ishfaq on 12/05/2021.
//

import Foundation

class DataManager: NSObject {
    
    func saveUserData(user : localUser){
 
        let userDefaults = UserDefaults.standard
        do {
            try userDefaults.setObject(user, forKey: "KUserObject")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getUserData() -> localUser? {
        let userDefaults = UserDefaults.standard
        do {
            let userObject = try userDefaults.getObject(forKey: "KUserObject", castTo: localUser.self)
            return userObject
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func removeUserData(){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "KUserObject")
    }
    
}
