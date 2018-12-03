//
//  BindingExamplesViewModel.swift
//  MVx
//
//  Created by Evan Anger on 12/3/18.
//  Copyright © 2018 Mighty Strong Software. All rights reserved.
//

import Foundation
import Moya

class BindingExamplesViewModel {
    let provider: MoyaProvider<PeopleApi>
    init(provider theProvider: MoyaProvider<PeopleApi>) {
        provider = theProvider
    }
}
