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
    private let facebookLogin: LoginManager = LoginManager()
    
    // MARK: - @Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUIButtonLogin()
    }
    
    // MARK: - Private functions
    private func configUIButtonLogin() {
        loginButton.layer.cornerRadius = 8
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.masksToBounds = true
    }
    
    private func login() {
        facebookLogin.logIn(permissions: ["email"], from: self) { (res, err) in
            if let res = res?.isCancelled, res {
            } else {
                if err == nil {
                    if let token = AccessToken.current, !token.isExpired {
                        Session.shared.accessToken = token.tokenString
                        self.connectFacebookToFireBase(accessToken: Session.shared.accessToken)
                    }
                } else {
                    let alert: UIAlertController = UIAlertController(title: "Thông báo", message: "Đăng nhập thất bại", preferredStyle: .alert)
                    let aletAction: UIAlertAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
                    alert.addAction(aletAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func connectFacebookToFireBase(accessToken: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credential) { (_, error) in
            if error != nil {
                return
            }
        }
    }
    
    // MARK: - @IBAction
    @IBAction private func loginFacebookTouchUpInside() {
        login()
    }
    
    @IBAction private func loginButtonTouchUpInside() {
    }
}
