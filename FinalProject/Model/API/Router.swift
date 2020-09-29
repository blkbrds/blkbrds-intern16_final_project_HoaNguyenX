//
//  Router.swift
//  FinalProject
//
//  Created by MBA0176 on 4/24/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import Foundation
import Alamofire

final class Api {
    struct Path {
        static let domain = "https://graph.facebook.com"
        static let baseURL = domain / "v8.0"
    }
    
    struct Products {}
    struct InforUser {}
}

extension Api.Path {
    
    struct Products {
        static let pageID: String = "114366597082557"
        static let fields: String = "albums.fields(photos.fields(source,name))"
        static let pageAccessToken = "EAAEZCsqVFRccBALFxZCf5Bc5iwlo9auZAnrYvZBPqhCALkqatj7mR1G36flCLqdXm3C5T0hHcSbSZCTtJf6dzIBap84Y7uXbfCGLVPmOFyUy4J4VFD3RvyomdlPo3duWZB0yc7mfiFRafSia8EkSMZBFbcrDCT0RJjCkbhan7Jw7cKvZBsZAS0G6TXCVHHSv8rssZD"
        static var path: String {
            return Api.Path.baseURL / "\(pageID)?fields=\(fields)&access_token=\(pageAccessToken)"
        }
    }
    
    struct InforUser {
        static let userID: String = "me"
        static let fieldUser: String = "email,name"
        static var userPath: String {
            return Api.Path.baseURL / "\(userID)?fields=\(fieldUser)&access_token=\(Session.shared.accessToken)"
        }
        static let fieldFriends: String = "friends?fields=name,picture.width(480).height(480)"
        static var allFriendPath: String {
            return Api.Path.baseURL / "\(userID)/\(fieldFriends)&access_token=\(Session.shared.accessToken)"
        }
        
    }
}

protocol URLStringConvertible {
    var urlString: String { get }
}

extension URL: URLStringConvertible {
    var urlString: String { return absoluteString }
}

extension Int: URLStringConvertible {
    var urlString: String { return String(describing: self) }
}

private func / (lhs: URLStringConvertible, rhs: URLStringConvertible) -> String {
    return lhs.urlString + "/" + rhs.urlString
}

extension String: URLStringConvertible {
    var urlString: String { return self }
}

extension CustomStringConvertible where Self: URLStringConvertible {
    var urlString: String { return description }
}
