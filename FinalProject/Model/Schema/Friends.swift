//
//  Friends.swift
//  FinalProject
//
//  Created by NXH on 9/27/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import Foundation
import ObjectMapper

final class Friends: Mappable {
    
    var name: String = ""
    var image: String = ""
    var id: String = ""
    
    init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        image <- map["picture.data.url"]
        id <- map["id"]
    }
    
}
