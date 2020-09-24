//
//  LoginViewModel.swift
//  FinalProject
//
//  Created by NXH on 9/23/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FirebaseAuth
import MVVM

final class LoginViewModel: ViewModel {
    
    // MARK: - Properties
    private let facebookLogin: LoginManager = LoginManager()
    var loginFacebookResult: LoginFacebookResult?
    var connectFacebookToFirebaseResult: ConnectFacebookToFirebaseResult?
    
    // MARK: - Functions
    func login() {
        let vc = LoginViewController()
        facebookLogin.logIn(permissions: [FacebookKey.email], from: vc) { (result, error) in
            if let result = result?.isCancelled, result {
            } else {
                if error == nil {
                    if let token = AccessToken.current, !token.isExpired {
                        Session.shared.accessToken = token.tokenString
                        self.loginFacebookResult = .success
                        self.connectFacebookToFirebase(accessToken: Session.shared.accessToken)
                    }
                } else {
                    self.loginFacebookResult = .failure
                }
            }
        }
    }
    
    func connectFacebookToFirebase(accessToken: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
         Auth.auth().signIn(with: credential) { (_, error) in
             if error != nil {
                self.connectFacebookToFirebaseResult = .failure
                return
             } else {
                self.connectFacebookToFirebaseResult = .success
            }
         }
    }
}

// MARK: - extension
extension LoginViewModel {
    
    enum LoginFacebookResult {
        case success
        case failure
    }
    
    enum ConnectFacebookToFirebaseResult {
        case success
        case failure
    }
}
