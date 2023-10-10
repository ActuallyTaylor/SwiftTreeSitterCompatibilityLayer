//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/8/23.
//

import TreeSitter

public enum InputEncoding: Int {
    case utf8 = 0
    case utf16 = 1
    
    var treeSitterValue: TSInputEncoding {
        switch self {
        case .utf8:
            return TSInputEncodingUTF8
        case .utf16:
            return TSInputEncodingUTF16
        }
    }
    
    var swiftValue: String.Encoding {
        switch self {
        case .utf8:
            return .utf8
        case .utf16:
            return .utf16
        }
    }
}
