//
//  ExampleDirectory.swift
//  MVx
//
//  Created by Evan Anger on 12/2/18.
//  Copyright © 2018 Mighty Strong Software. All rights reserved.
//

import Foundation
import UIKit

enum Example: CaseIterable {
    case bindingUIToFailable
    case danglingSignals
    case cleaningUpCapturesInClosures
    case overusingVariablesPublishSubjects
}

extension Example {
    var viewcontroler: UIViewController {
        switch self {
        case .bindingUIToFailable:
            let storyboard = UIStoryboard(name: "Binding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Binding")
            return vc
        case .danglingSignals:
            return DanglingSignalViewController()
        case .cleaningUpCapturesInClosures:
            return CaptureClosureViewController()
        case .overusingVariablesPublishSubjects:
            return ImperativeReactiveViewController()
        }
    }
    
    var description: String {
        switch self {
        case .bindingUIToFailable:
            return "Examples of how to bind UI signals to expected failable signals"
        case .danglingSignals:
            return "Usage of 'dangling' signals and how to correct them"
        case .cleaningUpCapturesInClosures:
            return "How to handle captures in closures as well as how to get rid of them."
        case .overusingVariablesPublishSubjects:
            return "Example of how overusing variables can break the reactive nature of your code."
        }
    }
}
