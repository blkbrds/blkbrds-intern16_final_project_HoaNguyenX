//
//  Api.Products.swift
//  FinalProject
//
//  Created by NXH on 9/25/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import ObjectMapper

extension Api.Products {
    
    @discardableResult
    static func getProducts(idAlbum: String, completion: @escaping Completion) -> Request? {
        let path = Api.Path.Products.path
        return api.request(method: .get, urlString: path, parameters: nil) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let json = data as? JSObject,
                        let response = json["albums"] as? JSObject,
                        let albums = response["data"] as? JSArray
                        else {
                            completion(.failure(Api.Error.json))
                            return
                    }
                    for (index, value) in albums.enumerated() {
                        guard let id = value["id"] as? String else {
                            return
                        }
                        if id == idAlbum {
                            guard let photos = albums[index]["photos"] as? JSObject,
                                let datas = photos["data"] as? JSArray else {
                                    completion(.failure(Api.Error.json))
                                    return
                            }
                            let products: [Product] = Mapper<Product>().mapArray(JSONArray: datas)
                            completion(.success(products))
                        }
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
