//
//  Collection+Extensions.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 6/7/22.
//

import Foundation

public extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Collection where Iterator.Element: Equatable {
    typealias Element = Self.Iterator.Element

    func safeIndex(after index: Index) -> Index? {
        let nextIndex = self.index(after: index)
        return (nextIndex < self.endIndex) ? nextIndex : nil
    }

    func index(afterWithWrapAround index: Index) -> Index {
        return self.safeIndex(after: index) ?? self.startIndex
    }

    func item(after item: Element) -> Element? {
        return self.firstIndex(of: item)
            .flatMap(self.safeIndex(after:))
            .map{ self[$0] }
    }

    func item(afterWithWrapAround item: Element) -> Element? {
        return self.firstIndex(of: item)
            .map(self.index(afterWithWrapAround:))
            .map{ self[$0] }
    }
}

