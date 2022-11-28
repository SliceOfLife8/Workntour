//
//  Data+Extensions.swift
//  SharedKit
//
//  Created by Chris Petimezas on 28/11/22.
//

import Foundation

public extension Data {
    var prettyString: NSString? {
        return NSString(data: self, encoding: String.Encoding.utf8.rawValue) ?? nil
    }

    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }

    func mimeType() -> String {
        var b: UInt8 = 0
        self.copyBytes(to: &b, count: 1)

        switch b {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x4D, 0x49:
            return "image/tiff"
        case 0x25:
            return "application/pdf"
        case 0xD0:
            return "application/vnd"
        case 0x46:
            return "text/plain"
        default:
            return "application/octet-stream"
        }
    }
}
