//
//  PeopleApi.swift
//  MVx
//
//  Created by Evan Anger on 12/3/18.
//  Copyright © 2018 Mighty Strong Software. All rights reserved.
//

import Foundation
import Moya

enum PeopleApi {
    case people
}

extension PeopleApi: TargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8888")!
    }
    
    var path: String {
        return "people"
    }
    
    var method: Moya.Method {
        return Moya.Method.get
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        return Task.requestPlain
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
