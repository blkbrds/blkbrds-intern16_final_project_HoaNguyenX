//
//  ConversationsViewModel.swift
//  FinalProject
//
//  Created by NXH on 9/21/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import Foundation
import UIKit
import MVVM

final class ConversationsViewModel: ViewModel {
    
    private var friends: [Friends] = []
     var user: User?
    
    func numberOfItems(inSection section: Int) -> Int {
        return friends.count
    }
    
    func getFriends(completion: @escaping CompletionResultProducts) {
        Api.InforUser.getAllFriends { (result) in
           switch result {
           case .success(let res):
               guard let res = res as? [Friends] else { return }
               self.friends = res
               completion(true)
           case .failure(_):
               completion(false)
           }
       }
    }
    
    func getUser(completion: @escaping CompletionResultProducts) {
        Api.InforUser.getUser { (result) in
           switch result {
           case .success(let res):
               guard let res = res as? User else { return }
               self.user = res
               completion(true)
           case .failure(_):
               completion(false)
           }
       }
    }
    
    func getUser() -> User? {
        guard let user = user else {
            return nil
        }
        return user
    }
    
    func getFriendForIndexPath(atIndexPath indexPath: IndexPath) -> ConversationsCellViewModel? {
        guard 0 <= indexPath.row && indexPath.row < friends.count else {
            return nil
        }
        return ConversationsCellViewModel(name: friends[indexPath.row].name, image: friends[indexPath.row].image, id: friends[indexPath.row].id)
    }
}
