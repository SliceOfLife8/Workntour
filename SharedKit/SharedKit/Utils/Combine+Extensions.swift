//
//  Combine+Extensions.swift
//  SharedKit
//
//  Created by Chris Petimezas on 10/5/22.
//

import Combine
import UIKit

extension UITextField {
    /// `UItextField` publisher for KeyPath `text` for events `.allEditingEvents` & `.valueChanged`
    public var textPublisher: AnyPublisher<String?, Never> {
        ControlPublisher(self,
                         controlEvents: [.allEditingEvents, .valueChanged],
                         keyPath: \.text)
            .eraseToAnyPublisher()
    }
}

extension UIButton {
    /// `UIButton` tap publisher for event `.touchUpInside`
    public var tapPublisher: AnyPublisher<Void, Never> {
        ControlEvent(control: self, events: .touchUpInside).eraseToAnyPublisher()
    }
}
