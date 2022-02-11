//
//  Models.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-17.
//

enum FieldType {
    case email, password, reg_username, reg_password, reg_passwordVerify
    
    var tag: Int {
        switch self {
      
        case .email:
            return 1
        case .password:
            return 2
        case .reg_username:
            return 3
        case .reg_password:
            return 4
        case .reg_passwordVerify:
            return 5
        }
    }
}

struct FRGenericOPResult {
    var error: Bool = false
    var message: String?
    var data: Any?
}

public enum FRAuthFlowType {
    case normal
    case passwordless
    
    
    var introText: String {
        switch self {
        case .normal:
            return "Please enter your email and password to sign in"
        case .passwordless:
            return "Please enter your email to a send you a passwordless login link"
        }
    }
    
    
    var signInTitle: String {
        switch self {
        case .normal:
            return "Sign In"
        case .passwordless:
            return "Send Link"
        }
    }
}

public typealias AuthGenericOPResult = (Bool, String?, Any?) -> Void
