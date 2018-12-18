//
//  Login.swift
//  MVx
//
//  Created by Evan Anger on 12/18/18.
//  Copyright © 2018 Mighty Strong Software. All rights reserved.
//

import Foundation

struct LoginRequest {
    let login: String
    let password: String
}

struct LoginResponse: Codable {
    let userAccountId: String
}
