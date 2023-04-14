//
//  Model.swift
//  Newproject
//
//  Created by Yulya on 23.03.2023.
//

import Foundation
import UIKit



struct Tasks: Codable {
    var result: [Task]?
    var error: String?
}


struct Task: Codable {
    var id: Int?
    var name: String?
    var description: String?
//    var status: Bool?
//    var user: String?
    var type: Int?
//    var token: String?
}


struct AuthBody: Codable {
    var username: String
    var password: String
}


struct AuthToken: Codable {
    var result: String?
    var error: String?
}


enum Category: String, Codable {
    case home = "Дом"
    case work = "Работа"
    case hobby = "Хобби"
    case family = "Семья"
    case friends = "Друзья"
    case holidays = "Отдых"
    case health = "Здоровье"
    
    
    static func fromTypeToCat(type:Int) -> Category {
        switch type {
        case 1: return .home
        case 2: return .work
        case 3: return .hobby
        case 4: return .family
        case 5: return .friends
        case 6: return .holidays
        case 7: return .health
        default: return .home
        }
    }
    
    
    static func fromCatToType(category: Category) -> Int {
        switch category {
        case .home: return 1
        case .work: return 2
        case .hobby: return 3
        case .family: return 4
        case .friends: return 5
        case .holidays: return 6
        case .health: return 7
        default: return 1
        }
    }
}


