//
//  BindingExamplesViewController.swift
//  MVx
//
//  Created by Evan Anger on 12/3/18.
//  Copyright © 2018 Mighty Strong Software. All rights reserved.
//

import Foundation
import Moya
import UIKit
import RxCocoa
import RxOptional
import RxSwift

class DontBindingExamplesViewController: UIViewController {
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginAction: UIButton!
    let disposeBag = DisposeBag()
    
    let viewModel = BindingExamplesViewModel(provider: MoyaProvider<ServicingApi>())
    
    override func viewDidLoad() {
        loginAction.rx.tap
            .bind(to: self.viewModel.loginAction)
            .disposed(by: self.disposeBag)
        
        loginText.rx.text
            .filterNil()
            .bind(to: self.viewModel.loginText)
            .disposed(by: self.disposeBag)
        
        passwordText.rx.text
            .filterNil()
            .bind(to: self.viewModel.passwordText)
            .disposed(by: self.disposeBag)
        
        viewModel
            .loginResponse
            .subscribe(onNext: { (login) in
                debugPrint(login)
            }).disposed(by: self.disposeBag)
    }
}

