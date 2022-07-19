//
//  Step.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 12/5/22.
//

import Foundation

public protocol Step { }

/// A default step to be used in default implementations
///
/// - back: Should be navigate back.
/// - showAlert: Show default alert view.
public enum DefaultStep: Step {
    case back
    case showAlert(title: String, subtitle: String?)
}
