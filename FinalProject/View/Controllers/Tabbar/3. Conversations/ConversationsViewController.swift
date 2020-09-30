//
//  ConversationsViewController.swift
//  FinalProject
//
//  Created by NXH on 9/21/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit
import Firebase

final class ConversationsViewController: ViewController {

    // MARK: - @IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: ConversationsViewModel = ConversationsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabbleView()
        loadApiUser()
        loadApiFriends()
    }

    // MARK: - Private functions
    private func configTabbleView() {
        let nib = UINib(nibName: "ConversationsCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func loadApiFriends() {
        viewModel.getFriends { done in
            if done {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func loadApiUser() {
        viewModel.getUser { done in
            if done {
                self.handleRegister()
            }
        }
    }
    
    private func handleRegister() {
        guard let user = viewModel.getUser() else {
            return
        }
        // create user
        Auth.auth().createUser(withEmail: user.email, password: FirebaseKey.defaulPassword, completion: { (res, error) in
            
            if let _ = error {
                self.handleLogin()
            }
            
            guard let uid = res?.user.uid else {
                return
            }
            
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            let values = ["name": user.name, "email": user.email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, _) in
                if let _ = err {
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
        })
        handleLogin()
    }
    
    private func handleLogin() {
        guard let user = viewModel.getUser() else {
            return
        }
        Auth.auth().signIn(withEmail: user.email, password: FirebaseKey.defaulPassword, completion: { (user, error) in
            if let _ = error {
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
}

extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ConversationsCell else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel.getFriendForIndexPath(atIndexPath: indexPath)
        return cell
    }
}

extension ConversationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController = ChatViewController()
        guard let idReceiver = viewModel.getFriendForIndexPath(atIndexPath: indexPath)?.id, let idSender = viewModel.getUser()?.id,
            let name = viewModel.getFriendForIndexPath(atIndexPath: indexPath)?.name else { return }
        chatViewController.viewModel.nameSender = name
        chatViewController.viewModel.idReceiver = idReceiver
        chatViewController.viewModel.idSender = idSender
        navigationController?.pushViewController(chatViewController)
    }
    
}
