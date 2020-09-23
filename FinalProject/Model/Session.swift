//
//  Session.swift
//  FinalProject
//
//  Created by NXH on 9/22/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import Foundation

//typealias ud = Session.shared.userDefault

final class Session {
    
    static let shared = Session()
    var ud = UserDefaults.standard
    
    private init() {}
    
    var accessToken: String {
        get {
            return ud.string(forKey: UserDefaultKey.accessToken).content
        }
        set {
            ud.set(newValue, forKey: UserDefaultKey.accessToken)
        }
    }
}
