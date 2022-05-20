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
/// - none: Should be doing what is says. Nothing.
enum DefaultStep : Step {
    case none
}
