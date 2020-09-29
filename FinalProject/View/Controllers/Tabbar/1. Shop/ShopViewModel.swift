//
//  ShopViewModel.swift
//  FinalProject
//
//  Created by NXH on 9/21/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import Foundation
import MVVM

final class ShopViewModel: ViewModel {
    
    private var products: [Product] = []
    
    func numberOfItems(inSection section: Int) -> Int {
        // hash code
        return 10
    }
    
    func getProductCell(atIndexPath indexPath: IndexPath) -> ProductCellViewModel? {
        guard 0 <= indexPath.row && indexPath.row < products.count else { return nil }
        return ProductCellViewModel(product: products[indexPath.row])
    }
    
    func getListItems() {
        // work after
    }
}
