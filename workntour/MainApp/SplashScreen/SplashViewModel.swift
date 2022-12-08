//
//  SplashViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 11/5/22.
//

import Foundation
import Combine
import UIKit

/*
 Each implementation of Publisher can decide what to do with each new subscriber. It is a policy decision, not generally a design deficiency. Different Publishers make different decisions. Here are some examples:

 PassthroughSubject doesn't immediately publish anything.
 CurrentValueSubject immediately publishes its current value.
 NSObject.KeyValueObservingPublisher immediately publishes the current value of the observed property if and only if it is created with the .initial option.
 Published.Publisher (which is the type you get for an @Published property) publishes the current value of the property immediately.
 */

class SplashViewModel: EmptyViewModel {}
