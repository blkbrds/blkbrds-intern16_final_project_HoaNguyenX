//
//  Product.swift
//  FinalProject
//
//  Created by NXH on 9/24/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import Foundation
import ObjectMapper

final class Product: Mappable {
    var image: String = ""
    var description: String = ""
    
    init?(map: Map) {
    }
    
    func mapping(map: Map) {
        image <- map["source"]
        description <- map["name"]
    }
}

