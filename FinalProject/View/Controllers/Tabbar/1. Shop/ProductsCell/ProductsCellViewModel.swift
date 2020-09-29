//
//  ProductsCellViewModel.swift
//  FinalProject
//
//  Created by NXH on 9/21/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import Foundation

final class ProductCellViewModel {
    
    // MARK: - Properties
    private(set) var product: Product?
    
    // MARK: - Init
    init(product: Product) {
        self.product?.image = product.image
        self.product?.description = product.description
    }
}
