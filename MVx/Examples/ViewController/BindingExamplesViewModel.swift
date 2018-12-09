//
//  BindingExamplesViewModel.swift
//  MVx
//
//  Created by Evan Anger on 12/3/18.
//  Copyright © 2018 Mighty Strong Software. All rights reserved.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

struct LoginRequest {
    let login: String
    let password: String
}

struct LoginResponse: Codable {
    let userAccountId: String
}

class BindingExamplesViewModel {
    let provider: MoyaProvider<ServicingApi>
    let loginAction = PublishSubject<Void>()
    let loginText = PublishSubject<String>()
    let passwordText = PublishSubject<String>()
    
    var latestLoginRequest: Observable<LoginRequest> {
        return Observable.combineLatest(loginText.asObservable(), passwordText.asObservable()) { (login, password) -> LoginRequest in
            return LoginRequest(login: login, password: password)
        }
    }
    
    var loginResponse: Observable<LoginResponse> {
        return loginAction.asObservable()
            .withLatestFrom(self.latestLoginRequest)
            .flatMap(self.login)
    }
    
    init(provider theProvider: MoyaProvider<ServicingApi>) {
        provider = theProvider
    }
    
    func login(request: LoginRequest) -> Observable<LoginResponse> {
        return self.provider
            .rx.request(.login(user: request.login,password: request.password))
            .asObservable()
            .map(LoginResponse.self)
    }
}
