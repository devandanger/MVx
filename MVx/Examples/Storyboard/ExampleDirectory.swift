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
    case dealingWithTime
}

extension Example {
    var viewcontroler: UIViewController {
        switch self {
        case .bindingUIToFailable:
            let storyboard = UIStoryboard(name: "Binding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Binding")
            return vc
        case .danglingSignals:
            let storyboard = UIStoryboard(name: "Dangling", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Dangling")
            return vc
        case .cleaningUpCapturesInClosures:
            let storyboard = UIStoryboard(name: "CaptureClosure", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CaptureClosure")
            return vc
        case .overusingVariablesPublishSubjects:
            let storyboard = UIStoryboard(name: "ImperativeReactive", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ImperativeReactive")
            return vc
        case .dealingWithTime:
            let storyboard = UIStoryboard(name: "DealingWithTime", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DealingWithTime")
            return vc
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

        case .dealingWithTime:
            return "Example of how to dealing with time."
        }
    }
}
