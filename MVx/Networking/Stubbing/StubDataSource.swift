//
//  StubDataSource.swift
//  MVx
//
//  Created by Evan Anger on 12/8/18.
//  Copyright © 2018 Mighty Strong Software. All rights reserved.
//

import Foundation
import Harvey

class StubDataSource: HarveyDataSourceProtocol {
    func shouldStub(request: URLRequest) -> Bool {
        return true
    }

    func stubbedResponse(for request: URLRequest) -> HarveyResponse? {
        let jsonEncoder = JSONEncoder()
        let data = try! jsonEncoder.encode(LoginResponse(userAccountId: "asdfasdf"))
        return HarveyResponse(url: URL(string: "http://localhost:8888")!, data: data, statusCode: 200, headers: nil)
    }
}
