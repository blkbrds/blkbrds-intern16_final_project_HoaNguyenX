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
import FirebaseStorage

final class ChatViewModel: ViewModel {
    
    // MARK: - Properties
    private var messages: [Message] = []
    private let db = Firestore.firestore()
    var nameSender: String = ""
    var idSender: String = ""
    var idReceiver: String = ""
    
    // MARK: - Funtions
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
        self.db.collection(idSender).getDocuments { (query, _) in
            guard let query = query else {
                return
            }
            for index in query.documents where index.documentID == self.idReceiver {
                self.db.collection(self.idSender).document(self.idReceiver).collection("sms").order(by: "date").addSnapshotListener { (querySnapshot, error) in
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
                                        return
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            self.db.collection(self.idReceiver).document(self.idSender).collection("sms").order(by: "date").addSnapshotListener { (querySnapshot, error) in
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
        }
        
    }
    
    func postMessageToFirebase(body: String) {
        if let _ = Auth.auth().currentUser?.email {
            self.db.collection(idSender).getDocuments { (query, _) in
                guard let query = query else { return }
                for index in query.documents where index.documentID == self.idReceiver {
                    self.db.collection(self.idSender).document(self.idReceiver).collection("sms").addDocument(data: [
                        "sender": self.idSender,
                        "body": body,
                        "date": Date().timeIntervalSince1970])
                    return
                }
                self.db.collection(self.idReceiver).document(self.idSender).collection("sms").addDocument(data: [
                    "sender": self.idSender,
                    "body": body,
                    "date": Date().timeIntervalSince1970])
                self.db.collection(self.idReceiver).document(self.idSender).setData(["id": self.idSender])
            }
        }
    }
    
    func uploadImageToFirebase(image: UIImage) {
        let random: Int = Int.random(in: 0...99999)
        let ref = Storage.storage().reference().child(idSender).child(idReceiver).child("\(random)")
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (_, error) in
                if error != nil {
                    return
                }
                ref.downloadURL(completion: { (url, err) in
                    if let _ = err {
                        return
                    }
                    self.sendMessageWithImageUrl(url?.absoluteString ?? "")
                })
            })
        }
    }
    
    func sendMessageWithImageUrl(_ imageUrl: String) {}
}

