//
//  ChatViewModel.swift
//  FinalProject
//
//  Created by NXH on 9/21/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import Foundation
import MVVM
import FirebaseFirestore
import Firebase

final class ChatViewModel: ViewModel {
    
    private var messages: [Message] = []
    private let db = Firestore.firestore()
    var nameSender: String = ""
    var idSender: String = ""
    var idReceiver: String = ""
    
    func numberOfItems(inSection section: Int) -> Int {
        return messages.count
    }
    
    func getMessageForIndexPaht(atIndexPath indexPath: IndexPath) -> MessageCellViewModel? {
        guard 0 <= indexPath.row && indexPath.row < messages.count else {
            return nil
        }
        return MessageCellViewModel(body: messages[indexPath.row].body, isOwner: messages[indexPath.row].isOwner)
    }
    
    func loadMessages(completion: @escaping APICompletion) {
        guard let _ = Auth.auth().currentUser?.email else { return }
        
        self.db.collection(idSender).document(idReceiver).collection("sms").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageBody = data["body"] as? String,
                            let sender = data["sender"] as? String {
                            if sender == self.idReceiver {
                                let newMessage = Message(isOwner: false, body: messageBody)
                                self.messages.append(newMessage)
                            } else {
                                let newMessage = Message(isOwner: true, body: messageBody)
                                self.messages.append(newMessage)
                            }
                            DispatchQueue.main.async {
                                completion(.success)
                            }
                        }
                    }
                }
            }
        }
        //        self.db.collection(receiver).document(sender).collection("sms").order(by: "date").addSnapshotListener { (querySnapshot, error) in
        //            self.messages = []
        //            if let error = error {
        //                completion(.failure(error))
        //            } else {
        //                if let snapshotDocuments = querySnapshot?.documents {
        //                    for doc in snapshotDocuments {
        //                        print(doc)
        //                        let data = doc.data()
        //                        if let messageBody = data["body"] as? String,
        //                            let sender = data["sender"] as? String {
        //                            if sender == receiver {
        //                                let newMessage = Message(isOwner: false, body: messageBody)
        //                                self.messages.append(newMessage)
        //                            } else {
        //                                let newMessage = Message(isOwner: true, body: messageBody)
        //                                self.messages.append(newMessage)
        //                            }
        //                            DispatchQueue.main.async {
        //                                completion(.success)
        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //        }
    }
    
    func postMessageToFirebase(body: String) {
        if let _ = Auth.auth().currentUser?.email {
            
            self.db.collection(idReceiver).document(idSender).collection("sms").addDocument(data: [
                "sender": idSender,
                "body": body,
                "date": Date().timeIntervalSince1970])
            self.db.collection(idSender).document(idReceiver).collection("sms").addDocument(data: [
                "sender": idSender,
                "body": body,
                "date": Date().timeIntervalSince1970])
            
        }
    }
}

