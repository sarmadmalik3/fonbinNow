//
//  LocationData.swift
//  Fonbin Now
//
//  Created by Sarmad Ishfaq on 01/07/2021.
//

import Foundation



struct locationDataModel {
    var lat: Double = 0
    var long: Double = 0
    var name: String = ""
    var bio: String = ""
    var imageUrl: String = ""
    var userId: String = ""
    var mobileNum: String = ""
    var isOnline: Bool = false
    var isLoggedIn: Bool = false
}

struct localUser : Codable{
    var userId: String = ""
    var name: String = ""
    var bio: String = ""
    var imageUrl: String = ""
    var isLoggedIn: Bool = false
}
