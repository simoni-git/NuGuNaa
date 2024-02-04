//
//  LoginInputUserInfoVM.swift
//  NuGuNa
//
//  Created by 시모니 on 1/31/24.
//

import Foundation

class LoginInputUserInfoVM {
    
    let loginURL = "http://3.34.164.96:8000/accounts/login"
    var accessToken: String = ""
    
    struct TokenResponse: Codable {
        let email: String
        let token: Token
        let userName: String
        
        private enum CodingKeys: String, CodingKey {
            case email, token
            case userName = "user_name"
        }
    }
    
    struct Token: Codable {
        let access: String
    }
    
}
