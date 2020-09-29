//
//  LoginViewController.swift
//  FinalProject
//
//  Created by NXH on 9/21/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

final class LoginViewController: ViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginFacebookButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: - Properties
    private var viewModel: LoginViewModel = LoginViewModel()
    
    // MARK: - @Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUIButtonLogin()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Private functions
    private func configUIButtonLogin() {
        loginButton.layer.cornerRadius = 8
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.masksToBounds = true
    }
    
    private func login() {
        viewModel.login { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .failure:
                let alert: UIAlertController = UIAlertController(title: AlertKey.notification, message: AlertKey.loginFailure, preferredStyle: .alert)
                let aletAction: UIAlertAction = UIAlertAction(title: AlertKey.okAction, style: .destructive, handler: nil)
                alert.addAction(aletAction)
                this.present(alert, animated: true, completion: nil)
            case .success:
                AppDelegate.shared.changeRoot(rootType: .tabbar)
            }
        }
    }
}

    
    // MARK: - @IBAction
    @IBAction private func loginFacebookTouchUpInside() {
        login()
    }
    
    @IBAction private func loginButtonTouchUpInside() {
        // TODO - Implement when have admin solution
    }
}

// MARK: - extension
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            passwordTextField.becomeFirstResponder()
        } else {
        }
        return true
    }
}
