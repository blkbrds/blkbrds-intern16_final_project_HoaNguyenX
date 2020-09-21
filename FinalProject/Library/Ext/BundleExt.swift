//
//  BundleExt.swift
//  FinalProject
//
//  Created by MBA0176 on 4/25/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import Foundation

extension Bundle {
    func hasNib(name: String) -> Bool {
        return path(forResource: name, ofType: "nib") != nil
    }
}
