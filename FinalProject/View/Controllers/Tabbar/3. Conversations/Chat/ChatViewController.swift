//
//  ChatViewController.swift
//  FinalProject
//
//  Created by NXH on 9/21/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit

final class ChatViewController: ViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textInput: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var attachButton: UIButton!
    // MARK: - Properties
    
    var viewModel: ChatViewModel = ChatViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configTextField()
        configNavi()
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "F7F3FD")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    // MARK: - Private functions
    private func configNavi() {
        navigationController?.navigationBar.tintColor = .black
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = viewModel.nameSender
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 23)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setBackgroundImage(#imageLiteral(resourceName: "previous "), for: .normal)
        button.addTarget(self, action: #selector(backButtonTouchUpInside), for: .touchUpInside)
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: button), UIBarButtonItem(customView: label)]
    }
    
    private func configTableView() {
        tabBarController?.tabBar.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        tableView.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
    }
    
    private func configTextField() {
        textInput.layer.cornerRadius = 15
        textInput.delegate = self
    }
    
    private func loadMessages() {
        viewModel.loadMessages() { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                this.tableView.reloadData {
                    let indexPath = IndexPath(row: this.viewModel.numberOfItems(inSection: 0) - 1, section: 0)
                    this.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
            case .failure(let error):
                this.showAlert(title: AlertKey.notification, message: error.localizedDescription)
            }
        }
    }
    
    // MARK: @Objc functions
    @objc private func backButtonTouchUpInside() {
        navigationController?.popViewController()
    }
    
    // MARK: - @IBAction
    @IBAction func sendButtonTouchUpInside(_ sender: UIButton) {
        if textInput.text == "" {
            return
        }
        guard let text = textInput.text else {
            return
        }
        viewModel.postMessageToFirebase(body: text)
        textInput.text = ""
    }
}

// MARK: - extension
extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.getMessageForIndexPaht(atIndexPath: indexPath)?.isOwner == false {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as? ReceiverCell else {
                return UITableViewCell()
            }
            cell.viewModel = viewModel.getMessageForIndexPaht(atIndexPath: indexPath)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as? SenderCell else {
                return UITableViewCell()
            }
            cell.viewModel = viewModel.getMessageForIndexPaht(atIndexPath: indexPath)
            
            return cell
        }
        
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textInput.resignFirstResponder()
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return true
        }
        textField.text = text + "\n"
        return true
    }
}
