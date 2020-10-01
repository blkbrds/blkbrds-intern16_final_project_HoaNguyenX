//
//  ShopViewModel.swift
//  FinalProject
//
//  Created by NXH on 9/21/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import Foundation
import MVVM

typealias CompletionResultProducts = (Bool) -> Void
final class ShopViewModel: ViewModel {
    
    // MARK: - Properties
    var products: [Product] = []
    var viewer: User?
    // MARK: - Funcitions
    func numberOfItems(inSection section: Int) -> Int {
        return products.count
    }
    
    func getProductCell(atIndexPath indexPath: IndexPath) -> ProductCellViewModel? {
        guard 0 <= indexPath.row && indexPath.row < products.count else { return nil }
        return ProductCellViewModel(product: products[indexPath.row])
    }
    
    func getClothes(completion: @escaping APICompletion) {
        Api.Products.getProducts(idAlbum: FacebookKey.idAlbumClothes) { (result) in
            switch result {
            case .success(let res):
                guard let res = res as? [Product] else { return }
                self.products = res
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getViewer(completion: @escaping FBCompletion) {
        Api.InforUser.getUser { (result) in
           switch result {
           case .success(let res):
               guard let res = res as? User else { return }
               self.viewer = res
               completion(.success)
           case .failure:
            completion(.failure)
           }
       }
    }
    
    func getShoes(completion: @escaping APICompletion) {
        Api.Products.getProducts(idAlbum: FacebookKey.idAlbumShoes) { (result) in
            switch result {
            case .success(let res):
                guard let res = res as? [Product] else { return }
                self.products = res
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
     }
}
