//
//  ImageCellViewModel.swift
//  FinalProject
//
//  Created by NXH on 9/30/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import Foundation

final class ImageMessageCellViewModel {
    private(set) var url: URL
    private(set) var isOwner: Bool
    
    init(url: URL, isOwner: Bool) {
        self.url = url
        self.isOwner = isOwner
    }
}
